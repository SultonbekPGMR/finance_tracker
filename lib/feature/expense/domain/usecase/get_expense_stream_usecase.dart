// Created by Sultonbek Tulanov on 31-August 2025
import 'package:finance_tracker/core/config/talker.dart';
import 'package:finance_tracker/core/util/usecase.dart';

import '../../../../core/util/no_params.dart';
import '../../../auth/domain/usecase/get_current_user_usecase.dart';
import '../../data/model/expense_model.dart';
import '../repository/expense_repository.dart';

class GetExpensesStreamUseCase implements StreamUseCase<List<ExpenseModel>, GetExpensesParams> {
  final ExpenseRepository _repository;
  final GetCurrentUserUseCase _getCurrentUserUseCase;

  GetExpensesStreamUseCase(this._repository, this._getCurrentUserUseCase);

  @override
  Stream<List<ExpenseModel>> call(GetExpensesParams params) {
    final currentUser = _getCurrentUserUseCase(Nothing());
    if (currentUser == null) return Stream.error('User not authenticated');

    appTalker?.debug('Getting expenses for month: ${params.month}');
    return _repository
        .getExpensesStream(currentUser.id, month: params.month)
        .map((expenses) => _filterExpenses(expenses, params.query));
  }

  List<ExpenseModel> _filterExpenses(List<ExpenseModel> expenses, String? query) {
    if (query == null || query.trim().isEmpty) {
      return expenses;
    }

    final searchQuery = query.trim().toLowerCase();
    return expenses.where((expense) {
      return expense.description.toLowerCase().contains(searchQuery) ||expense.amount.toString().contains(searchQuery) ||
          expense.category.toLowerCase().contains(searchQuery);
    }).toList();
  }
}

class GetExpensesParams {
  final DateTime month;
  final String? query;

  GetExpensesParams({required this.month, this.query});
}