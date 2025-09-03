// Created by Sultonbek Tulanov on 31-August 2025
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

    return _repository.getExpensesStream(currentUser.id,month: params.month);
  }
}

class GetExpensesParams{
  final DateTime month;

  GetExpensesParams({required this.month});
}
