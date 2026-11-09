import 'package:flutter/material.dart';

import '../../constants/colors.dart';
import '../../wrappers/non_authed_wrapper.dart';

class AccountChooser extends StatefulWidget {
  const AccountChooser({super.key});

  @override
  State<AccountChooser> createState() => _AccountChooserState();
}

class _AccountChooserState extends State<AccountChooser> {
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
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
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

                      const SizedBox(height: 20),

                      Text(
                        "Choose Account Type",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: CIColors.textColor,
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 30),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTapDown: (_) =>
                                setState(() => isPersonalPressed = true),
                            onTapUp: (_) =>
                                setState(() => isPersonalPressed = false),
                            onTapCancel: () =>
                                setState(() => isPersonalPressed = false),
                            onTap: () {
                              Navigator.pushReplacementNamed(context, '/login');
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: isPersonalPressed
                                    ? CIColors.inputFocusFillColor
                                    : CIColors.inputFillColor,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  width: 2,
                                  color: isPersonalPressed
                                      ? CIColors.primaryColor
                                      : CIColors.accentColor,
                                ),
                              ),
                              width: 150,
                              height: 150,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Opacity(
                                    opacity: isPersonalPressed ? 1 : .8,
                                    child: Image.asset(
                                        width: 50,
                                        height: 50,
                                        'assets/personal_account_chooser.png'),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    "Personal",
                                    style: TextStyle(
                                      color: isPersonalPressed
                                          ? CIColors.primaryColor
                                          : CIColors.accentColor,
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 16,
                          ),
                          GestureDetector(
                            onTapDown: (_) =>
                                setState(() => isBusinessPressed = true),
                            onTapUp: (_) =>
                                setState(() => isBusinessPressed = false),
                            onTapCancel: () =>
                                setState(() => isBusinessPressed = false),
                            onTap: () {
                              Navigator.pushReplacementNamed(
                                  context, '/login-business');
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: isBusinessPressed
                                    ? CIColors.inputFocusFillColor
                                    : CIColors.inputFillColor,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  width: 2,
                                  color: isBusinessPressed
                                      ? CIColors.primaryColor
                                      : CIColors.accentColor,
                                ),
                              ),
                              width: 150,
                              height: 150,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Opacity(
                                    opacity: isBusinessPressed ? 1 : .8,
                                    child: Image.asset(
                                        width: 50,
                                        height: 50,
                                        'assets/business_account_chooser.png'),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    "Asset Financing",
                                    style: TextStyle(
                                      color: isBusinessPressed
                                          ? CIColors.primaryColor
                                          : CIColors.accentColor,
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
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
}
