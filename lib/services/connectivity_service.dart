import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:http/http.dart' as http;

class ConnectivityService {
  final _controller = StreamController<bool>.broadcast();

  late final StreamSubscription _connectivitySubscription;

  final String checkUrl;

  ConnectivityService({required this.checkUrl}) {
    // Listen to network type changes (WiFi, Mobile, none)
    _connectivitySubscription =
        Connectivity().onConnectivityChanged.listen((_) {
      checkInternetConnection();
    });

    // Initial check
    checkInternetConnection();
  }

  Stream<bool> get connectivityStream => _controller.stream;

  /// Custom method to check internet using your endpoint
  Future<void> checkInternetConnection() async {
    try {
      final response = await http.head(Uri.parse(checkUrl)).timeout(Duration(seconds: 5));
      final isOnline = response.statusCode == 200;
      _controller.sink.add(isOnline);
    } catch (_) {
      _controller.sink.add(false);
    }
  }

  void dispose() {
    _connectivitySubscription.cancel();
    _controller.close();
  }
}
