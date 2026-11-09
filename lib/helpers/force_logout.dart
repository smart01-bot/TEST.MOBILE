import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/api_provider.dart';
import '../providers/auth_provider.dart';
import '../providers/overlay_controller.dart';
import '../services/storage_service.dart';
import '../services/navigator_service.dart';

void forceLogout(
  BuildContext context,
  bool mounted, {
  bool userLoggedOut = false,
}) async {
  final apiProvider = Provider.of<APIProvider>(context, listen: false);
  final authProvider = Provider.of<AuthProvider>(context, listen: false);
  final controllerProvider = Provider.of<OverlayProvider>(context, listen: false);

  final storage = StorageService();
  await storage.delete("app_pass_code");
  await storage.delete("fcm_token");

  apiProvider.resetToken();
  authProvider.logout();

  if (mounted) {
    if (context.mounted) {
      // if (!userLoggedOut) {
      //   authProvider.pendingRoute = ModalRoute.of(context)!.settings.name!;
      //   if (ModalRoute.of(context)!.settings.arguments != null) {
      //     authProvider.pendingRouteParams = ModalRoute.of(context)!
      //         .settings
      //         .arguments! as Map<String, dynamic>;
      //   }
      // }

      navigatorKey.currentState?.pushNamedAndRemoveUntil(
        '/',
        (Route<dynamic> route) => false,
      );

      controllerProvider.hideAppLockOverlay();
    }
  }
}
