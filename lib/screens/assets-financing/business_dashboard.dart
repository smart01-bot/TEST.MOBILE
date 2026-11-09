import 'dart:async';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import '../../components/loading_screen.dart';
import '../../components/main_top_bar.dart';
import '../../constants/colors.dart';
import '../../helpers/force_logout.dart';
import '../../helpers/format_with_thousands_separator.dart';
import '../../services/api_service.dart';
import '../../providers/api_provider.dart';
import '../../providers/auth_provider.dart';
import '../../wrappers/authed_wrapper.dart';

class BusinessDashboardScreen extends StatefulWidget {
  const BusinessDashboardScreen({super.key});

  @override
  State<BusinessDashboardScreen> createState() =>
      _BusinessDashboardScreenState();
}

class _BusinessDashboardScreenState extends State<BusinessDashboardScreen>
    with SingleTickerProviderStateMixin {
  late AuthProvider authProvider;
  late APIProvider apiProvider;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  bool _isLoading = true;
  int _currentBanner = 0;
  Timer? _bannerTimer;

  late AnimationController _animController;
  late Animation<Offset> _slideIn;
  late Animation<double> _fadeIn;

  final List<Map<String, String>> _banners = [
    {
      'title': 'Get access to LPO financing and execute contracts without financial strain',
      'cta': 'Request LPO/Contract Financing',
      'route': '/business/financing/request-credit-limit',
    },
    {
      'title': 'Secure instant cash flow with Invoice Discounting to support your business operations',
      'cta': 'Request Invoice Discounting',
      'route': '/business/financing/request-credit-limit',
    },
    {
      'title': 'Get quick and structured financing through our Smart Loan product',
      'cta': 'Apply For Business Loan',
      'route': '/business/loan/new',
    },
  ];

  Map<String, dynamic> _stats = {
    "registered-users": 0,
    "financial-institutions": 0,
    "credit-offers": 0,
    "loans-requested": 0,
  };

  void fetchDashboardData(BuildContext context) async {
    try {
      final response = await ApiService.get('business/dashboard',
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
          authProvider.userData = response['user-data'];
          _stats = response['stats'];
        }
      }
      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _startBannerTimer() {
    _bannerTimer = Timer.periodic(const Duration(seconds: 5), (_) {
      _animController.forward(from: 0);
      setState(() {
        _currentBanner = (_currentBanner + 1) % _banners.length;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    apiProvider = Provider.of<APIProvider>(context, listen: false);
    authProvider = Provider.of<AuthProvider>(context, listen: false);
    fetchDashboardData(context);

    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _slideIn = Tween<Offset>(
      begin: const Offset(-0.3, 0),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _animController, curve: Curves.easeOut));
    _fadeIn = Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(parent: _animController, curve: Curves.easeOut));

    _animController.forward();
    _startBannerTimer();
  }

  @override
  void dispose() {
    _bannerTimer?.cancel();
    _animController.dispose();
    super.dispose();
  }

  Widget _buildStatCard(String label, String key, IconData icon) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  formatWithThousandSeparator(_stats[key].toString()),
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    height: .9,
                  ),
                ),
                FaIcon(icon,
                    color: const Color.fromARGB(137, 130, 153, 178), size: 16),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: const TextStyle(
                color: CIColors.secondaryColor,
                fontSize: 13,
                height: 1.2,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    return AuthedWrapper(
      scaffoldKey: _scaffoldKey,
     appBar: MainTopBar(scaffoldKey: _scaffoldKey,  title: "Home"),
      child: _isLoading
          ? const LoadingScreen()
          : (authProvider.userData.isEmpty
              ? const Center(child: Text('No user data available'))
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10),

                    // Business Info Card
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                            color: CIColors.detaiBorderColor, width: 1),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            authProvider.userData['name'] ?? '',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                              color: CIColors.textColor,
                            ),
                          ),
                          const SizedBox(height: 8),
                          _infoRow('Mobile Number',
                              authProvider.userData['phone'] ?? ''),
                          const SizedBox(height: 4),
                          _infoRow(
                              'Email', authProvider.userData['email'] ?? ''),
                          const SizedBox(height: 4),
                          _infoRow('Role',
                              authProvider.userData['role'] ?? 'TEST Client'),
                        ],
                      ),
                    ),

                    const SizedBox(height: 8),

                    // Animated rotating banner
                    Container(
                      width: double.infinity,
                      height: 160,
                      decoration: BoxDecoration(
                        color: CIColors.textColor,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.all(24),
                      child: FadeTransition(
                        opacity: _fadeIn,
                        child: SlideTransition(
                          position: _slideIn,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                _banners[_currentBanner]['title']!,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 16),
                              GestureDetector(
                                onTap: () {
                                  Navigator.pushNamed(context,
                                      _banners[_currentBanner]['route']!);
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 10),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  child: Text(
                                    _banners[_currentBanner]['cta']!,
                                    style: const TextStyle(
                                      color: Color(0xFF47688b),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    // Banner dots
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        _banners.length,
                        (i) => AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          margin: const EdgeInsets.symmetric(horizontal: 3),
                          width: i == _currentBanner ? 16 : 6,
                          height: 6,
                          decoration: BoxDecoration(
                            color: i == _currentBanner
                                ? CIColors.textColor
                                : const Color(0xFFb0c4d8),
                            borderRadius: BorderRadius.circular(3),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 12),

                    // Stats row 1
                    IntrinsicHeight(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          _buildStatCard('Registered Users',
                              'registered-users', FontAwesomeIcons.userGroup),
                          const SizedBox(width: 8),
                          _buildStatCard(
                              'Financial\nInstitutions',
                              'financial-institutions',
                              FontAwesomeIcons.buildingColumns),
                        ],
                      ),
                    ),

                    const SizedBox(height: 8),

                    // Stats row 2
                    IntrinsicHeight(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          _buildStatCard('Credit Offers', 'credit-offers',
                              FontAwesomeIcons.sackDollar),
                          const SizedBox(width: 8),
                          _buildStatCard('Loans\nRequested', 'loans-requested',
                              FontAwesomeIcons.fileInvoiceDollar),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),
                  ],
                )),
    );
  }

  Widget _infoRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('$label: ',
            style: const TextStyle(
                color: CIColors.secondaryColor,
                fontWeight: FontWeight.bold,
                fontSize: 13)),
        Expanded(
            child: Text(value,
                style: const TextStyle(
                    color: CIColors.textColor, fontSize: 13))),
      ],
    );
  }
}