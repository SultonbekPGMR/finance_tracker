// Created by Sultonbek Tulanov on 31-August 2025
import 'package:finance_tracker/core/util/exception/localized_exception.dart';
import 'package:finance_tracker/core/util/usecase.dart';
import 'package:result_dart/result_dart.dart';

import '../../../../core/util/no_params.dart';
import '../../../auth/domain/usecase/get_current_user_usecase.dart';
import '../repository/expense_repository.dart';

class DeleteExpenseUseCase
    implements FutureUseCase<Result<bool>, DeleteExpenseParams> {
  final ExpenseRepository _repository;
  final GetCurrentUserUseCase _getCurrentUserUseCase;

  DeleteExpenseUseCase(this._repository, this._getCurrentUserUseCase);

  @override
  Future<Result<bool>> call(DeleteExpenseParams params) async {
    try {
      if (params.expenseId.isEmpty) {
        return Failure(InvalidCredentialsException());
      }

      final currentUser = _getCurrentUserUseCase(Nothing());
      if (currentUser == null) return Failure(UserNotFoundException());

      // Verify the expense belongs to the current user before deletion
      // You can skip this if you want faster deletion without extra query
      final expenses = await _repository.getExpenses(currentUser.id);
      final expenseToDelete =
          expenses.where((e) => e.id == params.expenseId).firstOrNull;

      if (expenseToDelete == null) {
        return Failure(ExpenseNotFoundException());
      }

      if (expenseToDelete.userId != currentUser.id) {
        return Failure(InvalidCredentialsException());
      }

      await _repository.deleteExpense(params.expenseId);
      return const Success(true);
    } on Exception catch (e) {
      return Failure(e);
    }
  }
}

class DeleteExpenseParams {
  final String expenseId;

  DeleteExpenseParams(this.expenseId);
}
