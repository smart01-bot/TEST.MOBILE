import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import '../components/loading_screen.dart';
import '../components/main_top_bar.dart';
import '../constants/colors.dart';
import '../helpers/force_logout.dart';
import '../helpers/format_with_thousands_separator.dart';
import '../services/api_service.dart';
import '../providers/api_provider.dart';
import '../providers/auth_provider.dart';
import '../wrappers/authed_wrapper.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  late AuthProvider authProvider;
  late APIProvider apiProvider;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  bool _isLoading = true;

  bool thereIsUpdate = false;

  Map<String, dynamic> _stats = {
    "fee-table": 0,
    "loans": 0,
    "credit-offers": 0,
    "credit-applications": 0,
  };

  void fetchDashboardData(BuildContext context) async {
    try {
      final response =
          await ApiService.get('dashboard', token: apiProvider.authToken);

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
          authProvider.userData = response['user-data'];
          _stats = response['stats'];
          thereIsUpdate = response['there-is-an-update'] ?? false;

          if (!authProvider.userData['is-profile-completed']) {
            if (context.mounted) {
              Navigator.pushReplacementNamed(context, '/complete-profile');
            }

            return;
          }
        }
      }
      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      //
    }
  }

  @override
  void initState() {
    super.initState();
    apiProvider = Provider.of<APIProvider>(context, listen: false);
    authProvider = Provider.of<AuthProvider>(context, listen: false);
    fetchDashboardData(context);
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    return AuthedWrapper(
      scaffoldKey: _scaffoldKey,
      appBar: MainTopBar(
        scaffoldKey: _scaffoldKey,
        title: "Home",
      ),
      child: Center(
        child: _isLoading
            ? LoadingScreen()
            : (authProvider.userData.isEmpty
                ? Text('No user data available')
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: 8,
                    children: [
                      if (thereIsUpdate)
                        Container(
                          padding: EdgeInsets.all(16),
                          width: double.infinity,
                          decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 211, 229, 235),
                              borderRadius: BorderRadius.all(
                                Radius.circular(8),
                              ),
                              border: Border.all(
                                  width: 1,
                                  color:
                                      const Color.fromARGB(45, 135, 135, 135))),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              FaIcon(
                                FontAwesomeIcons.bullhorn,
                                size: 20,
                                color: CIColors.textColor,
                              ),
                              SizedBox(
                                width: 16,
                              ),
                              Expanded(
                                flex: 1,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "A new version is available.",
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      "Please update to enjoy the latest features and improvements.",
                                      style: TextStyle(
                                        fontSize: 14,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 4,
                                    ),
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 12, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: CIColors.textColor,
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(16),
                                        ),
                                      ),
                                      child: Text(
                                        "Update Now",
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: CIColors.whiteColor,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      SizedBox(
                        width: double.infinity,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              spacing: 10,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                SizedBox(
                                  width: 8,
                                ),
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8.0),
                                  child: Image.network(
                                    (authProvider.userData['profile-image'] as String).replaceAll('//dashboarddiond', '/dashboarddiond'),
                                    width: 50,
                                    height: 50,
                                    fit: BoxFit
                                        .cover, // Controls how the image fits the box (e.g., cover, contain, fill)
                                    loadingBuilder: (BuildContext context,
                                        Widget child,
                                        ImageChunkEvent? loadingProgress) {
                                      if (loadingProgress == null) return child;
                                      return Center(
                                        child: CircularProgressIndicator(
                                          value: loadingProgress
                                                      .expectedTotalBytes !=
                                                  null
                                              ? loadingProgress
                                                      .cumulativeBytesLoaded /
                                                  (loadingProgress
                                                          .expectedTotalBytes ??
                                                      1)
                                              : null,
                                        ),
                                      );
                                    },
                                    errorBuilder: (BuildContext context,
                                        Object error, StackTrace? stackTrace) {
                                      return Container(
                                        width: 50,
                                        height: 50,
                                        decoration: BoxDecoration(
                                            color: const Color.fromARGB(
                                                255, 208, 221, 235),
                                            borderRadius:
                                                BorderRadius.circular(8)),
                                        child: Center(
                                          child: FaIcon(
                                            FontAwesomeIcons.solidUser,
                                            size: 24,
                                            color: const Color.fromARGB(180, 84, 120, 160),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      authProvider.userData['name'],
                                      style: TextStyle(
                                          fontWeight: FontWeight.w800,
                                          fontSize: 16,
                                          height: 1.5),
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          "ID: ",
                                          style: TextStyle(
                                            color: CIColors.secondaryColor,
                                            // fontStyle: FontStyle.italic,
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            height: 1,
                                          ),
                                        ),
                                        Text(
                                          authProvider.userData['client-id'] ??
                                              "",
                                          style: TextStyle(
                                            color: CIColors.accentColor,
                                            // fontStyle: FontStyle.italic,
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            height: 1,
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 4)
                                  ],
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 4,
                      ),
                      Container(
                        width: double.infinity,
                        height: 200,
                        decoration: BoxDecoration(
                          color: CIColors.textColorAlt,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: CarouselSlider(
                          items: [
                            // Slide 1 — Loans
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 24),
                                  child: Text(
                                    "Get loans easily from various institutions",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                SizedBox(height: 16),
                                SizedBox(
                                  width: 220,
                                  height: 44,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.white,
                                      foregroundColor: CIColors.textColorAlt,
                                      elevation: 0,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(50),
                                      ),
                                    ),
                                    onPressed: () {
                                      Navigator.pushNamed(
                                        context,
                                        '/select-employment-loan-application',
                                      );
                                    },
                                    child: Text(
                                      "Apply for a Loan",
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            // Slide 2 — Credit Offers
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 24),
                                  child: Text(
                                    "Elevate your business with our Credit Offers",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                SizedBox(height: 16),
                                SizedBox(
                                  width: 220,
                                  height: 44,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.white,
                                      foregroundColor: CIColors.textColorAlt,
                                      elevation: 0,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(50),
                                      ),
                                    ),
                                    onPressed: () {
                                      Navigator.pushNamed(
                                          context, '/marketplace-credit-offers');
                                    },
                                    child: Text(
                                      "View Credit Offers",
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                          options: CarouselOptions(
                            height: 200,
                            viewportFraction: 1,
                            enlargeCenterPage: false,
                            autoPlay: true,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      // PDPC Notice
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: CIColors.detaiBorderColor,
                            width: 1,
                          ),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            FaIcon(
                              FontAwesomeIcons.userShield,
                              size: 28,
                              color: CIColors.primaryColor,
                            ),
                            SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                'CARD Informatics inachukua hatua madhubuti kulinda taarifa zako binafsi kwa kuzingatia kanuni chini ya Leseni ya Tume ya Ulinzi wa Taarifa Binafsi (PDPC).',
                                style: TextStyle(
                                  color: CIColors.textColor,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.only(left: 16.0),
                        child: Text(
                          "My Stats",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ),
                      ConstrainedBox(
                        constraints: BoxConstraints(
                          maxHeight: 100,
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          spacing: 8,
                          children: [
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.pushNamed(
                                      context, '/my-loan-applications');
                                },
                                child: Container(
                                  padding: EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            formatWithThousandSeparator(
                                                _stats['loans'].toString()),
                                            style: TextStyle(
                                              fontSize: 32,
                                              fontWeight: FontWeight.bold,
                                              height: .8,
                                            ),
                                          ),
                                          SizedBox(width: 10),
                                          FaIcon(
                                            FontAwesomeIcons.fileInvoiceDollar,
                                            color: const Color.fromARGB(
                                                137, 130, 153, 178),
                                            size: 16,
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Expanded(
                                        child: Align(
                                          alignment: Alignment.bottomLeft,
                                          child: Text(
                                            "Loan Applications",
                                            style: TextStyle(
                                              color: CIColors.secondaryColor,
                                              fontSize: 16,
                                              height: 1,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.pushNamed(
                                      context, '/my-credit-offer-applications');
                                },
                                child: Container(
                                  padding: EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            formatWithThousandSeparator(
                                                _stats['credit-applications']
                                                    .toString()),
                                            style: TextStyle(
                                              fontSize: 32,
                                              fontWeight: FontWeight.bold,
                                              height: .8,
                                            ),
                                          ),
                                          SizedBox(width: 10),
                                          FaIcon(
                                            FontAwesomeIcons.sackDollar,
                                            color: const Color.fromARGB(
                                                137, 130, 153, 178),
                                            size: 16,
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Expanded(
                                        child: Align(
                                          alignment: Alignment.bottomLeft,
                                          child: Text(
                                            "Credit Applications",
                                            style: TextStyle(
                                              color: CIColors.secondaryColor,
                                              fontSize: 16,
                                              height: 1,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      ConstrainedBox(
                        constraints: BoxConstraints(
                          maxHeight: 100,
                        ),
                        child: Row(
                          spacing: 8,
                          children: [
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.pushNamed(
                                      context, '/marketplace-credit-offers');
                                },
                                child: Container(
                                  padding: EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            formatWithThousandSeparator(
                                                _stats['credit-offers']
                                                    .toString()),
                                            style: TextStyle(
                                              fontSize: 32,
                                              fontWeight: FontWeight.bold,
                                              height: .8,
                                            ),
                                          ),
                                          SizedBox(width: 10),
                                          FaIcon(
                                            FontAwesomeIcons.sackDollar,
                                            color: const Color.fromARGB(
                                                137, 130, 153, 178),
                                            size: 16,
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 12,
                                      ),
                                      Expanded(
                                        child: Align(
                                          alignment: Alignment.bottomLeft,
                                          child: Text(
                                            "Credit Offers",
                                            style: TextStyle(
                                              color: CIColors.secondaryColor,
                                              fontSize: 16,
                                              height: 1,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                padding: EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          formatWithThousandSeparator(
                                              _stats['fee-tables'].toString()),
                                          style: TextStyle(
                                            fontSize: 32,
                                            fontWeight: FontWeight.bold,
                                            height: .8,
                                          ),
                                        ),
                                        SizedBox(width: 10),
                                        FaIcon(
                                          FontAwesomeIcons.fileInvoiceDollar,
                                          color: const Color.fromARGB(
                                              137, 130, 153, 178),
                                          size: 16,
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 12,
                                    ),
                                    Expanded(
                                      child: Align(
                                        alignment: Alignment.bottomLeft,
                                        child: Text(
                                          "Fee Tables",
                                          style: TextStyle(
                                            color: CIColors.secondaryColor,
                                            fontSize: 16,
                                            height: 1,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  )),
      ),
    );
  }
}