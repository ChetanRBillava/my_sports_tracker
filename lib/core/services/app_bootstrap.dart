import 'dart:ui';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'notification_handler.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_analytics/firebase_analytics.dart';

import '../constants/app_bools.dart';
import '../../data/repositories/app_config_repository.dart';
import '../../presentation/utils/custom_print.dart';
import '../constants/app_strings.dart';

class AppBootstrap {
  static CustomPrint customPrint = CustomPrint();

  static Future<void> initialize() async {
    await initializeFireBase();
    await initializeCrashlytics();
    await initializeRemoteConfig();
    await initializeDbConnection();
    await initializeNotifications();
  }

  static Future<void> initializeFireBase() async {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp();
  }

  static Future<void> initializeCrashlytics() async {
    FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;

    PlatformDispatcher.instance.onError = (error, stack) {
      FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
      return true;
    };

    await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);
  }

  static Future<void> initializeRemoteConfig() async {
    final FirebaseRemoteConfig remoteConfig = FirebaseRemoteConfig.instance;
    await remoteConfig.setConfigSettings(
      RemoteConfigSettings(
        fetchTimeout: const Duration(seconds: 10),
        minimumFetchInterval: const Duration(seconds: 30),
      ),
    );

    await remoteConfig.fetchAndActivate();

    AppBools.connectDB = remoteConfig.getBool('connectDB');
    AppBools.isOnMaintenance = remoteConfig.getBool('isOnMaintenance');
    String
    minVersion = remoteConfig.getString('minVersion').replaceAll('.', ''),
    latestVersion = remoteConfig.getString('latestVersion').replaceAll('.', ''),
    currentAppVersion = AppStrings.appVersion.replaceAll('.', '');

    customPrint.print(
      message:
          'Current version: $currentAppVersion, Latest Version: $latestVersion, Min Version: $minVersion',
    );

    if (int.parse(currentAppVersion) < int.parse(minVersion)) {
      AppBools.forceUpdate = true;
    } else if (int.parse(currentAppVersion) < int.parse(latestVersion)) {
      AppBools.optionalUpdate = true;
    }

    customPrint.print(
      message:
          'forceUpdate: ${AppBools.forceUpdate}, optionalUpdate: ${AppBools.optionalUpdate}',
    );
  }

  static Future<void> initializeDbConnection() async {
    if (AppBools.connectDB) {
      customPrint.print(message: 'Connecting with DB');
      AppConfigRepository appConfigRepository = AppConfigRepository();

      AppBools.isDbConnected = await appConfigRepository.testApi();

      customPrint.print(message: 'isDbConnected: ${AppBools.isDbConnected}');
    } else {
      customPrint.print(message: 'DB Connection skipped');
    }
  }

  static Future<void> initializeNotifications() async {
    final messaging = FirebaseMessaging.instance;

    // Request permission
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      customPrint.print(message: 'User granted notification permission');
    }

    // Get FCM token for targeted notifications
    String? token = await messaging.getToken();
    customPrint.print(
      message: 'FCM Token: $token',
    ); // Send this to your backend

    // Foreground handler
    FirebaseMessaging.onMessage.listen(NotificationHandler.onForeground);

    // Background/terminated handler
    FirebaseMessaging.onBackgroundMessage(
      NotificationHandler.backgroundHandler,
    );

    // Notification tap handler
    FirebaseMessaging.onMessageOpenedApp.listen(NotificationHandler.onTap);
  }
}
