import 'package:test_mobile/constants/button_style_danger.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import '../constants/colors.dart';
import '../helpers/force_logout.dart';
import '../providers/api_provider.dart';
import '../providers/overlay_controller.dart';
import '../services/api_service.dart';
import 'input_fields/ci_pass_field.dart';

class AccountDeletionDialog extends StatefulWidget {
  const AccountDeletionDialog({
    super.key,
  });

  @override
  State<AccountDeletionDialog> createState() => _AccountDeletionDialogState();
}

class _AccountDeletionDialogState extends State<AccountDeletionDialog> {
  // Future<String> fetchMarkdown() async {
  final _passwordController = TextEditingController();

  String _passwordFieldError = "";
  String _formError = "";
  String _successMessage = "";

  bool _isLoading = false;

  void _handleAccountDeletion(context) async {
    final apiProvider = Provider.of<APIProvider>(context, listen: false);

    setState(() {
      _isLoading = true;
    });

    final deletionData = {
      "password": _passwordController.text,
    };

    final controller = Provider.of<OverlayProvider>(context, listen: false);

    try {
      controller.showLoadingOverlay();
      final response = await ApiService.post(
        'delete-account',
        token: apiProvider.authToken,
        data: deletionData,
      );
      if (response != null) {
        if (response.containsKey('error')) {
          switch (response['error']) {
            case "unauthorized":
            case "user-not-found":
              controller.hideLoadingOverlay();
              setState(() {
                _formError = 'An error occured. Please try again later';
              });
              Future.delayed(Duration(seconds: 3), () {
                if (mounted) forceLogout(context, mounted, userLoggedOut: true);
              });
              return;
            case "incorrect-password":
              setState(() {
                _passwordFieldError = "Incorrect password provided";
              });
              break;
            case "password-not-provided":
              setState(() {
                _passwordFieldError = "Please provide a password";
              });
              break;
            default:
              setState(() {
                _formError = 'An error occured. Please try again later';
              });
              controller.hideLoadingOverlay();
          }
        } else {
          controller.hideLoadingOverlay();
          setState(() {
            _successMessage =
                'You have succesfully initiated your account deletion process.';
          });
          Future.delayed(Duration(seconds: 3), () {
            if (mounted) forceLogout(context, mounted, userLoggedOut: true);
          });

          return;
        }
      } else {
        
      }
      setState(() {
        _isLoading = false;
      });
      controller.hideLoadingOverlay();
    } catch (e) {
      
      setState(() {
        _formError = 'An error occured. Please try again later';
      });
      controller.hideLoadingOverlay();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: CIColors.canvasBGColor, // Sets the background color
        statusBarIconBrightness:
            Brightness.dark, // Use dark icons if bg is light
        statusBarBrightness: Brightness.light, // iOS status bar behavior
      ),
      child: Dialog.fullscreen(
          child: Material(
        color: CIColors.canvasBGColor,
        child: SafeArea(
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: SingleChildScrollView(
              child: Center(
                child: Column(
                  children: [
                    SizedBox(height: MediaQuery.of(context).padding.top),
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.all(32),
                        child: Image.asset(
                          'assets/card_logo.png', // Add your logo asset
                          fit: BoxFit.contain,
                          width: 120,
                          height: 60,
                        ),
                      ),
                    ),
                    Container(
                      clipBehavior: Clip.hardEdge,
                      margin: EdgeInsets.all(8
                      ),
                      padding: EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 16,
                      ),
                      decoration: BoxDecoration(
                        color: CIColors.whiteColor,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                  height: 16,
                                ),
                                FaIcon(
                                  FontAwesomeIcons.triangleExclamation,
                                  color: CIColors.errorBorder,
                                  size: 30,
                                ),
                                SizedBox(
                                  height: 8,
                                ),
                                Text(
                                  "Account Deletion",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: CIColors.errorText,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                if (_successMessage.isNotEmpty)
                                  SizedBox(
                                    height: 20,
                                  ),
                                if (_successMessage.isNotEmpty)
                                  Container(
                                    width: double.infinity,
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 8,
                                    ),
                                    decoration: BoxDecoration(
                                      color: CIColors.successBox,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          _successMessage,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color: CIColors.successColor,
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                SizedBox(
                                  height: 20,
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 16),
                                  child: Column(
                                    children: [
                                      Text(
                                        "Your account and data will be removed after 60 days. You can cancel this process at any time by logging back into your account.",
                                        textAlign: TextAlign.left,
                                        style: TextStyle(fontSize: 14),
                                      ),
                                      SizedBox(
                                        height: 20,
                                      ),
                                      Text(
                                        "After 60 days are up, your data will be permanently deleted.",
                                        textAlign: TextAlign.left,
                                        style: TextStyle(fontSize: 14),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                // Password Field
                                CIPassField(
                                  inputController: _passwordController,
                                  engLabel: "Confirm your password",
                                  swLabel: "Thibitisha neno la siri",
                                  placeholder: "Enter account password",
                                  haveError: (_passwordFieldError != ""),
                                ),
                                if (_passwordFieldError != "")
                                  Container(
                                    width: double.infinity,
                                    padding: EdgeInsets.symmetric(horizontal: 16),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
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
              
                                if (_formError != "")
                                  Container(
                                    width: double.infinity,
                                    padding: EdgeInsets.symmetric(horizontal: 16),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          _formError,
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
                                SizedBox(
                                  height: 16,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: Text("Cancel")),
                                    SizedBox(
                                      width: 4,
                                    ),
                                    ElevatedButton(
                                        style: dangerButtonStyle,
                                        onPressed: () {
                                          if (_passwordController.text.isEmpty) {
                                            setState(() {
                                              _passwordFieldError =
                                                  "Please provide your account password";
                                            });
                                          } else {
                                            setState(() {
                                              _passwordFieldError = "";
                                            });
                                            _handleAccountDeletion(context);
                                          }
                                        },
                                        child: _isLoading
                                            ? SizedBox(
                                                width: 20,
                                                height: 20,
                                                child: CircularProgressIndicator(
                                                  strokeWidth: 2,
                                                  color: Colors.white,
                                                ),
                                              )
                                            : Text("Delete Account", style: TextStyle(fontSize: 14,),)),
                                  ],
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      )
          // =========

          ),
    );
  }
}
