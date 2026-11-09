import 'package:flutter/material.dart';

/// Local-only placeholder; no Google or Card Informatics endpoint is probed.
class InternetProvider with ChangeNotifier {
  bool _hasInternet = false;
  bool get hasInternet => _hasInternet;

  bool _isCheckingInternet = false;
  bool get isCheckingInternet => _isCheckingInternet;

  Future<void> retryConnection() async {
    _isCheckingInternet = false;
    _hasInternet = false;
    notifyListeners();
  }
}