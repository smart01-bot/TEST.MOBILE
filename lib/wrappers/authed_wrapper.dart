import 'package:test_mobile/providers/notification_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:screen_capture_restrictions/screen_capture_restrictions.dart';

import '../components/loading_screen.dart';
import '../helpers/inactivity_watcher.dart';
import '../providers/api_provider.dart';
import '../providers/auth_provider.dart';
import '../providers/overlay_controller.dart';

class AuthedWrapper extends StatefulWidget {
  final Widget child;
  final Widget? appBar;
  final Widget? bottomBar;
  final GlobalKey<ScaffoldState>? scaffoldKey;
  final ScrollController? scrollController;
  final RefreshCallback? handleRefresh;

  const AuthedWrapper({
    super.key,
    required this.child,
    this.appBar,
    this.bottomBar,
    this.scaffoldKey,
    this.scrollController,
    this.handleRefresh,
  });

  @override
  AuthedWrapperState createState() => AuthedWrapperState();
}

class AuthedWrapperState extends State<AuthedWrapper> {
  late AuthProvider authProvider;
  late APIProvider apiProvider;
  late NotificationProvider _notificationProvider;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    apiProvider = Provider.of<APIProvider>(context, listen: false);
    authProvider = Provider.of<AuthProvider>(context, listen: false);
    _enableSecure();
    if (mounted) {
      _checkAuthentication(context);
    }
  }

  Future<void> _enableSecure() async {
    await ScreenCaptureRestrictions.enableSecure();
  }

  Future<void> _checkAuthentication(BuildContext context) async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    // Check if the user is authenticated
    if (!authProvider.isAuthenticated) {
      // If not authenticated, navigate to the login page
      authProvider.pendingRoute = ModalRoute.of(context)!.settings.name!;
      Navigator.pushReplacementNamed(context, '/');
    } else {
      // If not authenticated, stop loading
      setState(() {
        _isLoading = false;
      });
    }
  }

  static Future<void> _defaultRefresh() async {
    await Future.delayed(Duration(seconds: 1));
  }

  @override
  Widget build(BuildContext context) {
    final overlayProvider =
        Provider.of<OverlayProvider>(context, listen: false);
    double statusBarHeight = MediaQuery.of(context).padding.top;
    double bottomNavHeight = MediaQuery.of(context).padding.bottom;

    Widget scrollView = SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      controller: widget.scrollController,
      child: Padding(
        padding: EdgeInsets.only(
          bottom: 8 + bottomNavHeight,
          left: 8,
          right: 8,
          top: 0,
        ),
        child: _isLoading ? LoadingScreen() : widget.child,
      ),
    );

    // Render the child if the user is authenticated
    return InactivityWatcher(
      child: Scaffold(
        key: widget.scaffoldKey,
        body: Column(
          children: [
            SizedBox(height: statusBarHeight),
            if (widget.appBar != null) widget.appBar!,
            Flexible(
              flex: 1,
              child: widget.handleRefresh != null
                  ? RefreshIndicator(
                      onRefresh: widget.handleRefresh ?? _defaultRefresh,
                      child: scrollView,
                    )
                  : scrollView,
            ),
            if (widget.bottomBar != null) widget.bottomBar!,
          ],
        ),
      ),
    );
  }
}