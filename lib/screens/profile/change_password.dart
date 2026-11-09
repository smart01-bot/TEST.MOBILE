import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../components/input_fields/ci_pass_field.dart';
import '../../components/main_top_bar.dart';
import '../../constants/colors.dart';
import '../../helpers/force_logout.dart';
import '../../services/api_service.dart';
import '../../providers/api_provider.dart';
import '../../providers/auth_provider.dart';
import '../../constants/button_style_main.dart';
import '../../wrappers/authed_wrapper.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late AuthProvider authProvider;
  late APIProvider apiProvider;

  final _passwordController = TextEditingController();
  final _nPasswordController = TextEditingController();
  final _cPasswordController = TextEditingController();
  bool _isLoading = false;

  String _formError = "";
  String _passwordFieldError = "";
  String _nPasswordFieldError = "";
  String _cPasswordFieldError = "";

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      apiProvider = Provider.of<APIProvider>(context, listen: false);
      authProvider = Provider.of<AuthProvider>(context, listen: false);
      // fetchProfileData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return AuthedWrapper(
      scaffoldKey: _scaffoldKey,
      appBar: MainTopBar(
        scaffoldKey: _scaffoldKey,
        title: "Change Password",
      ),
      child: Container(
        padding: EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: Colors.white,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: const Text(
                'Enter your current password and the new one below',
                style: TextStyle(),
              ),
            ),
            SizedBox(height: 8),
            // Password Field
            CIPassField(
              inputController: _passwordController,
              engLabel: "Current Password",
              swLabel: "Neno la Siri la Sasa",
              placeholder: "Enter your current password",
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
            SizedBox(height: 8),
            // New Password Field
            CIPassField(
              inputController: _nPasswordController,
              engLabel: "New Password",
              swLabel: "Neno la Siri Jipya",
              placeholder: "Enter your new password",
              haveError: (_nPasswordFieldError != ""),
            ),
            if (_nPasswordFieldError != "")
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _nPasswordFieldError,
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
            SizedBox(height: 8),
            // Confirm New Password Field
            CIPassField(
              inputController: _cPasswordController,
              engLabel: "Confirm New Password",
              swLabel: "Thibitisha Neno la Siri Jipya",
              placeholder: "Confirm you new password",
              haveError: (_cPasswordFieldError != ""),
            ),
            if (_cPasswordFieldError != "")
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _cPasswordFieldError,
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
            SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SizedBox(width: 24),
                ElevatedButton(
                  onPressed: _isLoading
                      ? null
                      : () {
                          if (_isFormValid()) _handleChangePassword(context);
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
                          'Update Your Password',style: TextStyle(
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
    );
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _nPasswordController.dispose();
    _cPasswordController.dispose();
    super.dispose();
  }

  bool _isFormValid() {
    _clearErrors();
    bool isValid = true;

    String passwordValue = _passwordController.text;
    String nPasswordValue = _nPasswordController.text;
    String cPasswordValue = _cPasswordController.text;

    if (passwordValue.isEmpty) {
      setState(() {
        _passwordFieldError = "Please enter your current password";
      });
      isValid = false;
    }

    if (nPasswordValue.isEmpty) {
      setState(() {
        _nPasswordFieldError = "Please enter your new password";
      });
      isValid = false;
    }

    if (nPasswordValue.length < 8) {
      setState(() {
        _nPasswordFieldError = "Password must be at least 8 characters long";
      });
      isValid = false;
    }

    if (cPasswordValue.isEmpty) {
      setState(() {
        _cPasswordFieldError = "Confirm your new password";
      });
      isValid = false;
    }

    if (nPasswordValue != cPasswordValue) {
      setState(() {
        _cPasswordFieldError = "Passwords do not match";
      });
      isValid = false;
    }

    return isValid;
  }

  void _handleChangePassword(context) async {
    _clearErrors();

    final apiProvider = Provider.of<APIProvider>(context, listen: false);
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    final changePasswordData = {
      "old_password": _passwordController.text,
      "new_password": _nPasswordController.text,
      "confirm_new_password": _cPasswordController.text,
    };

    try {
      final response = await ApiService.post(
        'change-password',
        token: apiProvider.authToken,
        data: changePasswordData,
      );
      if (response != null) {
        if (response.containsKey('error')) {
          switch (response['error']) {
            case "unauthorized":
              WidgetsBinding.instance.addPostFrameCallback((_) {
                forceLogout(context, mounted);
              });
              return;
            case "current-password-not-provided":
              setState(() {
                _passwordFieldError = "Please provide your current password";
              });
              break;
            case "new-password-not-provided":
              setState(() {
                _nPasswordFieldError = "Please provide a new password";
              });
              break;
            case "invalid-new-password":
              setState(() {
                _nPasswordFieldError = "Must be at least 8 characters long";
              });
              break;
            case "new-password-not-confirmed":
              setState(() {
                _cPasswordFieldError = "Please confirm your new password";
              });
              break;
            case "passwords-do-not-match":
              setState(() {
                _cPasswordFieldError = "Passwords do not match";
              });
              break;
            case "incorrect-old-password":
              setState(() {
                _passwordFieldError = "Incorrect current password";
              });
              break;
            default:
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text(
                  'An error occured. Please try again later',
                  style: TextStyle(
                    color: CIColors.errorColor,
                  ),
                ),
                backgroundColor: CIColors.errorBox,
              ));
          }
        } else {
          if (response.containsKey('success')) {
            _passwordController.clear();
            _nPasswordController.clear();
            _cPasswordController.clear();
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(
                'Your password has been updated successfully',
                style: TextStyle(
                  color: CIColors.successColor,
                ),
              ),
              backgroundColor: CIColors.successBox,
            ));
          }
        }
      } else {
        // Request not sent
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
            'An error occured. Please try again',
            style: TextStyle(
              color: CIColors.errorColor,
            ),
          ),
          backgroundColor: CIColors.errorBox,
        ));
      }
      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          'An error occured. Please try again later',
          style: TextStyle(
            color: CIColors.errorColor,
          ),
        ),
        backgroundColor: CIColors.errorBox,
      ));
    }
  }

  void _clearErrors() {
    setState(() {
      _passwordFieldError = "";
      _nPasswordFieldError = "";
      _cPasswordFieldError = "";
      _formError = "";
    });
  }
}
