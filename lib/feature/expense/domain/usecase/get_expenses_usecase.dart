// Created by Sultonbek Tulanov on 31-August 2025
import 'package:finance_tracker/core/util/usecase.dart';
import 'package:result_dart/result_dart.dart';

import '../../../../core/util/no_params.dart';
import '../../../auth/domain/usecase/get_current_user_usecase.dart';
import '../../data/model/expense_model.dart';
import '../repository/expense_repository.dart';

class GetExpensesUseCase
    implements FutureUseCase<ResultDart<List<ExpenseModel>, String>, Nothing> {
  final ExpenseRepository repository;
  final GetCurrentUserUseCase getCurrentUserUseCase;

  GetExpensesUseCase(this.repository, this.getCurrentUserUseCase);

  @override
  Future<ResultDart<List<ExpenseModel>, String>> call(Nothing params) async {
    final currentUser = getCurrentUserUseCase(Nothing());
    if (currentUser == null) return Failure('User not authenticated');
    final expenses = await repository.getExpenses(currentUser.id);
    return Success(expenses);
  }
}
