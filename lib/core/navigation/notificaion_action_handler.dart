// Created by Sultonbek Tulanov on 03-September 2025
import 'package:flutter/material.dart';
import 'app_router.dart';

class NotificationActionHandler {

  static void navigateToAddExpense() {
    AppRouter.router.push('/add-expense');
  }

  static void navigateToExpenses() {
    AppRouter.router.push('/expenses');
  }

  static void navigateToCharts() {
    AppRouter.router.push('/charts');
  }

  static void navigateToHome() {
    AppRouter.router.go('/');
  }
}