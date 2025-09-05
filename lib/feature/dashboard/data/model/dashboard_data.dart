// Created by Sultonbek Tulanov on 05-September 2025

import 'package:finance_tracker/feature/expense/data/model/expense_category_model.dart';

class DashboardData {
  final MonthlyOverview monthlyOverview;
  final QuickStats quickStats;
  final List<RecentExpense> recentExpenses;
  final List<TopCategory> topCategories;
  final UserInfo userInfo;

  const DashboardData({
    required this.monthlyOverview,
    required this.quickStats,
    required this.recentExpenses,
    required this.topCategories,
    required this.userInfo,
  });
}

class UserInfo {
  final String displayName;
  final String email;
  final String? profileImageUrl;

  const UserInfo({
    required this.displayName,
    required this.email,
    this.profileImageUrl,
  });
}

class MonthlyOverview {
  final double totalSpent;
  final int daysRemaining;
  final DateTime month;

  const MonthlyOverview({
    required this.totalSpent,
    required this.daysRemaining,
    required this.month,
  });
}

class QuickStats {
  final double todayAmount;
  final int todayTransactions;
  final double weekAmount;
  final int weekTransactions;
  final double dailyAverage;

  const QuickStats({
    required this.todayAmount,
    required this.todayTransactions,
    required this.weekAmount,
    required this.weekTransactions,
    required this.dailyAverage,
  });
}

class RecentExpense {
  final String id;
  final String description;
  final double amount;
  final String categoryIcon;
  final DateTime createdAt;

  const RecentExpense({
    required this.id,
    required this.description,
    required this.amount,
    required this.categoryIcon,
    required this.createdAt,
  });
}

class TopCategory {
  final ExpenseCategoryModel categoryModel;
  final double amount;
  final int percentage;
  final int transactionCount;

  const TopCategory({
    required this.categoryModel,
    required this.amount,
    required this.percentage,
    required this.transactionCount,
  });
}