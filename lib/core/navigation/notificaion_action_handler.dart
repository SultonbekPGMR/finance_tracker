// Created by Sultonbek Tulanov on 03-September 2025
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'app_router.dart';

class NotificationActionHandler {
  static String? _notificationPayload;

  static void navigateToAddExpense() {
    AppRouter.router.push('/add-expense');
  }

  static void navigateToExpenses() {
    AppRouter.router.push('/home/expenses');
  }

  static void navigateToCharts() {
    AppRouter.router.push('/home/charts');
  }

  static void navigateToHome() {
    AppRouter.router.go('/');
  }

  // Check if app was launched from notification
  static Future<void> checkNotificationLaunchDetails() async {
    final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();

    final NotificationAppLaunchDetails? notificationAppLaunchDetails =
        await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();

    if (notificationAppLaunchDetails?.didNotificationLaunchApp == true) {
      _notificationPayload = notificationAppLaunchDetails!.notificationResponse?.payload;
    }
  }

  // Handle pending navigation after splash
  static void handlePendingNavigation() {
    if (_notificationPayload != null) {
      final payload = _notificationPayload!;
      _notificationPayload = null; // Clear after use

      // Small delay to ensure shell navigation is ready
      Future.delayed(const Duration(milliseconds: 100), () {
        switch (payload) {
          case 'add_expense':
            AppRouter.router.push('/add-expense');
            break;
          case 'view_expenses':
            AppRouter.router.push('/home/expenses');
            break;
          case 'view_charts':
            AppRouter.router.push('/home/charts');
            break;
          default:
            break;
        }
      });
    }
  }

  static bool get hasNotificationPayload => _notificationPayload != null;
}