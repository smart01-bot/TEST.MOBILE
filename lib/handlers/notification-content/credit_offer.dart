import 'package:font_awesome_flutter/font_awesome_flutter.dart';

Map<String, dynamic> getCreditOfferNotifContent(Map<String, dynamic> info) {
  String notificationKey = "${info['type']}/${info['status']}";
  switch (notificationKey) {
    case "credit-offer/Sent_To_User":
      String midMessage = "";
      if (info['appl_code'] != null) {
        midMessage = "with code ${info['appl_code']} ";
      }
      String message =
          "Your credit offer application ${midMessage}has been accepted. Click to reply now";
      return {
        "title": "Accepted Credit Offer Application",
        "message": message,
        "icon": FontAwesomeIcons.solidCircleCheck,
      };
    case "credit-offer/Rejected":
      String midMessage = "";
      if (info['appl_code'] != null) {
        midMessage = "with code ${info['appl_code']} ";
      }
      String message =
          "Your credit offer application ${midMessage}was not cleared. Click to view the reason.";
      return {
        "title": "Rejected Credit Offer Application",
        "message": message,
        "icon": FontAwesomeIcons.solidCircleXmark,
      };
    case "credit-offer/Bank_Reply_Rejected":
      String midMessage = "";
      if (info['appl_code'] != null) {
        midMessage = "with code ${info['appl_code']} ";
      }
      String message =
          "Your reply to a credit offer application ${midMessage}has been rejected. Click to view the reason.";
      return {
        "title": "Rejected Credit Offer Reply",
        "message": message,
        "icon": FontAwesomeIcons.solidCircleXmark,
      };
    case "credit-offer/Reply_Rejected":
      String midMessage = "";
      if (info['appl_code'] != null) {
        midMessage = "with code ${info['appl_code']} ";
      }
      String message =
          "Your reply to a credit offer application ${midMessage}has been rejected. Click to view the reason.";
      return {
        "title": "Rejected Credit Offer Reply",
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
