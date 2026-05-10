// lib/services/notification_handler.dart
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/material.dart';

import '../../presentation/router/app_router.dart';
import '../../presentation/utils/custom_print.dart';
import 'app_analytics.dart';

class NotificationHandler {
  static final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();
  static final CustomPrint customPrint = CustomPrint();

  static Future<void> init() async {
    const AndroidInitializationSettings androidInit =
        AndroidInitializationSettings('notification_icon');
    const DarwinInitializationSettings iosInit = DarwinInitializationSettings();
    const InitializationSettings initSettings = InitializationSettings(
      android: androidInit,
      iOS: iosInit,
    );

    await _localNotifications.initialize(initSettings);
  }

  static Future<void> backgroundHandler(RemoteMessage message) async {
    customPrint.print(
      message:
          'Background notification received: ${message.notification?.title}, ${message.notification?.body}',
    );
    await Firebase.initializeApp();
    await init();
    await createNotification(message: message);
  }

  static Future<void> onForeground(RemoteMessage message) async {
    customPrint.print(
      message:
          'Foreground notification received: ${message.notification?.title}, ${message.notification?.body}',
    );
    await createNotification(message: message);
  }

  static Future<void> onTap(RemoteMessage message) async {
    customPrint.print(message: 'Notification tapped: ${message.data}');
    // Navigate based on data payload
    // Navigator.pushNamed(context, message.data['screen'] ?? '/');
  }

  static Future<void> createNotification({
    required RemoteMessage message,
  }) async {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
          'default_channel',
          'Default Channel',
          icon: 'notification_icon',
        );
    const DarwinNotificationDetails iosDetails = DarwinNotificationDetails();
    const NotificationDetails details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );
    try {
      await _localNotifications.show(
        message.hashCode,
        message.notification?.title ?? 'No title',
        message.notification?.body,
        details,
        payload: message.data['screen'] ?? 'home',
      );
    } catch (e, stack) {
      customPrint.print(message: 'Failed to display notification popup: $e');
      AppAnalytics appAnalytics = AppAnalytics();
      appAnalytics.logCrashlytics(
        exception: e,
        stack: stack,
        printDetails: true,
        reason: 'Failed to display notification popup',
      );
    }
  }
}
