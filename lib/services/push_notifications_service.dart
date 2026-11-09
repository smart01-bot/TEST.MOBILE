import 'package:firebase_messaging/firebase_messaging.dart';

class PushNotificationsService {
  final FirebaseMessaging _fcm = FirebaseMessaging.instance;

  Future<void> init() async {
    NotificationSettings settings = await _fcm.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    // Getting the device token
    String? token = await _fcm.getToken();
    

    //Handle foreground messages
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    });

    // Handle app opened from terminated state
    RemoteMessage? initialMessage = await _fcm.getInitialMessage();
    if (initialMessage != null) {
    }
  }
}
