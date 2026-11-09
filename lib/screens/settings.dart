import 'package:flutter/material.dart';

import '../wrappers/authed_wrapper.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {

    return AuthedWrapper(
      child: Center(
        child: Text('This is the Settings Screen.'),
      ),
    );
  }
}
