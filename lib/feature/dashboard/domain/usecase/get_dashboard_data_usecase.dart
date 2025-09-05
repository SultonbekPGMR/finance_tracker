// Created by Sultonbek Tulanov on 05-September 2025
import 'package:collection/collection.dart';
import 'package:finance_tracker/core/util/no_params.dart';
import 'package:finance_tracker/core/util/usecase.dart';
import 'package:finance_tracker/feature/dashboard/data/model/dashboard_data.dart';

import '../../../auth/domain/usecase/get_current_user_usecase.dart';
import '../../../expense/data/model/expense_category_model.dart';
import '../../../expense/domain/repository/expense_repository.dart';

class GetDashboardDataUseCase implements StreamUseCase<DashboardData, Nothing> {
  final ExpenseRepository _repository;
  final GetCurrentUserUseCase _getCurrentUserUseCase;
  final now = DateTime.now();

  GetDashboardDataUseCase(this._repository, this._getCurrentUserUseCase);

  @override
  Stream<DashboardData> call(Nothing params) async* {
    final currentUser = _getCurrentUserUseCase(Nothing());
    if (currentUser == null) {
      throw Exception('User not authenticated');
    }

    await for (final expenses in _repository.getExpensesStream(
      currentUser.id,
      month: now,
    )) {
      yield _buildDashboardData(expenses, currentUser.name, currentUser.email);
    }
  }

  DashboardData _buildDashboardData(
    List<dynamic> expenses,
    String userName,
    String userEmail,
  ) {
    final now = DateTime.now();
    final monthlyTotal = _calculateMonthlyTotal(expenses);

    return DashboardData(
      userInfo: _buildUserInfo(userName, userEmail),
      monthlyOverview: _buildMonthlyOverview(monthlyTotal, now),
      quickStats: _buildQuickStats(expenses, monthlyTotal, now),
      recentExpenses: _buildRecentExpenses(expenses),
      topCategories: _buildTopCategories(expenses, monthlyTotal),
    );
  }

  UserInfo _buildUserInfo(String userName, String userEmail) {
    return UserInfo(
      displayName: userName.isEmpty ? 'User' : userName,
      email: userEmail,
      profileImageUrl: null,
    );
  }

  MonthlyOverview _buildMonthlyOverview(double monthlyTotal, DateTime now) {
    final daysInMonth = DateTime(now.year, now.month + 1, 0).day;
    final daysRemaining = daysInMonth - now.day;

    return MonthlyOverview(
      totalSpent: monthlyTotal,
      daysRemaining: daysRemaining,
      month: now,
    );
  }

  QuickStats _buildQuickStats(
    List<dynamic> expenses,
    double monthlyTotal,
    DateTime now,
  ) {
    final today = DateTime(now.year, now.month, now.day);
    final weekStart = today.subtract(Duration(days: today.weekday - 1));

    final todayExpenses = _filterExpensesByDay(expenses, today);
    final weekExpenses = _filterExpensesByDateRange(expenses, weekStart, now);

    final dailyAverage = now.day > 0 ? monthlyTotal / now.day : 0.0;

    return QuickStats(
      todayAmount: _calculateTotal(todayExpenses),
      todayTransactions: todayExpenses.length,
      weekAmount: _calculateTotal(weekExpenses),
      weekTransactions: weekExpenses.length,
      dailyAverage: dailyAverage,
    );
  }

  List<RecentExpense> _buildRecentExpenses(List<dynamic> expenses) {
    final sortedExpenses = List.from(expenses)
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));

    return sortedExpenses.take(4).map((expense) {
      return RecentExpense(
        id: expense.id,
        description: expense.description,
        amount: expense.amount,
        categoryIcon: ExpenseCategoryModel.fromName(expense.category).icon,
        createdAt: expense.createdAt,
      );
    }).toList();
  }

  List<TopCategory> _buildTopCategories(
    List<dynamic> expenses,
    double monthlyTotal,
  ) {
    final categoryGroups = groupBy(expenses, (expense) => expense.category);
    final categories = <TopCategory>[];

    categoryGroups.forEach((categoryName, categoryExpenses) {
      final categoryModel = ExpenseCategoryModel.fromName(categoryName);
      final totalAmount = _calculateTotal(categoryExpenses);
      final percentage =
          monthlyTotal > 0 ? ((totalAmount / monthlyTotal) * 100).round() : 0;

      categories.add(
        TopCategory(
          categoryModel: categoryModel,
          amount: totalAmount,
          percentage: percentage,
          transactionCount: categoryExpenses.length,
        ),
      );
    });

    categories.sort((a, b) => b.amount.compareTo(a.amount));
    return categories.take(4).toList();
  }

  // Helper methods
  double _calculateMonthlyTotal(List<dynamic> expenses) {
    return expenses.fold<double>(0, (sum, expense) => sum + expense.amount);
  }

  double _calculateTotal(List<dynamic> expenses) {
    return expenses.fold<double>(0, (sum, expense) => sum + expense.amount);
  }

  List<dynamic> _filterExpensesByDay(List<dynamic> expenses, DateTime day) {
    return expenses.where((expense) {
      final expenseDate = DateTime(
        expense.createdAt.year,
        expense.createdAt.month,
        expense.createdAt.day,
      );
      return expenseDate == day;
    }).toList();
  }

  List<dynamic> _filterExpensesByDateRange(
    List<dynamic> expenses,
    DateTime start,
    DateTime end,
  ) {
    return expenses.where((expense) {
      return expense.createdAt.isAfter(start) &&
          expense.createdAt.isBefore(end.add(Duration(days: 1)));
    }).toList();
  }


}
