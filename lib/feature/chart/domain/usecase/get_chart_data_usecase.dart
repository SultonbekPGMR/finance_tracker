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
        FutureUseCase<Result<List<CategoryExpenseData>>, GetChartDataParams> {
  final ExpenseRepository repository;
  final GetCurrentUserUseCase getCurrentUserUseCase;

  GetChartDataUseCase(this.repository, this.getCurrentUserUseCase);

  @override
  Future<Result<List<CategoryExpenseData>>> call(
    GetChartDataParams params,
  ) async {
    final currentUser = getCurrentUserUseCase(Nothing());
    if (currentUser == null) return Failure(UserNotFoundException());

    final List<CategoryExpenseData> result = [];
    final expenses = await repository.getExpenses(
      currentUser.id,
      month: params.month,
    );
    final grouped = groupBy(expenses, (expense) => expense.category);
    grouped.forEach((category, items) {
      appTalker?.debug('msg $category ${items.length}');
      final totalAmount = items.fold<double>(
        0,
        (previousValue, element) => previousValue + element.amount,
      );
      result.add(
        CategoryExpenseData(
          category: ExpenseCategoryModel.fromString(category),
          totalAmount: totalAmount,
          transactionCount: items.length,
        ),
      );
    });
    appTalker?.debug(result.toString());
    return Success(result);
  }
}

class GetChartDataParams {
  final DateTime month;

  GetChartDataParams({required this.month});
}
