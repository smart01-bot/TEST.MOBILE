import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../config.dart';

class InternetProvider with ChangeNotifier {
  bool _hasInternet = true;
  bool get hasInternet => _hasInternet;

  bool _isCheckingInternet = false;
  bool get isCheckingInternet => _isCheckingInternet;

  late StreamSubscription _subscription;

  InternetProvider() {
    _monitorConnection();
  }

  void _monitorConnection() {
    _subscription = Connectivity().onConnectivityChanged.listen((_) {
      _checkInternetAccess();
    });

    // Initial check
    _checkInternetAccess();
  }

  Future<void> _checkInternetAccess() async {
    _isCheckingInternet = true;
    notifyListeners();
    try {
      final response = await http
          .get(Uri.parse("https://clients3.google.com/generate_204"))
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 204) {
        _updateStatus(true);
        return;
      } else {
        final response = await http
            .get(Uri.parse("${AppConfig.serverUrl}/check-net-8934.php"))
            .timeout(const Duration(seconds: 20));

        if (response.statusCode == 200) {
          _updateStatus(true);
          return;
        }
      }
    } on TimeoutException catch (_) {
      _updateStatus(false);
    } on Exception catch (_) {
      _updateStatus(false);
    }

    _updateStatus(false);
  }

  void _updateStatus(bool status) {
    if (_hasInternet != status) {
      _hasInternet = status;
      notifyListeners();
    }
     _isCheckingInternet = false;
     notifyListeners();
  }

  Future<void> retryConnection() async {
    await _checkInternetAccess();
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
