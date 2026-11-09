import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';

import '../constants/colors.dart';
import '../helpers/force_logout.dart';
import '../providers/api_provider.dart';
import '../providers/auth_provider.dart';
import '../services/api_service.dart';
import '../services/storage_service.dart';
import '../services/navigator_service.dart';

class DeciderWrapper extends StatefulWidget {
  const DeciderWrapper({super.key});

  @override
  DeciderWrapperState createState() => DeciderWrapperState();
}

class DeciderWrapperState extends State<DeciderWrapper> {
  late AuthProvider authProvider;
  late APIProvider apiProvider;

  FirebaseMessaging messaging = FirebaseMessaging.instance;
  final storage = StorageService();

  bool systemError = false;

  @override
  void initState() {
    super.initState();
    authProvider = Provider.of<AuthProvider>(context, listen: false);
    apiProvider = Provider.of<APIProvider>(context, listen: false);
    _initAsync(context);
  }

  Future<void> _initAsync(context) async {
    await _checkValidity();
  }

  Future<String> getAppVersionString() async {
    final info = await PackageInfo.fromPlatform();
    return info.version; // e.g. "1.2.3"
  }

  Future<void> _checkValidity() async {
    try {
      final response = await ApiService.post('ping', data: {
        "app-version": await getAppVersionString(),
      });
      if (response != null &&
          response.containsKey('error') &&
          response['error'] == "ip-restricted") {
        navigatorKey.currentState?.pushNamedAndRemoveUntil(
          '/ip-restricted',
          (route) => false,
        );
      } else if (response != null &&
          response.containsKey('error') &&
          response['error'] == "incompatible-version") {
        navigatorKey.currentState?.pushNamedAndRemoveUntil(
          '/incompatible-version',
          (route) => false,
        );
      } else if (response != null && response.containsKey('success')) {
        if (mounted) {
          await _checkAuthentication(context);
        }
      } else {
        setState(() {
          systemError = true;
        });
      }
    } catch (e) {
      setState(() {
        systemError = true;
      });
      return;
    }
  }

  Future<bool> _checkTokenValidity(String token) async {
    try {
      final response = await ApiService.post(
        'login',
        data: {},
        token: token,
      );
      return response != null && response['error'] == "already-logged-in";
    } catch (e) {
      return false;
    }
  }

  void _navigateBasedOnAuth(bool isAuthenticated, BuildContext context) async {
    if (!isAuthenticated) {
      String isNew = await storage.get('already_onboarded') ?? '';
      if (isNew.isNotEmpty) {
        if (context.mounted) {
          Navigator.pushReplacementNamed(context, '/account-chooser');
        }
      } else {
        await storage.set('already_onboarded', 'true');
        if (context.mounted) {
          Navigator.pushReplacementNamed(context, '/onboarding');
        }
      }
    } else {
      // Fetch user data
      try {
        final response =
            await ApiService.get('dashboard', token: apiProvider.authToken);

        if (response != null) {
          if (response.containsKey('error')) {
            if (context.mounted) {
              forceLogout(context, mounted);
            }
            return;
          } else {
            authProvider.userData = response['user-data'];

            // Check if passcode was set

            String? storedPasscode = await storage.get("app_pass_code");
            if (storedPasscode == null || storedPasscode.isEmpty) {
              if (context.mounted) {
                Navigator.pushReplacementNamed(context, '/set-pass-code');
              } else {
                return;
              }
            } else {
              if (context.mounted) {
                Navigator.pushReplacementNamed(context, '/enter-pass-code');
              } else {
                return;
              }
            }
          }
        }
      } catch (e) {
      }
    }
  }

  void saveFCMTokenToServer(String? token) async {
    if (token == null) return;
    try {
      final response = await ApiService.post(
        'save-fcm-token',
        token: apiProvider.authToken,
        data: {
          'fcm-token': token,
        },
      );

      if (response != null) {
        if (response.containsKey('success')) {
          storage.set('fcm_token_saved_to_db', 'TRUE');
        }
      }
    } catch (e) {
      //
    }
  }

  Future<void> _checkAuthentication(BuildContext context) async {
    if (apiProvider.authToken.isEmpty) {
      String? storedToken = await storage.get('auth_token');
      apiProvider.authToken = storedToken ?? '';
    }

    if (apiProvider.authToken.isNotEmpty) {
      bool isTokenValid = await _checkTokenValidity(apiProvider.authToken);
      if (isTokenValid) {
        authProvider.login();

        requestNotificationPermissions();

        // Get the FCM token
        String? savedToken = await storage.get('fcm_token');
        if (savedToken == null) {
          messaging.getToken().then((token) {
            if (token != null) {
            } else {
            }
            storage.set('fcm_token', token ?? '');
            saveFCMTokenToServer(token);
            savedToken = token;
          }).catchError((e) {
          });
        }


        // Listen for token refresh
        messaging.onTokenRefresh.listen((newToken) {
          storage.set('fcm_token', newToken);
          saveFCMTokenToServer(newToken);
        });

        bool isSavedToken = await storage.get('fcm_token_saved_to_db') != null;

        if (!isSavedToken) {
          saveFCMTokenToServer(savedToken);
        }

        // Handling background messages
        // FirebaseMessaging.onBackgroundMessage((RemoteMessage message) async {

        // });

        if (context.mounted) _navigateBasedOnAuth(true, context);
        return;
      }
    }

    if (context.mounted) _navigateBasedOnAuth(false, context);
  }

  Future<void> requestNotificationPermissions() async {
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
    } else {
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            flex: 1,
            child: Container(
              color: CIColors.canvasBGColor,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: Image.asset(
                        'assets/card_logo.png',
                        fit: BoxFit.contain,
                        width: 180,
                        height: 90,
                      ),
                    ),
                    if (systemError) Text('An error occured'),
                    if (!systemError)
                      SizedBox(
                        width: 25,
                        height: 25,
                        child: CircularProgressIndicator(
                          color: CIColors.accentColor,
                          strokeWidth: 3,
                        ),
                      ),
                    SizedBox(height: 100),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}