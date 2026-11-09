import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import '../constants/colors.dart';
import '../providers/api_provider.dart';
import '../providers/auth_provider.dart';
import '../providers/notification_provider.dart';
import '../providers/overlay_controller.dart';
import '../services/api_service.dart';
import '../services/storage_service.dart';

class MainTopBar extends StatefulWidget {
  const MainTopBar({
    super.key,
    required GlobalKey<ScaffoldState> scaffoldKey,
    required String title,
    this.showActions = true,
  })  : _scaffoldKey = scaffoldKey,
        _title = title;

  final GlobalKey<ScaffoldState> _scaffoldKey;
  final String _title;
  final bool showActions;

  @override
  State<MainTopBar> createState() => _MainTopBarState();
}

class _MainTopBarState extends State<MainTopBar> {
  late AuthProvider authProvider;
  late APIProvider apiProvider;

  late OverlayProvider overlayController;

  @override
  void initState() {
    super.initState();
    apiProvider = Provider.of<APIProvider>(context, listen: false);
    authProvider = Provider.of<AuthProvider>(context, listen: false);
    Future.microtask(() {
      if (mounted)
        {Provider.of<OverlayProvider>(context, listen: false).inLocableScreen =
            true;}
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    overlayController = context.read<OverlayProvider>();
  }

  void _handleLogout(authProvider, apiProvider, BuildContext context) async {
    try {
      await ApiService.get('logout', token: apiProvider.authToken);
      apiProvider.resetToken();
      authProvider.logout();
      authProvider.pendingRoute = "";
      authProvider.pendingRouteParams = {};

      final storage = StorageService();
      await storage.delete("app_pass_code");
      await storage.delete("fcm_token");
      if (context.mounted) {
        Provider.of<OverlayProvider>(context, listen: false).inLocableScreen =
            false;
      }

      if (context.mounted) {
        Navigator.pushNamedAndRemoveUntil(
          context,
          '/',
          (route) => false,
        );
      }
    } catch (e) {
      //
    }
  }

  void handleBackButton(BuildContext context) {
    if (Navigator.canPop(context)) {
      Navigator.pop(context);
    } else {
      // Optionally show a dialog or do something else
    }
  }

  @override
  Widget build(BuildContext context) {
    final NotificationProvider notificationProvider =
        Provider.of<NotificationProvider>(context, listen: true);
    final overlayController = Provider.of<OverlayProvider>(context);

    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 8,
      ),
      padding: EdgeInsets.all(0),
      decoration: BoxDecoration(
        color: CIColors.whiteColor,
        borderRadius: BorderRadius.all(
          Radius.circular(12),
        ),
        border: Border.all(
          color: CIColors.inputBorderColor,
          width: 1,
        ),
      ),
      child: Row(
        spacing: 0,
        children: [
          if (widget.showActions && !Navigator.canPop(context))
            SizedBox(width: 16),
          if (widget.showActions && Navigator.canPop(context))
            IconButton(
              icon: FaIcon(
                FontAwesomeIcons.chevronLeft,
                size: 20,
                color: CIColors.primaryColor,
              ),
              onPressed: () {
                handleBackButton(context);
                // overlayController.showDrawerOverlay();
              },
            ),
          if (!widget.showActions) SizedBox(width: 16),
          Expanded(
            child: Text(
              widget._title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          if (widget.showActions)
            Stack(
              children: [
                IconButton(
                  padding: EdgeInsets.zero,
                  icon: FaIcon(
                    FontAwesomeIcons.solidBell,
                    size: 20,
                    color: CIColors.primaryColor,
                  ),
                  onPressed: () {
                    overlayController.showNotificationOverlay();
                  },
                ),
                if (notificationProvider.notifications.isNotEmpty)
                  Positioned(
                    top: 14,
                    right: 14,
                    child: Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 205, 55, 87),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: const Color.fromARGB(255, 255, 255, 255),
                          width: .8,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          if (widget.showActions)
            IconButton(
              padding: EdgeInsets.zero,
              icon: FaIcon(
                FontAwesomeIcons.bars,
                size: 20,
                color: CIColors.primaryColor,
              ),
              onPressed: () {
                overlayController.showDrawerOverlay();
              },
            ),
          // GestureDetector(
          //   onTap: () {
          //     Navigator.pushNamed(context, '/profile');
          //   },
          //   child: ClipRRect(
          //     borderRadius: BorderRadius.circular(8.0),
          //     child: Image.network(
          //       authProvider.userData['profile-image'] ?? '',
          //       width: 40,
          //       height: 40,
          //       fit: BoxFit.cover,
          //       loadingBuilder: (BuildContext context, Widget child,
          //           ImageChunkEvent? loadingProgress) {
          //         if (loadingProgress == null) return child;
          //         return Center(
          //           child: CircularProgressIndicator(
          //             value: loadingProgress.expectedTotalBytes != null
          //                 ? loadingProgress.cumulativeBytesLoaded /
          //                     (loadingProgress.expectedTotalBytes ?? 1)
          //                 : null,
          //           ),
          //         );
          //       },
          //       errorBuilder: (BuildContext context, Object error,
          //           StackTrace? stackTrace) {
          //         return Container(
          //           width: 35,
          //           height: 35,
          //           decoration: BoxDecoration(
          //               color: const Color.fromARGB(255, 208, 221, 235),
          //               borderRadius: BorderRadius.circular(12)),
          //         );
          //       },
          //     ),
          //   ),
          // ),
          if (!widget.showActions)
            IconButton(
              icon: FaIcon(
                FontAwesomeIcons.arrowRightFromBracket,
                size: 20,
                color: CIColors.primaryColor,
              ),
              onPressed: () {
                _handleLogout(authProvider, apiProvider, context);
              },
            ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    overlayController.setInLocableScreenWithoutNotify(false);
    super.dispose();
  }
}
