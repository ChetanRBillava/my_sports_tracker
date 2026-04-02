import 'package:flutter/material.dart';
import 'package:my_sports_tracker/presentation/router/route_exception.dart';
import 'package:my_sports_tracker/presentation/screens/home/screens/home_screen.dart';
import 'package:my_sports_tracker/presentation/screens/match/screens/match_screen.dart';
import 'package:my_sports_tracker/presentation/screens/settings/settings_screen.dart';

class AppRouter {
  static const String home = 'home', match = 'match', settings = 'settings';

  const AppRouter._();

  static Route<dynamic> onGenerateRoute(RouteSettings routeSettings) {
    switch (routeSettings.name) {
      case home:
        return MaterialPageRoute(builder: (_) => const HomeScreen());
      case match:
        return MaterialPageRoute(builder: (_) => const MatchScreen());
      case settings:
        return MaterialPageRoute(builder: (_) => const SettingsScreen());
      default:
        throw const RouteException('Route not found!');
    }
  }

  static void navigateTo({
    required String routeName,
    required BuildContext context,
  }) {
    Navigator.of(context).pushNamed(routeName);
  }
}
