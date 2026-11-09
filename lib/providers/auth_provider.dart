import 'package:flutter/material.dart';

/// Local demo session. No credentials are sent to a remote authentication
/// service; the app opens with a clearly labelled TEST demonstration profile.
class AuthProvider with ChangeNotifier {
  bool _isAuthenticated = true;
  String _pendingRoute = "";
  Map<String, dynamic> _pendingRouteParams = {};

  Map<String, dynamic> _userData = {
    'name': 'TEST Demo User',
    'profile-image': '',
    'client-id': 'TEST-DEMO',
    'is-profile-completed': true,
  };
  String _accountType = "personal";

  bool get isAuthenticated => _isAuthenticated;
  String get pendingRoute => _pendingRoute;
  Map<String, dynamic> get pendingRouteParams => _pendingRouteParams;
  Map<String, dynamic> get userData => _userData;
  String get accountType => _accountType;

  set accountType(String type) {
    _accountType = type;
    notifyListeners();
  }

  set userData(Map<String, dynamic> data) {
    _userData = data;
    notifyListeners();
  }

  void updateProfileImage(String imagepath) {
    _userData = {..._userData, 'profile-image': imagepath};
    notifyListeners();
  }

  set pendingRoute(String data) {
    _pendingRoute = data;
    notifyListeners();
  }

  set pendingRouteParams(Map<String, dynamic> data) {
    _pendingRouteParams = data;
    notifyListeners();
  }

  void login() {
    _isAuthenticated = true;
    notifyListeners();
  }

  void logout() {
    // There is no remote account to sign out of in local demo mode.
    _isAuthenticated = true;
    _userData = {
      'name': 'TEST Demo User',
      'profile-image': '',
      'client-id': 'TEST-DEMO',
      'is-profile-completed': true,
    };
    _accountType = "personal";
    notifyListeners();
  }
}
