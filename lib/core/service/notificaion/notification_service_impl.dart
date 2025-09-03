import 'dart:io';

import 'package:app_settings/app_settings.dart';
import 'package:finance_tracker/core/config/talker.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import '../../navigation/notificaion_action_handler.dart';
import 'notification_service.dart';

class FirebaseNotificationService implements NotificationService {
  static final FirebaseNotificationService _instance =
      FirebaseNotificationService._internal();

  factory FirebaseNotificationService() => _instance;

  FirebaseNotificationService._internal();

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();

  bool _isInitialized = false;
  static const int _dailyReminderNotificationId = 1001;

  static const iosDetails = DarwinNotificationDetails(
    presentAlert: true,
    presentBadge: true,
    presentSound: true,
    badgeNumber: 1,
  );

  @override
  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      tz.initializeTimeZones();

      try {
        final String timeZoneName = await FlutterTimezone.getLocalTimezone();
        tz.setLocalLocation(tz.getLocation(timeZoneName));
        appTalker?.debug('Timezone set to: $timeZoneName');
      } catch (e) {
        appTalker?.warning('Could not get timezone, using UTC: $e');
        tz.setLocalLocation(tz.getLocation('UTC'));
      }

      await _initializeLocalNotifications();
      await _initializeFirebaseMessaging();
      await requestPermission(false);

