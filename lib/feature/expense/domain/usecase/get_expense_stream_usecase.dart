// Created by Sultonbek Tulanov on 31-August 2025
import 'package:finance_tracker/core/util/usecase.dart';

import '../../../../core/util/no_params.dart';
import '../../../auth/domain/usecase/get_current_user_usecase.dart';
import '../../data/model/expense_model.dart';
import '../repository/expense_repository.dart';

class GetExpensesStreamUseCase implements StreamUseCase<List<ExpenseModel>, GetExpensesParams> {
  final ExpenseRepository repository;
  final GetCurrentUserUseCase getCurrentUserUseCase;

  GetExpensesStreamUseCase(this.repository, this.getCurrentUserUseCase);

  @override
  Stream<List<ExpenseModel>> call(GetExpensesParams params) {
    final currentUser = getCurrentUserUseCase(Nothing());
    if (currentUser == null) return Stream.error('User not authenticated');

    return repository.getExpensesStream(currentUser.id);
  }
}

class GetExpensesParams{
  final DateTime month;

  GetExpensesParams({required this.month});
}
