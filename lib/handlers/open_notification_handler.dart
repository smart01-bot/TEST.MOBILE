import 'package:flutter/material.dart';

void openNotificationHandler(
  BuildContext? context,
  Map<String, dynamic> notifData, {
  GlobalKey<NavigatorState>? navigatorKey,
}) {
  if (notifData['type'] != null && notifData['status'] != null) {
    switch (notifData['type']) {
      case 'loan':
        if (notifData['appl_id'] != null) {
          if (navigatorKey != null) {
            navigatorKey.currentState?.pushNamed(
              '/view-loan-application',
              arguments: {
                'application-id': notifData['appl_id'],
              },
            );
          } else {
            if (context != null) {
              Navigator.pushNamed(
                context,
                '/view-loan-application',
                arguments: {
                  'application-id': notifData['appl_id'],
                },
              );
            }
          }
        }
        break;
      case 'credit-offer':
        if (notifData['appl_id'] != null) {
          if (navigatorKey != null) {
            navigatorKey.currentState?.pushNamed(
              '/view-credit-offer-application',
              arguments: {
                'application-id': notifData['appl_id'],
              },
            );
          } else {
            if (context != null) {
              Navigator.pushNamed(
                context,
                '/view-credit-offer-application',
                arguments: {
                  'application-id': notifData['appl_id'],
                },
              );
            }
          }
        }
        break;
      case 'fee-table':
        if (notifData['appl_id'] != null) {
          if (navigatorKey != null) {
            navigatorKey.currentState?.pushNamed(
              '/view-fee-table',
              arguments: {
                'fee-table-id': notifData['appl_id'],
              },
            );
          } else {
            if (context != null) {
              Navigator.pushNamed(
                context,
                '/view-fee-table',
                arguments: {
                  'fee-table-id': notifData['appl_id'],
                },
              );
            }
          }
        }
        break;
    }
  }
}
