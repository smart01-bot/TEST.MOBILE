import 'package:flutter/material.dart';

import '../screens/dashboard.dart';
import '../services/storage_service.dart';

/// Starts directly in local demo mode; no server-side sign-in or validation.
class DeciderWrapper extends StatefulWidget {
  const DeciderWrapper({super.key});

  @override
  State<DeciderWrapper> createState() => _DeciderWrapperState();
}

class _DeciderWrapperState extends State<DeciderWrapper> {
  @override
  void initState() {
    super.initState();
    _clearLegacyCredentials();
  }

  Future<void> _clearLegacyCredentials() async {
    final storage = StorageService();
    await storage.delete('auth_token');
    await storage.delete('fcm_token');
    await storage.delete('fcm_token_saved_to_db');
  }

  @override
  Widget build(BuildContext context) {
    return const DashboardScreen();
  }
}
