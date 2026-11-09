import 'package:flutter/material.dart';

import '../../components/input_fields/ci_pass_field.dart';
import '../../constants/colors.dart';
import '../../constants/button_style_main.dart';
import '../../wrappers/non_authed_wrapper.dart';

class SetNewPasswordBusinessScreen extends StatefulWidget {
  const SetNewPasswordBusinessScreen({super.key});

  @override
  SetNewPasswordBusinessScreenState createState() =>
      SetNewPasswordBusinessScreenState();
}

class SetNewPasswordBusinessScreenState
    extends State<SetNewPasswordBusinessScreen> {
  final _passwordController = TextEditingController();
  final _passwordConfirmController = TextEditingController();

  bool _isLoading = false;

  String _formError = "";
  String _passwordFieldError = "";
  String _passwordCFieldError = "";

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
                          borderRadius: BorderRadius.circular(16),
                          color: Colors.white,
                          border: Border.all(
                            color: Color(0x66afcbe8), // Border color
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
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Set New Password',
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

                            // password
                            CIPassField(
                              inputController: _passwordController,
                              engLabel: "New Password",
                              swLabel: "Neno Siri Jipya",
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

                            const SizedBox(height: 12),

                            // confirm password
                            CIPassField(
                              inputController: _passwordConfirmController,
                              engLabel: "Confirm New Password",
                              swLabel: "Thibitisha Neno Siri Jipya",
                              placeholder: "Confirm password",
                              haveError: (_passwordCFieldError != ""),
                            ),
                            if (_passwordCFieldError != "")
                              Container(
                                width: double.infinity,
                                padding: EdgeInsets.symmetric(horizontal: 16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      _passwordCFieldError,
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
                                    tapTargetSize:
                                        MaterialTapTargetSize.shrinkWrap,
                                  ),
                                  onPressed: () {
                                    Navigator.pushReplacementNamed(
                                        context, '/login-business');
                                  },
                                  icon: const Icon(
                                    Icons.arrow_back,
                                    color: CIColors.secondaryColor,
                                  ),
                                  label: Text(
                                    'Login instead',
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
                                  style:mainButtonStyle,
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
                                          'Log In',
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
    _passwordController.dispose();
    _passwordConfirmController.dispose();
    super.dispose();
  }

  bool _isFormValid() {
    _clearErrors();
    bool isValid = true;

    String passwordValue = _passwordController.text;
    String passwordCValue = _passwordConfirmController.text;

    if (passwordValue.isEmpty) {
      setState(() {
        _passwordFieldError = "Please enter password";
      });
      isValid = false;
    } else if (passwordValue.length < 8) {
      setState(() {
        _passwordFieldError = "Password must be at least 8 characters long";
      });
      isValid = false;
    }

    if (passwordCValue.isEmpty) {
      setState(() {
        _passwordCFieldError = "Please confirm password";
      });
      isValid = false;
    } else if (passwordCValue != passwordValue) {
      setState(() {
        _passwordCFieldError = "Passwords do not match";
      });
      isValid = false;
    }

    return isValid;
  }

  void _handleLogin() {
    _clearErrors();
    setState(() {
      _isLoading = true;
    });
  }

  void _clearErrors() {
    setState(() {
      _passwordFieldError = "";
      _passwordCFieldError = "";
      _formError = "";
    });
  }
}
