import 'dart:async';

import 'package:flutter/material.dart';

class InactivityTimer {
  static final InactivityTimer _instance = InactivityTimer._internal();
  factory InactivityTimer() => _instance;
  InactivityTimer._internal();

  Timer? _timer;
  Duration duration = const Duration(minutes: 3);
  VoidCallback? onTimeout;

  void start() {
    cancel();
    _timer = Timer(duration, () {
      onTimeout?.call();
    });
  }

  void reset() => start();

  void cancel() {
    if (_timer?.isActive ?? false) {
      _timer?.cancel();
    }
  }

  bool get isRunning => _timer?.isActive ?? false;
}
