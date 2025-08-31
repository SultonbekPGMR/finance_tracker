// Created by Sultonbek Tulanov on 31-August 2025
import 'package:finance_tracker/core/util/usecase.dart';
import 'package:result_dart/result_dart.dart';

import '../../../../core/util/no_params.dart';
import '../../../auth/domain/usecase/get_current_user_usecase.dart';
import '../../data/model/expense_model.dart';
import '../repository/expense_repository.dart';

class GetExpenseByIdUseCase
    implements FutureUseCase<ResultDart<ExpenseModel, String>, GetExpenseByIdParams> {
  final ExpenseRepository repository;
  final GetCurrentUserUseCase getCurrentUserUseCase;

  GetExpenseByIdUseCase(this.repository, this.getCurrentUserUseCase);

  @override
  Future<ResultDart<ExpenseModel, String>> call(GetExpenseByIdParams params) async {
    try {
      if (params.expenseId.isEmpty) {
        return const Failure('Expense ID is required');
      }

      final currentUser = getCurrentUserUseCase(Nothing());
      if (currentUser == null) return Failure('User not authenticated');

      final expenses = await repository.getExpenses(currentUser.id);
      final expense = expenses.where((e) => e.id == params.expenseId).firstOrNull;
      if (expense == null) {
        return const Failure('Expense not found');
      }
      return Success(expense);
    } catch (e) {
      return Failure('Failed to get expense: $e');
    }
  }
}

class GetExpenseByIdParams {
  final String expenseId;

  GetExpenseByIdParams(this.expenseId);
}
 
