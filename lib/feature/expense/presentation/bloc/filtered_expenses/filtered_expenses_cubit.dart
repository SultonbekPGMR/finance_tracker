import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/model/expense_category_model.dart';
import '../../../data/model/expense_model.dart';
import '../../../domain/usecase/get_expenses_by_filter_usecase.dart';

part 'filtered_expenses_state.dart';

class FilteredExpensesCubit extends Cubit<FilteredExpensesState> {
  final GetExpensesByFilterUseCase _getExpensesByFilterUseCase;
  StreamSubscription? _expensesSubscription;

  FilteredExpensesCubit(this._getExpensesByFilterUseCase)
    : super(FilteredExpensesInitial());

  void loadExpenses(DateTime month, ExpenseCategoryModel category) {
    _expensesSubscription?.cancel();

    emit(FilteredExpensesLoading());

    try {
      final params = GetExpensesByFilterParams(
        month: month,
        categories: [category],
      );

      final expensesStream = _getExpensesByFilterUseCase(params);

      _expensesSubscription = expensesStream.listen(
        (result) {
          if (!isClosed) {
            if (result.isSuccess()) {
              emit(FilteredExpensesLoaded(result.getOrNull()!));
            } else {
              emit(FilteredExpensesError(result.exceptionOrNull()!));
            }
          }
        },
        onError: (error) {
          if (!isClosed) {
            emit(FilteredExpensesError(Exception(error.toString())));
          }
        },
      );
    } catch (e) {
      emit(FilteredExpensesError(Exception(e.toString())));
    }
  }

  @override
  Future<void> close() {
    _expensesSubscription?.cancel();
    return super.close();
  }
}
