import 'package:font_awesome_flutter/font_awesome_flutter.dart';

Map<String, dynamic> getFeeTableNotifContent(Map<String, dynamic> info) {
  String notificationKey = "${info['type']}/${info['status']}";
  switch (notificationKey) {
    case "fee-table/Reviewed":
      String midMessage = "";
      if (info['appl_code'] != null) {
        midMessage = "with code ${info['appl_code']} ";
      }
      String message =
          "A new fee table for your loan application ${midMessage}has been submitted. Click to reply to it now.";
      return {
        "title": "New Fee Table",
        "message": message,
        "icon": FontAwesomeIcons.solidCircleCheck,
      };

    case "fee-table/Bank_Declined":
      String midMessage = "";
      if (info['appl_code'] != null) {
        midMessage = "with code ${info['appl_code']} ";
      }
      String message =
          "Your fee table reply for your loan application ${midMessage}has been declined.";
      return {
        "title": "Fee Table Reply Declined",
        "message": message,
        "icon": FontAwesomeIcons.solidCircleXmark,
      };

    default:
      return {
        "title": "You have an update",
        "message": "Click to view more.",
        "icon": FontAwesomeIcons.triangleExclamation,
      };
  }
}
