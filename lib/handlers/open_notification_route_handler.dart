
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/auth_provider.dart';

void openNotificationRouteHandler(
    BuildContext context, Map<String, dynamic> notifData) async {
  AuthProvider authProvider = Provider.of<AuthProvider>(context, listen: false);

  if (notifData['type'] != null && notifData['status'] != null) {
    switch (notifData['type']) {
      case 'loan':
        if (notifData['appl_id'] != null) {
          authProvider.pendingRoute = '/view-loan-application';
          authProvider.pendingRouteParams = {
            'application-id': notifData['appl_id'],
          };
        }
        break;

      case 'credit-offer':
        if (notifData['appl_id'] != null) {
          authProvider.pendingRoute = '/view-credit-offer-application';
          authProvider.pendingRouteParams = {
            'application-id': notifData['appl_id'],
          };
        }

        break;

      case 'fee-table':
        if (notifData['appl_id'] != null) {
          authProvider.pendingRoute = '/view-fee-table';
          authProvider.pendingRouteParams = {
            'fee-table-id': notifData['appl_id'],
          };
        }
        break;
    }
  }
}
