import 'package:font_awesome_flutter/font_awesome_flutter.dart';

Map<String, dynamic> getLoanNotifContent(Map<String, dynamic> info) {
  String notificationKey = "${info['type']}/${info['status']}";
  switch (notificationKey) {
    case "loan/Reply_Reviewed":
      String midMessage = "";
      if (info['appl_code'] != null) {
        midMessage = "with code ${info['appl_code']} ";
      }
      String message =
          "Your loan application ${midMessage}have been replied to. Click to view it now";
      return {
        "title": "Account logged in",
        "message": message,
        "icon": FontAwesomeIcons.solidCircleCheck,
      };
    case "loan/Rejected":
      String midMessage = "";
      if (info['appl_code'] != null) {
        midMessage = "with code ${info['appl_code']} ";
      }
      String message =
          "Your loan application ${midMessage}was not cleared. Click to view the reason.";
      return {
        "title": "Loan Application Rejected",
        "message": message,
        "icon": FontAwesomeIcons.solidCircleXmark,
      };
    case "loan/Approved":
      String midMessage = "";
      if (info['appl_code'] != null) {
        midMessage = "with code ${info['appl_code']} ";
      }
      String message =
          "Your loan application ${midMessage}has been approved. Click to view more.";
      return {
        "title": "Loan Application Approved",
        "message": message,
        "icon": FontAwesomeIcons.solidCircleCheck,
      };

    default:
      return {
        "title": "You have an update",
        "message": "Click to view more.",
        "icon": FontAwesomeIcons.triangleExclamation,
      };
  }
}
