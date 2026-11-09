import 'dart:async';

/// Offline demo connectivity stream. It never probes a remote endpoint.
class ConnectivityService {
  final StreamController<bool> _controller =
      StreamController<bool>.broadcast();

  ConnectivityService() {
    _controller.add(true);
  }

  Stream<bool> get connectivityStream => _controller.stream;

  Future<void> checkInternetConnection() async {
    // No network connectivity check is performed in standalone TEST.
    _controller.add(true);
  }

  void dispose() {
    _controller.close();
  }
}
