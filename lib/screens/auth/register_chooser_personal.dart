import 'package:flutter/material.dart';

import '../../constants/colors.dart';
import '../../wrappers/non_authed_wrapper.dart';

class RegisterChooserPersonalScreen extends StatefulWidget {
  const RegisterChooserPersonalScreen({super.key});

  @override
  RegisterChooserPersonalScreenState createState() =>
      RegisterChooserPersonalScreenState();
}

class RegisterChooserPersonalScreenState
    extends State<RegisterChooserPersonalScreen> {
  bool isTanzanianPressed = false;
  bool isForeignerPressed = false;

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
                                child: Row(
                                  textBaseline: TextBaseline.alphabetic,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment:
                                      CrossAxisAlignment.baseline,
                                  children: [
                                    Text(
                                      'Register',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    Text(
                                      'Personal Account',
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
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                GestureDetector(
                                  onTapDown: (_) =>
                                      setState(() => isTanzanianPressed = true),
                                  onTapUp: (_) => setState(
                                      () => isTanzanianPressed = false),
                                  onTapCancel: () => setState(
                                      () => isTanzanianPressed = false),
                                  onTap: () {
                                    Navigator.pushReplacementNamed(context,
                                        '/register-personal-tanzanian');
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: isTanzanianPressed
                                          ? Color(0xffd2e8ff)
                                          : Color(0xfff6fbff),
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                        width: 2,
                                        color: isTanzanianPressed
                                            ? Color(0xff003977)
                                            : CIColors.accentColor,
                                      ),
                                    ),
                                    width: 145,
                                    height: 145,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Opacity(
                                          opacity: isTanzanianPressed ? 1 : .8,
                                          child: Image.asset(
                                              width: 50,
                                              height: 50,
                                              'assets/tanzania_map.png'),
                                        ),
                                        SizedBox(height: 4),
                                        Text(
                                          "Tanzanian",
                                          style: TextStyle(
                                            color: isTanzanianPressed
                                                ? Color(0xff003977)
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
                                      setState(() => isForeignerPressed = true),
                                  onTapUp: (_) => setState(
                                      () => isForeignerPressed = false),
                                  onTapCancel: () => setState(
                                      () => isForeignerPressed = false),
                                  onTap: () {
                                    Navigator.pushReplacementNamed(context,
                                        '/register-personal-foreigner');
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: isForeignerPressed
                                          ? Color(0xffd2e8ff)
                                          : Color(0xfff6fbff),
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                        width: 2,
                                        color: isForeignerPressed
                                            ? Color(0xff003977)
                                            : CIColors.accentColor,
                                      ),
                                    ),
                                    width: 145,
                                    height: 145,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Opacity(
                                          opacity: isForeignerPressed ? 1 : .8,
                                          child: Image.asset(
                                              width: 50,
                                              height: 50,
                                              'assets/world.png'),
                                        ),
                                        SizedBox(height: 4),
                                        Text(
                                          "Non-Tanzanian",
                                          style: TextStyle(
                                            color: isForeignerPressed
                                                ? Color(0xff003977)
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
                            const SizedBox(height: 24),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                // TextButton.icon(
                                //   style: TextButton.styleFrom(
                                //     padding: EdgeInsets.zero,
                                //     minimumSize: Size.zero,
                                //     tapTargetSize:
                                //         MaterialTapTargetSize.shrinkWrap,
                                //   ),
                                //   onPressed: () {
                                //     Navigator.pushReplacementNamed(
                                //         context, '/account-chooser');
                                //   },
                                //   icon: const Icon(
                                //     Icons.arrow_back,
                                //     color: CIColors.secondaryColor,
                                //   ),
                                //   label: Text(
                                //     'Account Type',
                                //     style: TextStyle(
                                //         color: CIColors.secondaryColor),
                                //   ),
                                // ),
                                const SizedBox(width: 24),
                                TextButton(
                                  style: TextButton.styleFrom(
                                    padding: EdgeInsets.zero,
                                    minimumSize: Size.zero,
                                    tapTargetSize:
                                        MaterialTapTargetSize.shrinkWrap,
                                  ),
                                  onPressed: () {
                                    Navigator.pushReplacementNamed(
                                        context, '/login');
                                  },
                                  child: Text(
                                    'Login instead',
                                    style: TextStyle(
                                        color: CIColors.secondaryColor),
                                  ),
                                ),
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
}
