import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_sports_tracker/logics/cubits/app_theme_cubit.dart';
import 'package:my_sports_tracker/presentation/router/AppRouter.dart';
import 'package:my_sports_tracker/presentation/screens/home/logic/home_screen_bloc.dart';
import 'package:my_sports_tracker/presentation/screens/home/screens/home_screen.dart';
import 'package:my_sports_tracker/presentation/screens/match/logic/match_screen_bloc.dart';

void main() {
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
        title: 'My Sports Tracker',
        initialRoute: AppRouter.home,
        onGenerateRoute: AppRouter.onGenerateRoute,
      ),
    );
  }
}