      _isInitialized = true;
      appTalker?.info('Firebase Notification Service initialized successfully');
    } catch (e) {
      appTalker?.error('Error initializing Firebase Notification Service: $e');
      rethrow;
    }
  }

  @override
  Future<String?> getToken() async {
    try {
      final token = await _firebaseMessaging.getToken();
      appTalker?.debug('FCM Token obtained: ${token?.substring(0, 20)}...');
      return token;
    } catch (e) {
      appTalker?.error('Error getting FCM token: $e');
      return null;
    }
  }

  @override
  Future<bool> areNotificationsEnabled() async {
    try {
      if (Platform.isAndroid) {
        final androidImplementation =
            _localNotifications
                .resolvePlatformSpecificImplementation<
                  AndroidFlutterLocalNotificationsPlugin
                >();
        return await androidImplementation?.areNotificationsEnabled() ?? false;
      } else if (Platform.isIOS) {
        final iosImplementation =
            _localNotifications
                .resolvePlatformSpecificImplementation<
                  IOSFlutterLocalNotificationsPlugin
                >();
        return await iosImplementation?.checkPermissions().then(
              (permissions) => permissions?.isAlertEnabled == true,
            ) ??
            false;
      }
      return false;
    } catch (e) {
      appTalker?.error('Error checking notification permissions: $e');
      return false;
    }
  }

  @override
  Future<bool> canScheduleExactAlarms() async {
    try {
      if (Platform.isAndroid) {
        final androidImplementation =
            _localNotifications
                .resolvePlatformSpecificImplementation<
                  AndroidFlutterLocalNotificationsPlugin
                >();

        // For Android 12+ (API 31+)
        if (Platform.version.contains('31') ||
            Platform.version.contains('32') ||
            Platform.version.contains('33')) {
          return await androidImplementation?.canScheduleExactNotifications() ??
              false;
        }
        // For older Android versions, exact alarms are allowed by default
        return true;
      }
      // iOS doesn't have exact alarm restrictions
      return true;
    } catch (e) {
      appTalker?.error('Error checking exact alarm permissions: $e');
      return false;
    }
  }

  @override
  Future<void> openNotificationSettings() async {
    try {
      appTalker?.debug('Opening app notification settings');

      if (Platform.isAndroid) {
        await AppSettings.openAppSettings(type: AppSettingsType.notification);
      } else if (Platform.isIOS) {
        await AppSettings.openAppSettings(type: AppSettingsType.settings);
      }

      appTalker?.info('Notification settings opened successfully');
    } catch (e) {
      appTalker?.error('Error opening notification settings: $e');
    }
  }

  @override
  Future<void> openExactAlarmSettings() async {
    try {
      if (Platform.isAndroid) {
        final androidImplementation =
            _localNotifications
                .resolvePlatformSpecificImplementation<
                  AndroidFlutterLocalNotificationsPlugin
                >();
        await androidImplementation?.requestExactAlarmsPermission();
      }
    } catch (e) {
      appTalker?.error('Error opening exact alarm settings: $e');
    }
  }

  // Helper method to check all permissions at once
  Future<Map<String, bool>> checkAllPermissions() async {
    return {
      'notifications': await areNotificationsEnabled(),
      'exactAlarms': await canScheduleExactAlarms(),
    };
  }

  @override
  Future<PermissionResult> requestPermission(bool autoOpenSettings) async {
    try {
      final settings = await _firebaseMessaging.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true,
      );

      appTalker?.debug(
        'FCM Permission status: ${settings.authorizationStatus}',
      );

      switch (settings.authorizationStatus) {
        case AuthorizationStatus.authorized:
        case AuthorizationStatus.provisional:
          appTalker?.info('Notification permissions granted');
          if (Platform.isIOS) {
            await _requestIOSPermissions();
          }
          return PermissionResult.granted;

        case AuthorizationStatus.denied:
          // Check if we should open settings automatically
          if (await _shouldAutoOpenSettings()) {
            appTalker?.info(
              'Opening notification settings due to permanent denial',
            );
            if (autoOpenSettings) await openNotificationSettings();
            return PermissionResult.permanentlyDenied;
          }
          appTalker?.warning('Notification permissions denied by user');
          return PermissionResult.denied;

        case AuthorizationStatus.notDetermined:
          appTalker?.debug('Notification permissions not determined');
          return PermissionResult.denied;
      }
    } catch (e) {
      appTalker?.error('Error requesting notification permission: $e');
      return PermissionResult.error;
    }
  }

  // Private helper method
  Future<bool> _shouldAutoOpenSettings() async {
    try {
      final settings = await _firebaseMessaging.getNotificationSettings();

      // If denied and we've likely asked before, auto-open settings
      return settings.authorizationStatus == AuthorizationStatus.denied;
    } catch (e) {
      return false;
    }
  }

  Future<void> _requestIOSPermissions() async {
    try {
      final bool? result = await _localNotifications
          .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin
          >()
          ?.requestPermissions(alert: true, badge: true, sound: true);

      appTalker?.debug('iOS notification permissions granted: $result');
    } catch (e) {
      appTalker?.error('Error requesting iOS permissions: $e');
    }
  }

  @override
  Stream<RemoteMessage> get onMessageReceived => FirebaseMessaging.onMessage;

  @override
  Stream<RemoteMessage> get onMessageOpenedApp =>
      FirebaseMessaging.onMessageOpenedApp;

  Future<void> _initializeLocalNotifications() async {
    const androidSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );
    const iosSettings = DarwinInitializationSettings(
      requestSoundPermission: false,
      requestBadgePermission: false,
      requestAlertPermission: false,
    );

    const initializationSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _localNotifications.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: _onNotificationTapped,
    );
    if (Platform.isAndroid) {
      await _createNotificationChannels();
    }
  }

  Future<void> _initializeFirebaseMessaging() async {
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    onMessageReceived.listen(_handleForegroundMessage);

    final initialMessage = await _firebaseMessaging.getInitialMessage();
    if (initialMessage != null) {
      _handleMessageTap(initialMessage);
    }

    onMessageOpenedApp.listen(_handleMessageTap);
  }

  Future<void> _createNotificationChannels() async {
    final androidImplementation =
        _localNotifications
            .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin
            >();
    const expenseChannel = AndroidNotificationChannel(
      'expense_reminders',
      'Expense Reminders',
      description: 'Notifications about expense tracking reminders',
      importance: Importance.high,
      playSound: true,
    );

    const dailyChannel = AndroidNotificationChannel(
      'daily_reminders',
      'Daily Expense Reminders',
      description: 'Daily reminders to add expenses',
      importance: Importance.high,
      playSound: true,
    );

    const oneTimeChannel = AndroidNotificationChannel(
      'one_time_reminders',
      'One-time Reminders',
      description: 'Custom scheduled reminders',
      importance: Importance.high,
      playSound: true,
    );

    await androidImplementation?.createNotificationChannel(expenseChannel);
    await androidImplementation?.createNotificationChannel(dailyChannel);
    await androidImplementation?.createNotificationChannel(oneTimeChannel);
  }

  Future<void> _handleForegroundMessage(RemoteMessage message) async {
    appTalker?.debug(
      'Received foreground message: ${message.notification?.title}',
    );
    await _showLocalNotification(message);
  }

  Future<void> _showLocalNotification(RemoteMessage message) async {
    const androidDetails = AndroidNotificationDetails(
      'expense_reminders',
      'Expense Reminders',
      channelDescription: 'Notifications about expense tracking reminders',
      importance: Importance.high,
      priority: Priority.high,
      icon: '@mipmap/ic_launcher',
      color: Color(0xFF6366F1),
    );

    const details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _localNotifications.show(
      message.hashCode,
      message.notification?.title ?? 'Expense Tracker',
      message.notification?.body ?? 'Don\'t forget to track your expenses!',
      details,
      payload: message.data['action'],
    );
  }

  void _onNotificationTapped(NotificationResponse response) {
    appTalker?.debug('Notification tapped with payload: ${response.payload}');
    if (response.payload != null) {
      _handleNotificationAction(response.payload!);
    }
  }

  void _handleMessageTap(RemoteMessage message) {
    appTalker?.debug(
      'App opened from notification: ${message.notification?.title}',
    );
    final action = message.data['action'];
    if (action != null) {
      _handleNotificationAction(action);
    }
  }

  void _handleNotificationAction(String action) {
    appTalker?.debug('Handling notification action: $action');
    switch (action) {
      case 'add_expense':
        NotificationActionHandler.navigateToAddExpense();
        break;
      case 'view_expenses':
        NotificationActionHandler.navigateToExpenses();
        break;
      case 'view_charts':
        NotificationActionHandler.navigateToCharts();
        break;
      default:
        NotificationActionHandler.navigateToHome();
    }
  }

  @override
  Future<void> scheduleDailyExpenseReminder({
    required int hour,
    required int minute,
  }) async {
    try {
      await cancelDailyExpenseReminder();

      const androidDetails = AndroidNotificationDetails(
        'daily_reminders',
        'Daily Expense Reminders',
        channelDescription: 'Daily reminders to add expenses',
        importance: Importance.high,
        priority: Priority.high,
        icon: '@mipmap/ic_launcher',
        color: Color(0xFF6366F1),
      );

      const details = NotificationDetails(
        android: androidDetails,
        iOS: iosDetails,
      );

      var scheduledDate = _nextInstanceOfTime(hour, minute);

      await _localNotifications.zonedSchedule(
        _dailyReminderNotificationId,
        'Don\'t forget!',
        'Add your expenses for today to stay on track with your budget',
        scheduledDate,
        details,
        payload: 'add_expense',
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        matchDateTimeComponents: DateTimeComponents.time,
      );

      appTalker?.debug(
        'Daily expense reminder scheduled for ${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}',
      );
    } catch (e) {
      appTalker?.error('Error scheduling daily reminder: $e');
    }
  }

  @override
  Future<void> cancelDailyExpenseReminder() async {
    try {
      await _localNotifications.cancel(_dailyReminderNotificationId);
      appTalker?.debug('Daily expense reminder cancelled');
    } catch (e) {
      appTalker?.error('Error cancelling daily reminder: $e');
    }
  }

  @override
  Future<void> scheduleOneTimeReminder({
    required DateTime dateTime,
    required String title,
    required String body,
  }) async {
    try {
      final String timeZoneName = await FlutterTimezone.getLocalTimezone();
      tz.setLocalLocation(tz.getLocation(timeZoneName));

      const androidDetails = AndroidNotificationDetails(
        'one_time_reminders',
        'One-time Reminders',
        channelDescription: 'Custom scheduled reminders',
        importance: Importance.high,
        priority: Priority.high,
        icon: '@mipmap/ic_launcher',
        color: Color(0xFF6366F1),
      );

      const details = NotificationDetails(
        android: androidDetails,
        iOS: iosDetails,
      );

      final scheduledDate = tz.TZDateTime.from(dateTime, tz.local);
      final notificationId = dateTime.millisecondsSinceEpoch ~/ 1000;

      await _localNotifications.zonedSchedule(
        notificationId,
        title,
        body,
        scheduledDate,
        details,
        payload: 'add_expense',
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      );
      appTalker?.debug('Scheduled TZDateTime: $scheduledDate');
    } catch (e) {
      appTalker?.error('Error scheduling one-time reminder: $e');
    }
  }

  @override
  Future<void> cancelAllScheduledNotifications() async {
    try {
      await _localNotifications.cancelAll();
      appTalker?.debug('All scheduled notifications cancelled');
    } catch (e) {
      appTalker?.error('Error cancelling all notifications: $e');
    }
  }

  tz.TZDateTime _nextInstanceOfTime(int hour, int minute) {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduledDate = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      hour,
      minute,
    );

    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }

    return scheduledDate;
  }
}

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  if (kDebugMode) {
    print('Received background message: ${message.notification?.title}');
  }
}
