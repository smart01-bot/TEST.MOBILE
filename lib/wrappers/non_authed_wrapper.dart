import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../components/loading_screen.dart';
import '../providers/auth_provider.dart';

class NonAuthedWrapper extends StatefulWidget {
  final Widget child;

  const NonAuthedWrapper({super.key, required this.child});

  @override
  NonAuthedWrapperState createState() => NonAuthedWrapperState();
}

class NonAuthedWrapperState extends State<NonAuthedWrapper> {
  bool _isLoading = true; // Initial loading state

  @override
  void initState() {
    super.initState();
    _checkAuthentication(context);
  }

  Future<void> _checkAuthentication(BuildContext context) async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    // Check if the user is authenticated
    if (authProvider.isAuthenticated) {
      // If authenticated, navigate to the dashboard
      Navigator.pushReplacementNamed(context, '/dashboard');
    } else {
      // If not authenticated, stop loading
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double statusBarHeight = MediaQuery.of(context).padding.top;
    // Render the child if the user is not authenticated
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.only(top: statusBarHeight),
        child: _isLoading ? LoadingScreen() : widget.child,
      ),
    );
  }
}
