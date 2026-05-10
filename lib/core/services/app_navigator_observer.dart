import 'package:flutter/material.dart';
import 'package:my_sports_tracker/core/services/app_analytics.dart';

class AppNavigatorObserver extends NavigatorObserver {
  AppAnalytics appAnalytics = AppAnalytics();

  void _track(Route<dynamic>? route) {
    final screenName = route?.settings.name;
    final screenClass = route.runtimeType.toString();

    if (screenName != null && screenName.isNotEmpty) {
      appAnalytics.logViewAnalytics(
        screenName: screenName,
        screenClass: screenClass,
      );
    }
  }

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPush(route, previousRoute);
    _track(route);
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPop(route, previousRoute);
    _track(previousRoute);
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
    _track(newRoute);
  }
}
