import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../components/input_fields/ci_field.dart';
import '../../components/input_fields/ci_pass_field.dart';
import '../../constants/colors.dart';
import '../../constants/button_style_main.dart';
import '../../helpers/get_device_details.dart';
import '../../providers/api_provider.dart';
import '../../providers/auth_provider.dart';
import '../../services/api_service.dart';
import '../../wrappers/non_authed_wrapper.dart';

class LoginBusinessScreen extends StatefulWidget {
  const LoginBusinessScreen({super.key});

  @override
  LoginBusinessScreenState createState() => LoginBusinessScreenState();
}

class LoginBusinessScreenState extends State<LoginBusinessScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isLoading = false;

  String _formError = "";
  String _emailFieldError = "";
  String _passwordFieldError = "";

  @override
  Widget build(BuildContext context) {
    return NonAuthedWrapper(
      child: Column(
        children: [
          Expanded(
            flex: 1,
            child: Container(
              color: CIColors.canvasBGColor,
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
                            width: 180,
                            height: 90,
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
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 12),
                                child: Row(
                                  textBaseline: TextBaseline.alphabetic,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment:
                                      CrossAxisAlignment.baseline,
                                  children: [
                                    Text(
                                      'Login',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    Text(
                                      'Asset Financing',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: CIColors.accentColor,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),

                            const SizedBox(height: 12),

                            // Email Field
                            CIField(
                              inputController: _emailController,
                              engLabel: "Email/Mobile Number ",
                              swLabel: "Barua Pepe/Namba ya simu",
                              placeholder: "Email or Phone: (+255 XXX XXX XXX)",
                              haveError: (_emailFieldError != ""),
                            ),
                            if (_emailFieldError != "")
                              Container(
                                width: double.infinity,
                                padding: EdgeInsets.symmetric(horizontal: 16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      _emailFieldError,
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

                            const SizedBox(height: 12),

                            // Password Field
                            CIPassField(
                              inputController: _passwordController,
                              engLabel: "Password",
                              swLabel: "Neno la Siri",
                              placeholder: "Enter password",
                              haveError: (_passwordFieldError != ""),
                            ),
                            if (_passwordFieldError != "")
                              Container(
                                width: double.infinity,
                                padding: EdgeInsets.symmetric(horizontal: 16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      _passwordFieldError,
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

                            const SizedBox(height: 16),
                            // Reset Password Link
                            Align(
                              alignment: Alignment.centerRight,
                              child: TextButton(
                                style: TextButton.styleFrom(
                                  padding: EdgeInsets.zero,
                                  minimumSize: Size.zero,
                                  tapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                ),
                                onPressed: () {
                                  Navigator.pushNamed(
                                      context, '/reset-password-business');
                                },
                                child: Text(
                                  'Reset Password',
                                  style: TextStyle(
                                    color: CIColors.secondaryColor,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(
                                  "Don't have an account? ",
                                  style: TextStyle(color: CIColors.accentColor),
                                ),
                                TextButton(
                                  style: TextButton.styleFrom(
                                    padding: EdgeInsets.zero,
                                    minimumSize: Size.zero,
                                    tapTargetSize:
                                        MaterialTapTargetSize.shrinkWrap,
                                  ),
                                  onPressed: () {
                                    Navigator.pushNamed(
                                        context, '/register-business');
                                  },
                                  child: Text(
                                    'Register',
                                    style: TextStyle(
                                      color: CIColors.secondaryColor,
                                      fontSize: 16,
                                    ),
                                  ),
                                )
                              ],
                            ),

                            const SizedBox(height: 24),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                TextButton.icon(
                                  style: TextButton.styleFrom(
                                    padding: EdgeInsets.zero,
                                    minimumSize: Size.zero,
                                    tapTargetSize:
                                        MaterialTapTargetSize.shrinkWrap,
                                  ),
                                  onPressed: () {
                                    Navigator.pushReplacementNamed(
                                        context, '/account-chooser');
                                  },
                                  icon: const Icon(
                                    Icons.arrow_back,
                                    color: CIColors.secondaryColor,
                                  ),
                                  label: Text(
                                    'Choose Account Type',
                                    style: TextStyle(
                                        color: CIColors.secondaryColor),
                                  ),
                                ),
                                const SizedBox(width: 24),
                                ElevatedButton(
                                  onPressed: _isLoading
                                      ? null
                                      : () {
                                          if (_isFormValid()) _handleLogin();
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
                                          'Login',
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
                            '©${DateTime.now().year} C.A.R.D. Informatics Ltd.\nAll Rights Reserved',
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
            ),
          )
        ],
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  bool _isFormValid() {
    _clearErrors();
    bool isValid = true;

    String emailValue = _emailController.text;
    String passwordValue = _passwordController.text;

    if (emailValue.isEmpty) {
      setState(() {
        _emailFieldError = "Field cannot be empty";
      });
      isValid = false;
    }

    if (passwordValue.isEmpty) {
      setState(() {
        _passwordFieldError = "Please enter your password";
      });
      isValid = false;
    }

    return isValid;
  }

  void _handleLogin() async {
    _clearErrors();

    final apiProvider = Provider.of<APIProvider>(context, listen: false);
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    setState(() {
      _isLoading = true;
    });

    final deviceData = await getDeviceDetails();

    final loginData = {
      "email": _emailController.text,
      "password": _passwordController.text,
      "device-data": jsonEncode(deviceData),
    };

    try {
      final response = await ApiService.post(
        'login-business',
        data: loginData,
      );
      if (response != null) {
        if (response.containsKey('error')) {
          switch (response['error']) {
            case "already-logged-in":
              Navigator.pushNamed(context, '/');
              return;
            case "account-locked":
              setState(() {
                _formError =
                    "This account has been locked. Please contact us for further details. \nPhone: +255 222 610 310 \nEmail: info@cardinformatics.co.tz";
              });
              break;
            case "invalid-email-address":
              setState(() {
                _emailFieldError = "Please provide a valid email address";
              });
              break;
            case "password-not-provided":
              setState(() {
                _passwordFieldError = "Please provide a password";
              });
              break;
            case "user-does-not-exist":
            case "incorrect-password":
              setState(() {
                _formError = "Incorrect username or password";
              });
              break;
            default:
              setState(() {
                _formError = "An error occured. Please try again later";
              });
          }
        } else if (response.containsKey('redirect-otp')) {
          Navigator.pushReplacementNamed(context, '/verify-device', arguments: {
            'email': _emailController.text,
            'prefix': response['data']['prefix']
          });
          return;
        } else {
          apiProvider.authToken = response["auth-token"];
          authProvider.accountType = "business";
          authProvider.login();
          Navigator.pushReplacementNamed(context, '/business/dashboard');
          return;
        }
      } else {
        //
      }
      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _formError = "An error occured. Please try again.";
        _isLoading = false;
      });
    }
  }

  void _clearErrors() {
    setState(() {
      _emailFieldError = "";
      _passwordFieldError = "";
      _formError = "";
    });
  }
}