import 'package:flutter/material.dart';

class NotificationProvider with ChangeNotifier {
  List<Map<String, dynamic>> _notifications = [
    // {
    //   "notifID": "1712854567890",
    //   "type": "account",
    //   "status": "logged-in",
    //   "time": "12 January 2025 14:58",
    //   "location": "Dar es Salaam, Tanzania",
    //   "device": "Apple 16 Pro Max",
    // },
  ];

  List<Map<String, dynamic>> get notifications {
    return _notifications;
  }

  void addNotification(Map<String, dynamic> entry) {
    Map<String, dynamic> item = {"notifID": "${DateTime.now().millisecondsSinceEpoch}", ...entry};
    _notifications.add(item);
    notifyListeners();
  }

  void removeNotification(String notifID) {
    _notifications.removeWhere((map) => map['notifID'] == notifID);
    notifyListeners();
  }

  void clearNotifications(String notifID) {
    _notifications = [];
    notifyListeners();
  }
}
