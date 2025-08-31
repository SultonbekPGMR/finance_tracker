// Created by Sultonbek Tulanov on 31-August 2025
import 'package:finance_tracker/core/util/usecase.dart';
import 'package:result_dart/result_dart.dart';

import '../../../../core/util/no_params.dart';
import '../../../auth/domain/usecase/get_current_user_usecase.dart';
import '../../data/model/expense_category_model.dart';
import '../../data/model/expense_model.dart';
import '../repository/expense_repository.dart';

class AddExpenseUseCase
    implements FutureUseCase<ResultDart<bool, String>, AddExpenseParams> {
  final ExpenseRepository repository;
  final GetCurrentUserUseCase getCurrentUserUseCase;

  AddExpenseUseCase(this.repository, this.getCurrentUserUseCase);

  @override
  Future<ResultDart<bool, String>> call(AddExpenseParams params) async {
    try {
      final validationError = _validateParams(params);
      if (validationError != null) return Failure(validationError);

      final currentUser = getCurrentUserUseCase(Nothing());
      if (currentUser == null) return Failure('User not authenticated');

      final expense = ExpenseModel.create(
        userId: currentUser.id,
        amount: params.amount,
        category: params.category.name,
        description: params.description,
        imageUrl: params.imageUrl,
      );

      await repository.addExpense(expense);
      return const Success(true);
    } catch (e) {
      return Failure('Failed to add expense: $e');
    }
  }

  String? _validateParams(AddExpenseParams params) {
    if (params.amount <= 0) return 'Amount must be greater than 0';
    if (params.description.trim().isEmpty) return 'Description is required';
    return null;
  }
}

class AddExpenseParams {
  final double amount;
  final ExpenseCategoryModel category;
  final String description;
  final String? imageUrl;

  AddExpenseParams({
    required this.amount,
    required this.category,
    required this.description,
    this.imageUrl,
  });
}
