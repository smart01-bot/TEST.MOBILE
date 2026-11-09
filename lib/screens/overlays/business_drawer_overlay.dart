import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import '../../components/drawer_item.dart';
import '../../components/expanded_drawer_item.dart';
import '../../constants/colors.dart';
import '../../providers/api_provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/overlay_controller.dart';
import '../../services/api_service.dart';
import '../../services/storage_service.dart';
import '../../services/navigator_service.dart';

class BusinessDrawerOverlay extends StatelessWidget {
  const BusinessDrawerOverlay({super.key});

  void _handleLogout(context) async {
    final apiProvider = Provider.of<APIProvider>(context, listen: false);
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final controller = Provider.of<OverlayProvider>(context, listen: false);
    try {
      controller.showLoadingOverlay();
      await ApiService.get('logout', token: apiProvider.authToken);
      apiProvider.resetToken();
      authProvider.logout();
      authProvider.pendingRoute = "";
      authProvider.pendingRouteParams = {};

      final storage = StorageService();
      await storage.delete("app_pass_code");
      await storage.delete("fcm_token");
      controller.inLocableScreen = false;
      controller.hideLoadingOverlay();
      navigatorKey.currentState?.pushNamedAndRemoveUntil(
        '/',
        (Route<dynamic> route) => false,
      );
    } catch (e) {
      //
    }
  }

