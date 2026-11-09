import 'package:font_awesome_flutter/font_awesome_flutter.dart';

Map<String, dynamic> getAccountNotifContent(Map<String, dynamic> info) {
  String notificationKey = "${info['type']}/${info['status']}";
  switch (notificationKey) {
    case "account/logged-in":
      String message = "Another device has logged into your account.";
      if (info['device'] != null &&
          info['location'] != null &&
          info['time'] != null) {
        message +=
            " Device: ${info['device']}. Location: ${info['location']}. Time: ${info['time']}";
      }
      return {
        "title": "Account logged in",
        "message": message,
        "icon": FontAwesomeIcons.solidUser,
      };

    default:
      return {
        "title": "You have an update",
        "message": "Click to view more.",
        "icon": FontAwesomeIcons.triangleExclamation,
      };
  }
}
