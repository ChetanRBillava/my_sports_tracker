import 'package:flutter/material.dart';
import 'package:my_sports_tracker/core/constants/app_bools.dart';
import 'package:my_sports_tracker/presentation/router/route_exception.dart';
import 'package:my_sports_tracker/presentation/screens/home/screens/home_screen.dart';
import 'package:my_sports_tracker/presentation/screens/maintenance/screens/maintenance_screen.dart';
import 'package:my_sports_tracker/presentation/screens/match/screens/match_screen.dart';
import 'package:my_sports_tracker/presentation/screens/settings/settings_screen.dart';

import '../../main.dart';
import '../utils/custom_print.dart';

class AppRouter {
  static const String home = '/',
      match = '/match',
      settings = '/settings',
      maintenance = '/maintenance';

  const AppRouter._();

  static Route<dynamic> onGenerateRoute(RouteSettings routeSettings) {
    return MaterialPageRoute(
      settings: routeSettings,
      builder: (_) => getScreen(routeSettings.name!),
    );
  }

  static Widget getScreen(String routeName) {
    switch (routeName) {
      case home:
        return const HomeScreen();
      case match:
        return const MatchScreen();
      case settings:
        return const SettingsScreen();
      case maintenance:
        return const MaintenanceScreen();
      default:
        throw const RouteException('Route not found!');
    }
  }

  static void navigateTo({
    required String routeName,
    required BuildContext context,
    bool replace = false,
  }) {
    if (replace) {
      Navigator.of(context).pushReplacementNamed(routeName);
    } else {
      Navigator.of(context).pushNamed(routeName);
    }
  }
}
