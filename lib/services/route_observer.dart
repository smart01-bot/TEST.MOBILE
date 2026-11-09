import 'package:flutter/material.dart';

class RouteObserverWithCallback extends NavigatorObserver {
  final void Function(String? routeName, Map<String, dynamic>? routeArgs)
      onRouteChanged;

  RouteObserverWithCallback(this.onRouteChanged);

  @override
  void didPush(Route route, Route? previousRoute) {
    super.didPush(route, previousRoute);
    onRouteChanged(
        route.settings.name, route.settings.arguments as Map<String, dynamic>?);
  }

  @override
  void didPop(Route route, Route? previousRoute) {
    super.didPop(route, previousRoute);
    onRouteChanged(previousRoute?.settings.name,
        previousRoute?.settings.arguments as Map<String, dynamic>?);
  }

  @override
  void didReplace({Route? newRoute, Route? oldRoute}) {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
    onRouteChanged(newRoute?.settings.name,
        newRoute?.settings.arguments as Map<String, dynamic>?);
  }
}
