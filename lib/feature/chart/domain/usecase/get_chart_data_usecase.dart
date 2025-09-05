// Created by Sultonbek Tulanov on 02-September 2025

import 'package:collection/collection.dart';
import 'package:finance_tracker/core/config/talker.dart';
import 'package:finance_tracker/core/util/exception/localized_exception.dart';
import 'package:finance_tracker/feature/chart/data/model/category_expense_data.dart';
import 'package:finance_tracker/feature/expense/data/model/expense_category_model.dart';
import 'package:result_dart/result_dart.dart';

import '../../../../core/util/no_params.dart';
import '../../../../core/util/usecase.dart';
import '../../../auth/domain/usecase/get_current_user_usecase.dart';
import '../../../expense/domain/repository/expense_repository.dart';

class GetChartDataUseCase
    implements
        StreamUseCase<Result<List<CategoryExpenseData>>, GetChartDataParams> {
  final ExpenseRepository repository;
  final GetCurrentUserUseCase getCurrentUserUseCase;

  // Threshold for grouping small percentages into "Other" category
  static const double _smallPercentageThreshold =
      2.0; // Categories below 2% go to "Other"

  GetChartDataUseCase(this.repository, this.getCurrentUserUseCase);

  @override
  Stream<Result<List<CategoryExpenseData>>> call(GetChartDataParams params) {
    final currentUser = getCurrentUserUseCase(Nothing());
    if (currentUser == null) {
      return Stream.value(Failure(UserNotFoundException()));
    }

    return repository
        .getExpensesStream(currentUser.id, month: params.month)
        .map((expenses) => _processExpenses(expenses))
        .handleError((error) {
          appTalker?.error('Error in GetChartDataUseCase: $error');
          return Failure(Exception('Failed to load chart data'));
        });
  }

  Result<List<CategoryExpenseData>> _processExpenses(List<dynamic> expenses) {
    try {
      if (expenses.isEmpty) return Success([]);

      final List<CategoryExpenseData> initialResult = [];
      final grouped = groupBy(expenses, (expense) => expense.category);

      // Calculate total amount for percentage calculation
      final totalExpenseAmount = expenses.fold<double>(
        0,
        (sum, expense) => sum + expense.amount,
      );

      // Process each category
      grouped.forEach((category, items) {
        appTalker?.debug(
          'Processing category: $category with ${items.length} items',
        );
        final totalAmount = items.fold<double>(
          0,
          (previousValue, element) => previousValue + element.amount,
        );

        initialResult.add(
          CategoryExpenseData(
            category: ExpenseCategoryModel.fromName(category),
            totalAmount: totalAmount,
            transactionCount: items.length,
          ),
        );
      });

      // Group small percentages into "Other" category
      // final processedResult = _groupSmallCategories(initialResult, totalExpenseAmount); // Uncomment this line if you want to group small percentages


      initialResult.sort(
            (a, b) => b.totalAmount.compareTo(a.totalAmount),
      );

      final processedResult = initialResult;

      appTalker?.debug(
        'Final chart data: ${processedResult.length} categories',
      );
      return Success(processedResult);
    } catch (error) {
      appTalker?.error('Error processing expenses: $error');
      return Failure(Exception('Failed to process expense data'));
    }
  }

  List<CategoryExpenseData> _groupSmallCategories(
    List<CategoryExpenseData> categories,
    double totalAmount,
  ) {
    if (totalAmount == 0) return categories;

    final List<CategoryExpenseData> significantCategories = [];
    final List<CategoryExpenseData> smallCategories = [];

    // Separate categories based on percentage threshold
    for (final category in categories) {
      final percentage = (category.totalAmount / totalAmount) * 100;

      if (percentage >= _smallPercentageThreshold) {
        significantCategories.add(category);
      } else {
        smallCategories.add(category);
        appTalker?.debug(
          'Small category: ${category.category.name} - ${percentage.toStringAsFixed(1)}%',
        );
      }
    }

    // If there are small categories, group them into "Other"
    if (smallCategories.isNotEmpty) {
      final otherTotalAmount = smallCategories.fold<double>(
        0,
        (sum, category) => sum + category.totalAmount,
      );

      final otherTransactionCount = smallCategories.fold<int>(
        0,
        (sum, category) => sum + category.transactionCount,
      );

      final otherCategory = CategoryExpenseData(
        category: ExpenseCategoryModel.fromName('Other'),
        totalAmount: otherTotalAmount,
        transactionCount: otherTransactionCount,
      );

      significantCategories.add(otherCategory);

      appTalker?.debug(
        'Created Other category with ${smallCategories.length} merged categories: '
        '${(otherTotalAmount / totalAmount * 100).toStringAsFixed(1)}%',
      );
    }

    // Sort by amount descending for better chart appearance
    significantCategories.sort(
      (a, b) => b.totalAmount.compareTo(a.totalAmount),
    );

    return significantCategories;
  }
}

class GetChartDataParams {
  final DateTime month;

  GetChartDataParams({required this.month});
}
