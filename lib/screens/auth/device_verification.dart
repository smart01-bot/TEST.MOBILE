import 'dart:convert';

import 'package:test_mobile/helpers/get_device_details.dart';
import 'package:test_mobile/wrappers/non_authed_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../components/input_fields/ci_field.dart';
import '../../constants/colors.dart';
import '../../providers/api_provider.dart';
import '../../providers/auth_provider.dart';
import '../../services/api_service.dart';
import '../../constants/button_style_main.dart';

class DeviceVerificationScreen extends StatefulWidget {
  const DeviceVerificationScreen({super.key});

  @override
  DeviceVerificationScreenState createState() =>
      DeviceVerificationScreenState();
}

class DeviceVerificationScreenState extends State<DeviceVerificationScreen> {
  final _verifCodeController = TextEditingController();

  bool _isLoading = false;

  String _formError = "";
  String _codeFieldError = "";
  String _userEmail = '';

  bool _isInitialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!_isInitialized) {
      if (_userEmail.isEmpty) {
        final args =
            ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
        if (args != null && args.containsKey("email")) {
          final String userEmail = args["email"];
          print(args);
          setState(() {
            _userEmail = userEmail;
          });
          _isInitialized = true;
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

    return NonAuthedWrapper(
      child: SingleChildScrollView(
        physics: ClampingScrollPhysics(),
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 24),
              // Logo
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Image.asset(
                    'assets/card_logo.png', // Add your logo asset
                    fit: BoxFit.contain,
                    width: 120,
                    height: 58,
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Form error
              if (_formError != "")
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(8),
                  margin: EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: Color(0xFFFCE0E0),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    _formError,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: CIColors.errorColor,
                      fontSize: 14,
                    ),
                  ),
                ),
              if (_formError != "") const SizedBox(height: 12),

              Container(
                padding: EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  color: Colors.white,
                  border: Border.all(
                    color: CIColors.inputBorderColor, // Border color
                    width: 1.0,
                    // Border width
                  ),
                ),
                child: Column(
                  children: [
                    SizedBox(
                      width: double.infinity,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: Row(
                          textBaseline: TextBaseline.alphabetic,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.baseline,
                          children: [
                            Text(
                              "Verify it's you ",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(width: 16),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 12,
                    ),

                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 4),
                      child: Text(
                        'A One-Time Passcode (OTP) has been sent to your registered mobile number and email. Please key it in below.',
                        style: const TextStyle(
                          color: CIColors.secondaryColor,
                          fontWeight: FontWeight.w500,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),

                    const SizedBox(height: 0),

                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 4),
                      child: Text(
                        'Nambari ya Siri ya muda mfupi (OTP) imetumwa kwenye namba yako na barua pepe yako iliyosajiliwa. Tafadhali iingize hapa chini.',
                        style: const TextStyle(
                          color: CIColors.accentColor,
                          fontWeight: FontWeight.w500,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),

                    const SizedBox(height: 12),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 4),
                      child: Row(
                        textBaseline: TextBaseline.alphabetic,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        children: [
                          const Text(
                            "Reference prefix is: ",
                            style: TextStyle(
                              color: CIColors.accentColor,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            args?['prefix'] ?? '',
                            style: const TextStyle(
                              color: CIColors.secondaryColor,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 12),

                    // Email Field
                    CIField(
                      inputController: _verifCodeController,
                      engLabel: "Verification Code",
                      swLabel: "Namba ya Uthibitisho",
                      placeholder: "Enter verification code",
                      onlyDigits: true,
                      haveError: (_codeFieldError != ""),
                    ),
                    if (_codeFieldError != "")
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _codeFieldError,
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                color: CIColors.errorText,
                                fontSize: 14,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ],
                        ),
                      ),

                    const SizedBox(height: 20),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton.icon(
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.zero,
                            minimumSize: Size.zero,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          onPressed: () {
                            _handleResendCode(context);
                          },
                          icon: const Icon(
                            Icons.replay,
                            color: CIColors.secondaryColor,
                          ),
                          label: Text(
                            'Resend Code',
                            style: TextStyle(color: CIColors.secondaryColor),
                          ),
                        ),
                        const SizedBox(width: 24),
                        ElevatedButton(
                          onPressed: _isLoading
                              ? null
                              : () {
                                  if (_isFormValid()) {
                                    _handleVerify(context, args?['prefix']);
                                  }
                                },
                          style: mainButtonStyle,
                          child: _isLoading
                              ? SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                              : Text(
                                  'Verify',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                  ),
                                ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
              Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 24.0),
                  child: Text(
                    '©2025 C.A.R.D. Informatics Ltd.\n All Rights Reserved',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: CIColors.accentColor,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _verifCodeController.dispose();
    super.dispose();
  }

  bool _isFormValid() {
    _clearErrors();
    bool isValid = true;

    String codeValue = _verifCodeController.text;

    if (codeValue.isEmpty) {
      setState(() {
        _codeFieldError = "Please enter the 6-digit code you received";
      });
      isValid = false;
    } else if (codeValue.length != 6) {
      setState(() {
        _codeFieldError = "Code should be 6 digits long";
      });
      isValid = false;
    }

    return isValid;
  }

  void _handleVerify(context, String prefix) async {
    _clearErrors();

    final apiProvider = Provider.of<APIProvider>(context, listen: false);
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    setState(() {
      _isLoading = true;
    });
    final deviceData = await getDeviceDetails();

    final verificationData = {
      "prefix": prefix,
      "code": _verifCodeController.text,
      "email": _userEmail,
      "device-data": jsonEncode(deviceData),
    };

    try {
      final response = await ApiService.post(
        'verify-new-device',
        data: verificationData,
      );
      if (response != null) {
        if (response.containsKey('error')) {
          print(response);
          switch (response['error']) {
            // case "unauthorized":
            //   apiProvider.resetToken();
            //   authProvider.logout();
            //   setState(() {
            //     _formError = "Your session has expired. Please login";
            //   });
            //   Navigator.pushReplacementNamed(context, '/login');
            case "invalid-code":
              setState(() {
                _codeFieldError =
                    "The code you provided is invalid or has already expired";
              });
              break;
            default:
              setState(() {
                _formError = "An error occured. Please try again later";
              });
          }
        } else {
          apiProvider.authToken = response["auth-token"];
          authProvider.login();

          Navigator.pushReplacementNamed(context, '/');
          return;
        }
      }
      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _formError = "An error occured. Please try again.";
      });
    }
  }

  void _handleResendCode(
    context,
  ) async {
    _clearErrors();

    final apiProvider = Provider.of<APIProvider>(context, listen: false);
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    setState(() {
      _isLoading = true;
    });

    try {
      final response = await ApiService.post(
        'resend-account-verification-code',
        data: {
          "email": _userEmail,
        },
      );
      if (response != null) {
        if (response.containsKey('error')) {
          switch (response['error']) {
            // case "unauthorized":
            //   setState(() {
            //     _formError = "Your session has expired. Please login";
            //   });
            // Navigator.pushReplacementNamed(context, '/login');
            case "email-address-does-not-exist":
              setState(() {
                _formError = "Failed...";
              });
              break;
            default:
              setState(() {
                _formError = "An error occured. Please try again later";
              });
          }
        } else {
          switch (response['success']) {
            case "email-verification-sent":
              Navigator.pushReplacementNamed(
                context,
                '/verify-account',
                arguments: {
                  'prefix': response['prefix'],
                  'email': _userEmail,
                },
              );
              return;
          }
        }
      } else {
        //
      }
      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      print(e);
      setState(() {
        _formError = "An error occured. Please try again. ";
      });
    }
  }

  void _clearErrors() {
    setState(() {
      _codeFieldError = "";
      _formError = "";
    });
  }
}
