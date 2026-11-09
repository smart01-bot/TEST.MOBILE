import 'dart:typed_data';

import 'package:flutter/material.dart';

class OverlayProvider extends ChangeNotifier {
  // Global
  String _currentRoute = '';
  String _currentRouteFilter = '';
  bool _screenPaused =
      false; // if the user screen was paused by the system (screen lock, went background etc)
  bool _inLocableScreen = false;

  // pause app locking (when uploading files etc)
  bool _isAppLockingPaused = false;
  bool get isAppLockingPaused => _isAppLockingPaused;
  void pauseAppLocking() {
    _isAppLockingPaused = true;
    notifyListeners();
  }

  void resumeAppLocking() {
    _isAppLockingPaused = false;
    notifyListeners();
  }

  // is locked due to inactivity timeout
  bool _isTimeoutLocked = false;
  bool get isTimeoutLocked => _isTimeoutLocked;
  set isTimeoutLocked(bool value) {
    _isTimeoutLocked = value;
    notifyListeners();
  }

  String get currentRoute => _currentRoute;
  bool get screenPaused => _screenPaused;
  bool get inLocableScreen => _inLocableScreen;
  String get currentRouteFilter => _currentRouteFilter;

  set currentRoute(String route) {
    if (_currentRoute != route) {
      _currentRoute = route;
      notifyListeners();
    }
  }

  set screenPaused(bool route) {
    _screenPaused = route;
    notifyListeners();
  }

  set inLocableScreen(bool route) {
    _inLocableScreen = route;
    notifyListeners();
  }

  void setInLocableScreenWithoutNotify(bool value) {
    _inLocableScreen = value;
  }

  set currentRouteFilter(String routeFilter) {
    if (_currentRouteFilter != routeFilter) {
      _currentRouteFilter = routeFilter;
      notifyListeners();
    }
  }

  // Notification Overlay
  final ValueNotifier<bool> _showNotificationOverlay = ValueNotifier(false);
  ValueNotifier<bool> get isShownNotificationOverlay =>
      _showNotificationOverlay;

  void showNotificationOverlay() {
    _showNotificationOverlay.value = true;
    notifyListeners();
  }

  void hideNotificationOverlay() {
    _showNotificationOverlay.value = false;
    notifyListeners();
  }

  // Doc Viewer Overlay

  String _docViewerName = '';
  Uint8List? _docViewerLink;

  String get docViewerName => _docViewerName;
  Uint8List? get docViewerLink => _docViewerLink;

  set docViewerName(String route) {
    _docViewerName = route;
    notifyListeners();
  }

  set docViewerLink(Uint8List? route) {
    _docViewerLink = route;
    notifyListeners();
  }

  final ValueNotifier<bool> _showDocViewerOverlay = ValueNotifier(false);
  ValueNotifier<bool> get isShownDocViewerOverlay => _showDocViewerOverlay;

  void showDocViewerOverlay() {
    _showDocViewerOverlay.value = true;
    notifyListeners();
  }

  void hideDocViewerOverlay() {
    _showDocViewerOverlay.value = false;
    notifyListeners();
  }

  // Web Viewer Overlay

  String _webViewerName = 'Terms and Conditions';
  String _webViewerLink = '';

  String get webViewerName => _webViewerName;
  String get webViewerLink => _webViewerLink;

  set webViewerName(String route) {
    _webViewerName = route;
    notifyListeners();
  }

  set webViewerLink(String route) {
    _webViewerLink = route;
    notifyListeners();
  }

  final ValueNotifier<bool> _showWebViewerOverlay = ValueNotifier(false);
  ValueNotifier<bool> get isShownWebViewerOverlay => _showWebViewerOverlay;

  void showWebViewerOverlay() {
    _showWebViewerOverlay.value = true;
    notifyListeners();
  }

  void hideWebViewerOverlay() {
    _showWebViewerOverlay.value = false;
    notifyListeners();
  }

  // Drawer Overlay
  final ValueNotifier<bool> _showDrawerOverlay = ValueNotifier(false);
  ValueNotifier<bool> get isShownDrawerOverlay => _showDrawerOverlay;

  void showDrawerOverlay() {
    _showDrawerOverlay.value = true;
    notifyListeners();
  }

  void hideDrawerOverlay() {
    _showDrawerOverlay.value = false;
    notifyListeners();
  }

  // Applock Overlay
  final ValueNotifier<bool> _showAppLockOverlay = ValueNotifier(false);
  ValueNotifier<bool> get isShownAppLockOverlay => _showAppLockOverlay;

  void showAppLockOverlay() {
    if (_showAppLockOverlay.value == false) _showAppLockOverlay.value = true;
    notifyListeners();
  }

  void hideAppLockOverlay() {
    _showAppLockOverlay.value = false;
    notifyListeners();
  }

  // Loading Overlay
  final ValueNotifier<bool> _showLoadingOverlay = ValueNotifier(false);
  ValueNotifier<bool> get isShownLoadingOverlay => _showLoadingOverlay;

  void showLoadingOverlay() {
    _showLoadingOverlay.value = true;
    notifyListeners();
  }

  void hideLoadingOverlay() {
    _showLoadingOverlay.value = false;
    notifyListeners();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _showAppLockOverlay.dispose();
    _showDrawerOverlay.dispose();
    _showNotificationOverlay.dispose();
    _showLoadingOverlay.dispose();
    super.dispose();
  }
}
