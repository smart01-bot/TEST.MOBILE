import 'package:flutter/material.dart';

import '../services/inactivity_timer.dart';

class InactivityWatcher extends StatefulWidget {
  final Widget child;

  const InactivityWatcher({
    super.key,
    required this.child,
  });

  @override
  InactivityWatcherState createState() => InactivityWatcherState();
}

class InactivityWatcherState extends State<InactivityWatcher> {
  void _resetTimer() {
    InactivityTimer().cancel();
    InactivityTimer().start();
  }

  void _handleUserInteraction([_]) {
    _resetTimer();
    FocusScope.of(context).unfocus();
  }

  @override
  void initState() {
    super.initState();
    _resetTimer();
  }

  @override
  void dispose() {
    InactivityTimer().cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: _handleUserInteraction,
      onPanDown: _handleUserInteraction,
      child: widget.child,
    );
  }
}
