import 'package:flutter/material.dart';

class AuthProvider with ChangeNotifier {
  bool _isAuthenticated = false;
  String _pendingRoute = "";
  Map<String, dynamic> _pendingRouteParams = {};

  Map<String, dynamic> _userData = {};
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
    _userData = {
      ..._userData,
      'profile-image': imagepath,
    };
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
    _userData = {};
    _isAuthenticated = false;
    _accountType = "personal";
    notifyListeners();
  }
}