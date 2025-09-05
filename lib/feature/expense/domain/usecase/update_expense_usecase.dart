// Created by Sultonbek Tulanov on 31-August 2025
import 'package:finance_tracker/core/util/usecase.dart';
import 'package:result_dart/result_dart.dart';

import '../../../../core/util/exception/localized_exception.dart';
import '../../../../core/util/no_params.dart';
import '../../../auth/domain/usecase/get_current_user_usecase.dart';
import '../../data/model/expense_category_model.dart';
import '../../data/model/expense_model.dart';
import '../repository/expense_repository.dart';

class UpdateExpenseUseCase
    implements FutureUseCase<Result<bool>, UpdateExpenseParams> {
  final ExpenseRepository _repository;
  final GetCurrentUserUseCase _getCurrentUserUseCase;

  UpdateExpenseUseCase(this._repository, this._getCurrentUserUseCase);

  @override
  Future<Result<bool>> call(UpdateExpenseParams params) async {
    try {

      final currentUser = _getCurrentUserUseCase(Nothing());
      if (currentUser == null) return Failure(UserNotAuthenticatedException());

      // Verify the expense belongs to the current user
      if (params.expense.userId != currentUser.id) {
        return Failure(UnauthorizedToUpdateExpenseException());
      }

      final updatedExpense = params.expense.copyWith(
        amount: params.amount,
        category: params.category.name,
        description: params.description,
        imageUrl: params.imageUrl,
        createdAt: params.date,
        updatedAt: DateTime.now(),
      );

      await _repository.updateExpense(updatedExpense);
      return const Success(true);
    } on Exception catch (e) {
      return Failure(e);
    }
  }



}
class UpdateExpenseParams {
  final ExpenseModel expense;
  final double amount;
  final ExpenseCategoryModel category;
  final String description;
  final DateTime date;
  final String? imageUrl;

  UpdateExpenseParams({
    required this.expense,
    required this.amount,
    required this.category,
    required this.description,
    required this.date,
    this.imageUrl,
  });
}
 
