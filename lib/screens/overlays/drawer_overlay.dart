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

class DrawerOverlay extends StatelessWidget {
  const DrawerOverlay({super.key});

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
                                            '/dashboard') {
                                          navigatorKey.currentState
                                              ?.pushNamed('/dashboard');
                                        }
                                      },
                                      isActive:
                                          controllerProvider.currentRoute ==
                                              '/dashboard',
                                    ),
                                    const SizedBox(height: 6),
                                    ExpandableDrawerItem(
                                      title: 'Profile',
                                      icon: FontAwesomeIcons.solidUser,
                                      items: [
                                        [
                                          'View Profile',
                                          '/profile',
                                          () {
                                            if (controllerProvider
                                                    .currentRoute !=
                                                '/profile') {
                                              navigatorKey.currentState
                                                  ?.pushNamed('/profile');
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
                                        [
                                          'Change Security',
                                          '/change-security-question',
                                          () {
                                            if (controllerProvider
                                                    .currentRoute !=
                                                '/change-security-question') {
                                              navigatorKey.currentState
                                                  ?.pushNamed('/change-security-question');
                                            }
                                          },
                                        ],
                                        [
                                          'Change Birthdate',
                                          '/change-birthdate',
                                          () {
                                            if (controllerProvider
                                                    .currentRoute !=
                                                '/change-birthdate') {
                                              navigatorKey.currentState
                                                  ?.pushNamed('/change-birthdate');
                                            }
                                          },
                                        ],
                                      ],
                                      isActive: [
                                        '/profile',
                                        '/change-password',
                                        '/change-security-question',
                                        '/change-birthdate',
                                      ].contains(
                                          controllerProvider.currentRoute),
                                    ),
                                    const SizedBox(height: 6),
                                    DrawerItem(
                                      title: "How to Apply",
                                      icon: FontAwesomeIcons.solidCircleQuestion,
                                      onPressed: () {
                                        if (controllerProvider.currentRoute !=
                                            '/how-to-apply') {
                                          navigatorKey.currentState
                                              ?.pushNamed('/how-to-apply');
                                        }
                                      },
                                      isActive: controllerProvider.currentRoute ==
                                          '/how-to-apply',
                                    ),
                                    const SizedBox(height: 6),
                                    ExpandableDrawerItem(
                                      title: 'Bank Credit Offers',
                                      icon: FontAwesomeIcons.sackDollar,
                                      items: [
                                        [
                                          'Marketplace Credit Offers',
                                          '/marketplace-credit-offers',
                                          () {
                                            if (controllerProvider
                                                    .currentRoute !=
                                                '/marketplace-credit-offers') {
                                              navigatorKey.currentState
                                                  ?.pushNamed('/marketplace-credit-offers');
                                            }
                                          },
                                        ],
                                        [
                                          'My Applications',
                                          '/my-credit-offer-applications',
                                          () {
                                            if (controllerProvider
                                                        .currentRoute !=
                                                    '/my-credit-offer-applications' ||
                                                (controllerProvider
                                                            .currentRoute ==
                                                        '/my-credit-offer-applications' &&
                                                    controllerProvider
                                                        .currentRouteFilter
                                                        .isNotEmpty)) {
                                              navigatorKey.currentState
                                                  ?.pushNamed('/my-credit-offer-applications');
                                            }
                                          },
                                          '',
                                        ],
                                        [
                                          'Replied Credit Offers',
                                          '/my-credit-offer-applications',
                                          () {
                                            if (controllerProvider
                                                        .currentRoute !=
                                                    '/my-credit-offer-applications' ||
                                                (controllerProvider
                                                            .currentRoute ==
                                                        '/my-credit-offer-applications' &&
                                                    controllerProvider
                                                            .currentRouteFilter !=
                                                        "replied")) {
                                              navigatorKey.currentState
                                                  ?.pushNamed(
                                                '/my-credit-offer-applications',
                                                arguments: {"filter": "replied"},
                                              );
                                            }
                                          },
                                          'replied',
                                        ],
                                        [
                                          'Approved Credit Offers',
                                          '/my-credit-offer-applications',
                                          () {
                                            if (controllerProvider
                                                        .currentRoute !=
                                                    '/my-credit-offer-applications' ||
                                                (controllerProvider
                                                            .currentRoute ==
                                                        '/my-credit-offer-applications' &&
                                                    controllerProvider
                                                            .currentRouteFilter !=
                                                        "approved")) {
                                              navigatorKey.currentState
                                                  ?.pushNamed(
                                                '/my-credit-offer-applications',
                                                arguments: {"filter": "approved"},
                                              );
                                            }
                                          },
                                          'approved',
                                        ],
                                      ],
                                      isActive: [
                                        '/marketplace-credit-offers',
                                        '/my-credit-offer-applications',
                                      ].contains(controllerProvider.currentRoute),
                                    ),
                                    const SizedBox(height: 6),
                                    ExpandableDrawerItem(
                                      title: 'Loan Applications',
                                      icon: FontAwesomeIcons.fileInvoiceDollar,
                                      items: [
                                        [
                                          'Marketplace Applications',
                                          '/marketplace-loan-applications',
                                          () {
                                            if (controllerProvider
                                                    .currentRoute !=
                                                '/marketplace-loan-applications') {
                                              navigatorKey.currentState
                                                  ?.pushNamed('/marketplace-loan-applications');
                                            }
                                          },
                                        ],
                                        [
                                          'Apply for a Loan/Credit',
                                          '/select-employment-loan-application',
                                          () {
                                            if (controllerProvider
                                                    .currentRoute !=
                                                '/select-employment-loan-application') {
                                              navigatorKey.currentState
                                                  ?.pushNamed('/select-employment-loan-application');
                                            }
                                          },
                                        ],
                                        [
                                          'My Applications',
                                          '/my-loan-applications',
                                          () {
                                            if (controllerProvider
                                                    .currentRoute !=
                                                '/my-loan-applications') {
                                              navigatorKey.currentState
                                                  ?.pushNamed('/my-loan-applications');
                                            }
                                          },
                                        ],
                                      ],
                                      isActive: [
                                        '/marketplace-loan-applications',
                                        '/select-employment-loan-application',
                                        '/my-loan-applications',
                                      ].contains(controllerProvider.currentRoute),
                                    ),
                                    const SizedBox(height: 6),
                                    DrawerItem(
                                      title: "Help Center",
                                      icon: FontAwesomeIcons.solidCircleQuestion,
                                      onPressed: () {
                                        if (controllerProvider.currentRoute !=
                                            '/how-to') {
                                          navigatorKey.currentState
                                              ?.pushNamed('/how-to');
                                        }
                                      },
                                      isActive:
                                          controllerProvider.currentRoute ==
                                              '/how-to',
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
                            // Bottom user card — name and CID like the web
                            Consumer<AuthProvider>(
                              builder: (context, authProvider, _) {
                                final name = authProvider.userData['name'] ?? '';
                                final cid = authProvider.userData['client-id'] ?? '';
                                if (name.isEmpty) return const SizedBox.shrink();
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
                                        child: const Icon(Icons.person,
                                            color: Colors.white, size: 20),
                                      ),
                                      const SizedBox(width: 10),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              name,
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 13,
                                                color: CIColors.textColor,
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            Text(
                                              'ID: $cid',
                                              style: const TextStyle(
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