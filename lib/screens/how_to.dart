import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../components/loading_screen.dart';
import '../components/main_top_bar.dart';
import '../constants/colors.dart';
import '../helpers/force_logout.dart';
import '../services/api_service.dart';
import '../providers/api_provider.dart';
import '../providers/auth_provider.dart';
import '../wrappers/authed_wrapper.dart';

class HowToScreen extends StatefulWidget {
  const HowToScreen({super.key});

  @override
  State<HowToScreen> createState() => _HowToScreenState();
}

class _HowToScreenState extends State<HowToScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late AuthProvider authProvider;
  late APIProvider apiProvider;

  bool _isLoading = true;

  final List<dynamic> _tutorialCategories = [
    {
      "key": "key",
      "gif":"profile.gif",
      "title": "Profile Management",
      "subline":
          " Learn how to update your profile, change your password, profile picture, and more}"
    },
    {
      "key": "key2",
      "title": "Loan Application",
      'gif':'loan.gif',
      "subline":
          "Step by step guide to apply for a loan, tracking its status, and submitting required documents"
    }
  ];

  @override
  void initState() {
    super.initState();
    apiProvider = Provider.of<APIProvider>(context, listen: false);
    authProvider = Provider.of<AuthProvider>(context, listen: false);
    fetchDashboardData(context);
  }

  void fetchDashboardData(BuildContext context) async {
    try {
      final response = await ApiService.get('get-tutorial-categories',
          token: apiProvider.authToken);

      if (response != null) {
        if (response.containsKey('error')) {
          switch (response['error']) {
            case "unauthorized":
              if (context.mounted) {
                forceLogout(context, mounted);
              }
              return;

            default:
          }
        } else {
          // _tutorialCategories = response['categories'];
          print(response['categories']);
        }
      }
      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      //
      setState(() {
        _isLoading = false;
      });
    }
  }

  final Map<String, IconData> faIconMap = {
    'loans': FontAwesomeIcons.fileInvoiceDollar,
    'credits': FontAwesomeIcons.sackDollar,
    'profile': FontAwesomeIcons.solidUser,
    // Add other icons you might use
  };

  getDynamicIcon(String iconName) {
    return faIconMap[iconName] ??
        FontAwesomeIcons.solidCircleQuestion; // fallback if not found
  }

  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri phoneUri = Uri(scheme: 'tel', path: phoneNumber);
    if (await canLaunchUrl(phoneUri)) {
      await launchUrl(phoneUri);
    }
  }

  Future<void> _sendEmail(String emailAddress) async {
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: emailAddress,
    );

    if (await canLaunchUrl(emailUri)) {
      await launchUrl(emailUri);
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    return AuthedWrapper(
        scaffoldKey: _scaffoldKey,
        appBar: MainTopBar(
          scaffoldKey: _scaffoldKey,
          title: "Help Center",
        ),
        child: Center(
          child: _isLoading
              ? LoadingScreen()
              : _tutorialCategories.isEmpty
                  ? Text('No tutorial content for now')
                  : SizedBox(
                      width: double.infinity,
                      child: Column(
                        spacing: 10,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Container(
                            padding: EdgeInsets.all(16),
                            width: double.infinity,
                            child: Center(
                              child: Column(
                                children: [
                                  FaIcon(
                                    FontAwesomeIcons.solidCircleQuestion,
                                    color: CIColors.accentColor,
                                    size: 26,
                                  ),
                                  SizedBox(
                                    height: 12,
                                  ),
                                  Text(
                                    "Find quick guides and answers \nto help you use the app with ease.",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: CIColors.accentColor,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                          ..._tutorialCategories.map((category) {
                            return GestureDetector(
                              onTap: () {
                                Navigator.pushNamed(
                                  context,
                                  '/how-to-category',
                                  arguments: {
                                    'gif':category['gif'],
                                    'category-key': category['key'].toString(),
                                    'category-title':
                                        "${category['title'].toString()} Tutorials ",
                                    'category-subline': category['subline'] ??
                                        "Learn how to use this feature and get the most out of it with simple, step-by-step guidance.",
                                  },
                                );
                              },
                              child: Container(
                                padding: EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: CIColors.whiteColor,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(8)),
                                ),
                                child: Row(
                                  spacing: 16,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(top: 4.0),
                                      child: SizedBox(
                                        height: 20,
                                        width: 20,
                                        child: Center(
                                          child: FaIcon(
                                            getDynamicIcon(category['key']),
                                            color: CIColors.accentColor,
                                            size: 16,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            category['title'],
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Text(
                                            category['subline'] ??
                                                "Learn how to use this feature and get the most out of it with simple, step-by-step guidance. ",
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: CIColors.accentColor,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }),
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 14, vertical: 16),
                            margin: EdgeInsets.only(bottom: 60),
                            decoration: BoxDecoration(
                                color: CIColors.whiteColor,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8)),
                                border: Border.all(
                                  color: CIColors.detaiBorderColor,
                                  width: 2,
                                )),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              spacing: 14,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(top: 4.0),
                                  child: SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: Center(
                                      child: FaIcon(
                                        FontAwesomeIcons.solidComments,
                                        color: CIColors.accentColor,
                                        size: 16,
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    spacing: 4,
                                    children: [
                                      Text(
                                        "Need further assistance?",
                                        style: TextStyle(
                                          color: CIColors.textColor,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        "Reach out to our support team for quick help with questions, issues, or feedback.",
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: CIColors.accentColor,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 4,
                                      ),
                                      Row(
                                        spacing: 4,
                                        children: [
                                          GestureDetector(
                                            onTap: () {
                                              _makePhoneCall("+255222610310");
                                            },
                                            child: Container(
                                              padding: EdgeInsets.symmetric(
                                                horizontal: 12,
                                                vertical: 6,
                                              ),
                                              decoration: BoxDecoration(
                                                  color: const Color.fromARGB(
                                                      110, 183, 237, 255),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          20)),
                                              child: Row(
                                                spacing: 6,
                                                children: [
                                                  FaIcon(
                                                    FontAwesomeIcons
                                                        .phoneVolume,
                                                    size: 12,
                                                    color:
                                                        CIColors.secondaryColor,
                                                  ),
                                                  Text(
                                                    'Call Support',
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 12,
                                                      color: CIColors
                                                          .secondaryColor,
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: 2,
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              _sendEmail(
                                                  "info@cardinformatics.co.tz");
                                            },
                                            child: Container(
                                              padding: EdgeInsets.symmetric(
                                                horizontal: 12,
                                                vertical: 6,
                                              ),
                                              decoration: BoxDecoration(
                                                  color: const Color.fromARGB(
                                                      110, 183, 237, 255),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          20)),
                                              child: Row(
                                                spacing: 6,
                                                children: [
                                                  FaIcon(
                                                    FontAwesomeIcons
                                                        .solidEnvelope,
                                                    size: 12,
                                                    color:
                                                        CIColors.secondaryColor,
                                                  ),
                                                  Text(
                                                    'Contact via Email',
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 12,
                                                      color: CIColors
                                                          .secondaryColor,
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: 2,
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
        ));
  }
}