  @override
  Widget build(BuildContext context) {
    final controllerProvider = Provider.of<OverlayProvider>(context);

    return ValueListenableBuilder<bool>(
      valueListenable: controllerProvider.isShownDrawerOverlay,
      builder: (context, isVisible, _) {
        if (!isVisible) return const SizedBox.shrink();

        return Positioned.fill(
          child: Material(
            color: Colors.transparent,
            child: SizedBox(
              width: double.infinity,
              height: double.infinity,
              child: Row(
                children: [
                  ConstrainedBox(
                    constraints: BoxConstraints(
                      minWidth: 230,
                      maxWidth: MediaQuery.of(context).size.width * 0.85,
                    ),
                    child: Container(
                      width: double.infinity,
                      height: MediaQuery.of(context).size.height,
                      margin: EdgeInsets.only(
                          top: MediaQuery.of(context).padding.top),
                      padding:
                          const EdgeInsets.only(top: 4, left: 8, right: 0, bottom: 8),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: CIColors.whiteColor,
                          border: Border.all(
                              color: const Color.fromARGB(63, 130, 153, 178),
                              width: 1),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          children: [
                            const SizedBox(height: 4),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 0,
                                ),
                                child: Image.asset(
                                  'assets/card_logo.png',
                                  fit: BoxFit.contain,
                                  width: 90,
                                  height: 48,
                                ),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Expanded(
                              child: SingleChildScrollView(
                                child: Column(
                                  children: [
                                    DrawerItem(
                                      title: "Home",
                                      icon: FontAwesomeIcons.house,
                                      onPressed: () {
                                        if (controllerProvider.currentRoute !=
                                            '/business/dashboard') {
                                          navigatorKey.currentState
                                              ?.pushNamed('/business/dashboard');
                                        }
                                      },
                                      isActive:
                                          controllerProvider.currentRoute ==
                                              '/business/dashboard',
                                    ),
                                    const SizedBox(height: 6),
                                    ExpandableDrawerItem(
                                      title: 'Profile',
                                      icon: FontAwesomeIcons.solidUser,
                                      items: [
                                        [
                                          'View Profile',
                                          '/business/profile',
                                          () {
                                            if (controllerProvider
                                                    .currentRoute !=
                                                '/business/profile') {
                                              navigatorKey.currentState
                                                  ?.pushNamed('/business/profile');
                                            }
                                          },
                                        ],
                                        [
                                          'Change Password',
                                          '/change-password',
                                          () {
                                            if (controllerProvider
                                                    .currentRoute !=
                                                '/change-password') {
                                              navigatorKey.currentState
                                                  ?.pushNamed('/change-password');
                                            }
                                          },
                                        ],
                                      ],
                                      isActive: [
                                        '/business/profile',
                                        '/change-password',
                                      ].contains(
                                          controllerProvider.currentRoute),
                                    ),
                                    const SizedBox(height: 6),
                                    ExpandableDrawerItem(
                                      title: 'Financing Solutions',
                                      icon: FontAwesomeIcons.lightbulb,
                                      items: [
                                        [
                                          'Request Credit Limit',
                                          '/business/financing/request-credit-limit',
                                          () {
                                            if (controllerProvider
                                                    .currentRoute !=
                                                '/business/financing/request-credit-limit') {
                                              navigatorKey.currentState
                                                  ?.pushNamed('/business/financing/request-credit-limit');
                                            }
                                          },
                                        ],
                                        [
                                          'Credit Line Applications',
                                          '/business/financing/credit-line-applications',
                                          () {
                                            if (controllerProvider
                                                    .currentRoute !=
                                                '/business/financing/credit-line-applications') {
                                              navigatorKey.currentState
                                                  ?.pushNamed('/business/financing/credit-line-applications');
                                            }
                                          },
                                        ],
                                        [
                                          'Utilization Request',
                                          '/business/financing/utilization-request',
                                          () {
                                            if (controllerProvider
                                                    .currentRoute !=
                                                '/business/financing/utilization-request') {
                                              navigatorKey.currentState
                                                  ?.pushNamed('/business/financing/utilization-request');
                                            }
                                          },
                                        ],
                                        [
                                          'References',
                                          '/business/financing/references',
                                          () {
                                            if (controllerProvider
                                                    .currentRoute !=
                                                '/business/financing/references') {
                                              navigatorKey.currentState
                                                  ?.pushNamed('/business/financing/references');
                                            }
                                          },
                                        ],
                                      ],
                                      isActive: [
                                        '/business/financing/request-credit-limit',
                                        '/business/financing/credit-line-applications',
                                        '/business/financing/utilization-request',
                                        '/business/financing/references',
                                      ].contains(controllerProvider.currentRoute),
                                    ),
                                    const SizedBox(height: 6),
                                    ExpandableDrawerItem(
                                      title: 'Business Loan',
                                      icon: FontAwesomeIcons.fileInvoiceDollar,
                                      items: [
                                        [
                                          'Apply for a Loan',
                                          '/business/loan/new',
                                          () {
                                            if (controllerProvider
                                                    .currentRoute !=
                                                '/business/loan/new') {
                                              navigatorKey.currentState
                                                  ?.pushNamed('/business/loan/new');
                                            }
                                          },
                                        ],
                                        [
                                          'My Applications',
                                          '/business/loan/applications',
                                          () {
                                            if (controllerProvider
                                                    .currentRoute !=
                                                '/business/loan/applications') {
                                              navigatorKey.currentState
                                                  ?.pushNamed('/business/loan/applications');
                                            }
                                          },
                                        ],
                                      ],
                                      isActive: [
                                        '/business/loan/new',
                                        '/business/loan/applications',
                                      ].contains(controllerProvider.currentRoute),
                                    ),
                                    const SizedBox(height: 6),
                                    ExpandableDrawerItem(
                                      title: 'Terms and Policy',
                                      icon: FontAwesomeIcons.shieldHalved,
                                      items: [
                                        [
                                          'Terms and Conditions',
                                          '/business/terms-and-conditions',
                                          () {
                                            if (controllerProvider
                                                    .currentRoute !=
                                                '/business/terms-and-conditions') {
                                              navigatorKey.currentState
                                                  ?.pushNamed('/business/terms-and-conditions');
                                            }
                                          },
                                        ],
                                        [
                                          'Privacy Policy',
                                          '/business/privacy-policy',
                                          () {
                                            if (controllerProvider
                                                    .currentRoute !=
                                                '/business/privacy-policy') {
                                              navigatorKey.currentState
                                                  ?.pushNamed('/business/privacy-policy');
                                            }
                                          },
                                        ],
                                      ],
                                      isActive: [
                                        '/business/terms-and-conditions',
                                        '/business/privacy-policy',
                                      ].contains(controllerProvider.currentRoute),
                                    ),
                                    const SizedBox(height: 6),
                                    DrawerItem(
                                      title: "Log Out",
                                      icon: FontAwesomeIcons.arrowRightFromBracket,
                                      onPressed: () {
                                        _handleLogout(context);
                                      },
                                      isRed: true,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            // Bottom user card — matches web profile section
                            Consumer<AuthProvider>(
                              builder: (context, authProvider, _) {
                                final name = authProvider.userData['name'] ?? '';
                                return Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 10),
                                  decoration: BoxDecoration(
                                    color: CIColors.canvasBGColor,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Row(
                                    children: [
                                      CircleAvatar(
                                        radius: 20,
                                        backgroundColor: CIColors.primaryColor,
                                        child: const Icon(Icons.business,
                                            color: Colors.white, size: 20),
                                      ),
                                      const SizedBox(width: 10),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              name.isNotEmpty ? name : 'Business Account',
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 13,
                                                color: CIColors.textColor,
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            const Text(
                                              'Account: Asset Financing',
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: CIColors.primaryColor,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        controllerProvider.hideDrawerOverlay();
                      },
                      child: Container(
                        width: double.infinity,
                        color: Colors.transparent,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}