// Created by Sultonbek Tulanov on 03-September 2025
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'app_router.dart';

class NotificationActionHandler {
  // Check if app was launched from notification
  static Future<String?> checkNotificationLaunchDetails() async {
    final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();

    final NotificationAppLaunchDetails? notificationAppLaunchDetails =
        await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();

    if (notificationAppLaunchDetails?.didNotificationLaunchApp == true) {
      return notificationAppLaunchDetails?.notificationResponse?.payload;
    }
    return null;
  }

  // Handle pending navigation after splash
  static void handlePendingNavigation(String? payload) {

      Future.delayed(const Duration(milliseconds: 100), () {
        switch (payload) {
          case 'add_expense':
            _navigateToAddExpense();
            break;
          case 'view_expenses':
            _navigateToExpenses();
            break;
          case 'view_charts':
            _navigateToCharts();
            break;

        }
      });
  }

  static void _navigateToAddExpense() {
    AppRouter.router.push('/add-expense');
  }

  static void _navigateToExpenses() {
    AppRouter.router.push('/home/expenses');
  }

  static void _navigateToCharts() {
    AppRouter.router.push('/home/charts');
  }

}