// Created by Sultonbek Tulanov on 31-August 2025
import 'package:finance_tracker/core/util/usecase.dart';
import 'package:result_dart/result_dart.dart';

import '../../../../core/util/no_params.dart';
import '../../../auth/domain/usecase/get_current_user_usecase.dart';
import '../repository/expense_repository.dart';

class DeleteExpenseUseCase
    implements FutureUseCase<ResultDart<bool, String>, DeleteExpenseParams> {
  final ExpenseRepository _repository;
  final GetCurrentUserUseCase _getCurrentUserUseCase;

  DeleteExpenseUseCase(this._repository, this._getCurrentUserUseCase);

  @override
  Future<ResultDart<bool, String>> call(DeleteExpenseParams params) async {
    try {
      if (params.expenseId.isEmpty) {
        return const Failure('Expense ID is required');
      }

      final currentUser = _getCurrentUserUseCase(Nothing());
      if (currentUser == null) return Failure('User not authenticated');

      // Verify the expense belongs to the current user before deletion
      // You can skip this if you want faster deletion without extra query
      final expenses = await _repository.getExpenses(currentUser.id);
      final expenseToDelete =
          expenses.where((e) => e.id == params.expenseId).firstOrNull;

      if (expenseToDelete == null) {
        return const Failure('Expense not found');
      }

      if (expenseToDelete.userId != currentUser.id) {
        return const Failure('Unauthorized to delete this expense');
      }

      await _repository.deleteExpense(params.expenseId);
      return const Success(true);
    } catch (e) {
      return Failure('Failed to delete expense: $e');
    }
  }
}

class DeleteExpenseParams {
  final String expenseId;

  DeleteExpenseParams(this.expenseId);
}
