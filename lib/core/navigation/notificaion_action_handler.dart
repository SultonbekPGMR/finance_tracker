// Created by Sultonbek Tulanov on 03-September 2025
import 'package:flutter/cupertino.dart';

import 'app_router.dart';

class NotificationActionHandler {
  static final GlobalKey<NavigatorState> navigatorKey = AppRouter.navigatorKey;

  static void navigateToAddExpense() {
    navigatorKey.currentState?.pushNamed('/add-expense');
  }

  static void navigateToExpenses() {
    navigatorKey.currentState?.pushNamed('/expenses');
  }

  static void navigateToCharts() {
    navigatorKey.currentState?.pushNamed('/charts');
  }

  static void navigateToHome() {
    navigatorKey.currentState?.pushNamedAndRemoveUntil('/', (route) => false);
  }
}
 
