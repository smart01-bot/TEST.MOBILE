import 'package:flutter/material.dart';

import '../services/storage_service.dart';

class APIProvider with ChangeNotifier {
  final storage = StorageService();

  String _authToken = '';

  String get authToken {
    return _authToken;
  }

  set authToken(String token) {
    _authToken = token;
    notifyListeners();
    _saveAuthToken(token);
  }

  void resetToken() {
    _authToken = '';
    notifyListeners();
    _clearAuthToken();
  }

  Future<void> _saveAuthToken(String token) async {
    await storage.set('auth_token', token);
  }

  Future<void> _clearAuthToken() async {
    await storage.delete('auth_token');
  }
}
