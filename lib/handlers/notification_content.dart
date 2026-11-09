import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'notification-content/account.dart';
import 'notification-content/credit_offer.dart';
import 'notification-content/fee_table.dart';
import 'notification-content/loan.dart';

Map<String, dynamic> getNotifContent(Map<String, dynamic> info) {
  if (info['type'] != null) {
    switch (info['type']) {
      case "account":
        return getAccountNotifContent(info);

      case "loan":
        return getLoanNotifContent(info);

      case "credit-offer":
        return getCreditOfferNotifContent(info);

      case "fee-table":
        return getFeeTableNotifContent(info);

      default:
        return {
          "title": "You have an update",
          "message": "Click to view more.",
          "icon": FontAwesomeIcons.triangleExclamation,
        };
    }
  } else {
    return {
      "title": "You have an update",
      "message": "Click to view more.",
      "icon": FontAwesomeIcons.triangleExclamation,
    };
  }
}
