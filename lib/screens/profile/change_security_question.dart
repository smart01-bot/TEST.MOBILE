import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../components/input_fields/ci_field.dart';
import '../../components/input_fields/ci_pass_field.dart';
import '../../components/main_top_bar.dart';
import '../../constants/colors.dart';
import '../../helpers/force_logout.dart';
import '../../services/api_service.dart';
import '../../providers/api_provider.dart';
import '../../providers/auth_provider.dart';
import '../../constants/button_style_main.dart';
import '../../wrappers/authed_wrapper.dart';

class ChangeSecurityQuestionScreen extends StatefulWidget {
  const ChangeSecurityQuestionScreen({super.key});

  @override
  State<ChangeSecurityQuestionScreen> createState() =>
      _ChangeSecurityQuestionScreenState();
}

class _ChangeSecurityQuestionScreenState
    extends State<ChangeSecurityQuestionScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late AuthProvider authProvider;
  late APIProvider apiProvider;

  final _passwordController = TextEditingController();
  final _newQuestion = TextEditingController();
  final _newAnswer = TextEditingController();
  bool _isLoading = false;

  String _formError = "";
  String _passwordFieldError = "";
  String _newQuestionError = "";
  String _newAnswerError = "";

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
        title: "Change Security Question",
      ),
      child: Container(
        padding: EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: Colors.white,
        ),
        child: Column(
          spacing: 0,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: const Text(
                'Confirm your password to change your security question',
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
            CIField(
              inputController: _newQuestion,
              engLabel: "New Security Question",
              swLabel: "Swali Jipya la Usalama",
              placeholder: "Enter your new security question",
              haveError: (_newQuestionError != ""),
            ),
            if (_newQuestionError != "")
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _newQuestionError,
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
            CIField(
              inputController: _newAnswer,
              engLabel: "New Security Answer",
              swLabel: "Jibu Jipya la Usalama",
              placeholder: "Enter your new security answer",
              haveError: (_newAnswerError != ""),
            ),
            if (_newAnswerError != "")
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _newAnswerError,
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
                          if (_isFormValid()) {
                            _handleChangeSecurityQuestions(context);
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
                          'Update Security Question',style: TextStyle(
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
    _newQuestion.dispose();
    _newAnswer.dispose();
    super.dispose();
  }

  bool _isFormValid() {
    _clearErrors();
    bool isValid = true;

    String passwordValue = _passwordController.text;
    String newQuestion = _newQuestion.text;
    String newAnswer = _newAnswer.text;

    if (passwordValue.isEmpty) {
      setState(() {
        _passwordFieldError = "Please enter your password";
      });
      isValid = false;
    }

    if (newQuestion.isEmpty) {
      setState(() {
        _newQuestionError = "Please enter new security question";
      });
      isValid = false;
    }

    if (newAnswer.isEmpty) {
      setState(() {
        _newAnswerError = "Please enter new security answer";
      });
      isValid = false;
    }

    return isValid;
  }

  void _handleChangeSecurityQuestions(context) async {
    _clearErrors();

    final apiProvider = Provider.of<APIProvider>(context, listen: false);
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    final changeSecurityQuestionData = {
      "current_password": _passwordController.text,
      "new_question": _newQuestion.text,
      "new_answer": _newAnswer.text,
    };

    try {
      final response = await ApiService.post(
        'change-security-question',
        token: apiProvider.authToken,
        data: changeSecurityQuestionData,
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
            case "new-question-not-provided":
              setState(() {
                _passwordFieldError = "Please provide new security question";
              });
              break;
            case "new-answer-not-provided":
              setState(() {
                _passwordFieldError = "Please provide new security answer";
              });
              break;
            case "incorrect-password":
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text(
                  'Wrong Password Provide',
                  style: TextStyle(
                    color: CIColors.errorColor,
                  ),
                ),
                backgroundColor: CIColors.errorBox,
              ));
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
            _newQuestion.clear();
            _newAnswer.clear();
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(
                'Your security question was updated successfully',
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
      _newQuestionError = "";
      _newAnswerError = "";
      _formError = "";
    });
  }
}
