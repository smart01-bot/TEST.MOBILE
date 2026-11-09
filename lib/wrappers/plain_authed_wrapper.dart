import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/api_provider.dart';
import '../providers/auth_provider.dart';

class PlainAuthedWrapper extends StatefulWidget {
  final Widget child;

  const PlainAuthedWrapper({
    super.key,
    required this.child,
  });

  @override
  PlainAuthedWrapperState createState() => PlainAuthedWrapperState();
}

class PlainAuthedWrapperState extends State<PlainAuthedWrapper> {
  late AuthProvider authProvider;
  late APIProvider apiProvider;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   apiProvider = Provider.of<APIProvider>(context, listen: false);
    //   authProvider = Provider.of<AuthProvider>(context, listen: false);
    //   _checkAuthentication();
    // });
  }

  Future<void> _checkAuthentication() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    // Check if the user is authenticated
    if (!authProvider.isAuthenticated) {
      // If not authenticated, navigate to the login page
      WidgetsBinding.instance.addPostFrameCallback((_) {
        authProvider.pendingRoute = ModalRoute.of(context)!.settings.name!;
        Navigator.pushReplacementNamed(context, '/');
      });
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
    // Render the child if the user is authenticated
    return Scaffold(
      body: Column(
        children: [
          SizedBox(height: statusBarHeight),
          Padding(
            padding: EdgeInsets.only(
              bottom: 16,
              left: 16,
              right: 16,
              top: 8,
            ),
            child: widget.child,
          ),
        ],
      ),
    );
  }
}
