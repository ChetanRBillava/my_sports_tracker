import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_sports_tracker/logics/cubits/app_theme_cubit.dart';
import 'package:my_sports_tracker/presentation/router/app_router.dart';
import 'package:my_sports_tracker/presentation/screens/home/logic/home_screen_bloc.dart';
import 'package:my_sports_tracker/presentation/screens/match/logic/match_screen_bloc.dart';
import 'package:my_sports_tracker/core/services/app_bootstrap.dart';
import 'core/constants/app_strings.dart';
import 'core/services/app_navigator_observer.dart';

Future<void> main() async {
  await AppBootstrap.initialize();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => AppThemeCubit()),
        BlocProvider(create: (context) => HomeScreenBloc()),
        BlocProvider(create: (context) => MatchScreenBloc()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: AppStrings.appName,
        initialRoute: AppRouter.home,
        onGenerateRoute: AppRouter.onGenerateRoute,
        navigatorObservers: [AppNavigatorObserver()],
      ),
    );
  }
}
