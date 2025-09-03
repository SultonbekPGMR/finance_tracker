// Created by Sultonbek Tulanov on 03-September 2025
import 'package:firebase_messaging/firebase_messaging.dart';

enum PermissionResult {
  granted,
  denied,
  permanentlyDenied,
  error,
}

abstract class NotificationService {
  Future<void> initialize();

  Future<String?> getToken();

  Future<PermissionResult> requestPermission(bool autoOpenSettings);

  Future<bool> areNotificationsEnabled();

  Future<bool> canScheduleExactAlarms();

  Future<void> openNotificationSettings();

  Future<void> openExactAlarmSettings();

  Stream<RemoteMessage> get onMessageReceived;

  Stream<RemoteMessage> get onMessageOpenedApp;

  Future<void> scheduleDailyExpenseReminder({
    required int hour,
    required int minute,
  });

  Future<void> cancelDailyExpenseReminder();

  Future<void> scheduleOneTimeReminder({
    required DateTime dateTime,
    required String title,
    required String body,
  });

  Future<void> cancelAllScheduledNotifications();
}

 
