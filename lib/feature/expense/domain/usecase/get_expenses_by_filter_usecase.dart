// Created by Sultonbek Tulanov on 03-September 2025
import 'package:finance_tracker/core/util/usecase.dart';
import 'package:finance_tracker/feature/expense/data/model/expense_category_model.dart';
import 'package:finance_tracker/feature/expense/data/model/expense_model.dart';
import 'package:result_dart/result_dart.dart';

import '../../../../core/config/talker.dart';
import '../../../../core/util/exception/localized_exception.dart';
import '../../../../core/util/no_params.dart';
import '../../../auth/domain/usecase/get_current_user_usecase.dart';
import '../repository/expense_repository.dart';

class GetExpensesByFilterUseCase
    implements
        StreamUseCase<Result<List<ExpenseModel>>, GetExpensesByFilterParams> {
  final ExpenseRepository _repository;
  final GetCurrentUserUseCase _getCurrentUserUseCase;

  GetExpensesByFilterUseCase(this._repository, this._getCurrentUserUseCase);

  @override
  Stream<Result<List<ExpenseModel>>> call(GetExpensesByFilterParams params) {
    final currentUser = _getCurrentUserUseCase(Nothing());
    if (currentUser == null) {
      return Stream.value(Failure(UserNotFoundException()));
    }

    return _repository
        .getExpensesStream(currentUser.id, month: params.month)
        .map((expenses) => _processExpenses(expenses, params))
        .handleError((error) {
          appTalker?.error('Error in GetExpensesByFilterUseCase: $error');
          return Failure(Exception('Failed to load filtered expenses'));
        });
  }

  Result<List<ExpenseModel>> _processExpenses(
    List<ExpenseModel> expenses,
    GetExpensesByFilterParams params,
  ) {
    try {
      if (params.categories.isEmpty) {
        return Success(expenses);
      }
      final categoryNames =
          params.categories.map((category) => category.name).toSet();

      final filteredExpenses =
          expenses.where((expense) {
            return categoryNames.contains(expense.category);
          }).toList();

      filteredExpenses.sort((a, b) => b.createdAt.compareTo(a.createdAt));

      appTalker?.debug(
        'Filtered ${expenses.length} expenses to ${filteredExpenses.length} based on ${params.categories.length} categories',
      );

      return Success(filteredExpenses);
    } catch (error) {
      appTalker?.error('Error processing expenses: $error');
      return Failure(Exception('Failed to process expense data'));
    }
  }
}

class GetExpensesByFilterParams {
  final DateTime month;
  final List<ExpenseCategoryModel> categories;

  GetExpensesByFilterParams({required this.month, required this.categories});

  bool get hasActiveFilters => categories.isNotEmpty;

  @override
  String toString() {
    return 'GetExpensesByFilterParams(month: $month, categories: ${categories.map((c) => c.name).join(', ')})';
  }
}
