
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../constants/colors.dart';
import '../../constants/button_style_main.dart';

class NoInternetOverlay extends StatelessWidget {
  final Function retryFunction;
  const NoInternetOverlay({super.key, required this.retryFunction});

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: Material(
        color: Colors.transparent,
        child: SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: Container(
            color: CIColors.canvasBGColor,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Image.asset(
                        'assets/card_logo.png', // Add your logo asset
                        fit: BoxFit.contain,
                        width: 120,
                        height: 60,
                      ),
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    margin: EdgeInsets.all(32),
                    padding: EdgeInsets.symmetric(
                      horizontal: 54,
                      vertical: 32,
                    ),
                    constraints: BoxConstraints(maxHeight: 250),
                    decoration: BoxDecoration(
                      color: CIColors.whiteColor,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        FaIcon(
                          FontAwesomeIcons.triangleExclamation,
                          color: CIColors.accentColor,
                          size: 40,
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        Text(
                          "It looks like you're offline.",
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          "Please connect to the internet to continue.",
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(
                          height: 16,
                        ),
                        ElevatedButton(
                          style: mainButtonStyle,
                          // onPressed: () async {
                          //   await context
                          //       .read<InternetProvider>()
                          //       .retryConnection();
                          // },
                          onPressed: () {
                            retryFunction();
                          },
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ), // Needed for blur to work
          ),
        ),
      ),
    );
  }
}
