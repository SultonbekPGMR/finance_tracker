// Created by Sultonbek Tulanov on 31-August 2025
import 'package:finance_tracker/core/util/usecase.dart';
import 'package:result_dart/result_dart.dart';

import '../../../../core/util/no_params.dart';
import '../../../auth/domain/usecase/get_current_user_usecase.dart';
import '../../data/model/expense_category_model.dart';
import '../../data/model/expense_model.dart';
import '../repository/expense_repository.dart';

class UpdateExpenseUseCase
    implements FutureUseCase<ResultDart<bool, String>, UpdateExpenseParams> {
  final ExpenseRepository repository;
  final GetCurrentUserUseCase getCurrentUserUseCase;

  UpdateExpenseUseCase(this.repository, this.getCurrentUserUseCase);

  @override
  Future<ResultDart<bool, String>> call(UpdateExpenseParams params) async {
    try {
      final validationError = _validateParams(params);
      if (validationError != null) return Failure(validationError);

      final currentUser = getCurrentUserUseCase(Nothing());
      if (currentUser == null) return Failure('User not authenticated');

      // Verify the expense belongs to the current user
      if (params.expense.userId != currentUser.id) {
        return Failure('Unauthorized to update this expense');
      }

      final updatedExpense = params.expense.copyWith(
        amount: params.amount,
        category: params.category.name,
        description: params.description,
        imageUrl: params.imageUrl,
        updatedAt: DateTime.now(),
      );

      await repository.updateExpense(updatedExpense);
      return const Success(true);
    } catch (e) {
      return Failure('Failed to update expense: $e');
    }
  }

  String? _validateParams(UpdateExpenseParams params) {
    if (params.expense.id.isEmpty) return 'Expense ID is required';
    if (params.amount <= 0) return 'Amount must be greater than 0';
    if (params.description.trim().isEmpty) return 'Description is required';
    return null;
  }


}
class UpdateExpenseParams {
  final ExpenseModel expense;
  final double amount;
  final ExpenseCategoryModel category;
  final String description;
  final String? imageUrl;

  UpdateExpenseParams({
    required this.expense,
    required this.amount,
    required this.category,
    required this.description,
    this.imageUrl,
  });
}
 
