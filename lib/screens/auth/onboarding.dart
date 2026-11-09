import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../constants/colors.dart';
import '../../wrappers/non_authed_wrapper.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  bool isPersonalPressed = false;
  bool isBusinessPressed = false;

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
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height -
                      MediaQuery.of(context).padding.top,
                  padding: EdgeInsets.all(32),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // Logo
                              Center(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20),
                                  child: Image.asset(
                                    'assets/card_logo.png', // Add your logo asset
                                    fit: BoxFit.contain,
                                    width: 120,
                                    height: 60,
                                  ),
                                ),
                              ),

                              const SizedBox(height: 50),
                              Text(
                                "Welcome to the \nTEST App",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Color(0xff47688b),
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 20),
                              SizedBox(
                                width: 300,
                                child: Text(
                                  "Create an account to apply for loans, track application progress, and receive updates from financial institutions — all in one place. ",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: CIColors.textColor,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 20),
                              SizedBox(
                                width: 300,
                                child: Text(
                                  "Our platform makes managing your loan journey fast and easy.",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: CIColors.textColor,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      ElevatedButton.icon(
                        onPressed: () {
                          Navigator.pushReplacementNamed(context, '/login');
                        },
                        style: ElevatedButton.styleFrom(
                          elevation: 0,
                          minimumSize: const Size(250, 10),
                          backgroundColor: CIColors.secondaryColor,
                          textStyle: TextStyle(color: CIColors.whiteColor),
                        ),
                        icon: FaIcon(FontAwesomeIcons.arrowRightToBracket),
                        label: Text(
                          'Continue to Account',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(height: 4),
                      ElevatedButton.icon(
                        onPressed: () {
                          Navigator.pushReplacementNamed(
                              context, '/register-chooser-personal');
                        },
                        style: ElevatedButton.styleFrom(
                          elevation: 0,
                          minimumSize: const Size(250, 40),
                          backgroundColor: CIColors.primaryColor,
                          textStyle: TextStyle(color: CIColors.whiteColor),
                        ),
                        icon: FaIcon(FontAwesomeIcons.userPlus),
                        label: Text(
                          'New Here? Join Us',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
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
            ),
          )
        ],
      ),
    );
  }
}
