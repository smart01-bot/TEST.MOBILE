import 'package:card_informatics_mobile_app/constants/button_style_main.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../constants/colors.dart';
import '../../wrappers/non_authed_wrapper.dart';

class IpRestrictedScreen extends StatefulWidget {
  const IpRestrictedScreen({super.key});

  @override
  State<IpRestrictedScreen> createState() => _IpRestrictedScreenState();
}

class _IpRestrictedScreenState extends State<IpRestrictedScreen> {
  bool isPersonalPressed = false;
  bool isBusinessPressed = false;

  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri phoneUri = Uri(scheme: 'tel', path: phoneNumber);
    if (await canLaunchUrl(phoneUri)) {
      await launchUrl(phoneUri);
    } 
  }

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
                        child: SizedBox(),
                      ),
                      Center(
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 32,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: CIColors.whiteColor,
                          ),
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

                              const SizedBox(height: 20),
                              Text(
                                "1004 - Error Occured",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: CIColors.secondaryColor,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 10),
                              SizedBox(
                                width: 300,
                                child: Text(
                                  "There was an error with you request. Please contact our support if you need further assistance.",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: CIColors.textColor,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 20),
                              ElevatedButton.icon(
                                onPressed: () {
                                  _makePhoneCall("+255222610310");
                                },
                                style: mainButtonStyle,
                                icon: FaIcon(FontAwesomeIcons.phoneVolume),
                                label: Text(
                                  'Contact Support',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        child: SizedBox(),
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
                              fontSize: 12,
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
