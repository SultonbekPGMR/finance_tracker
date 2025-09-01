import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/util/no_params.dart';
import '../../../data/model/expense_category_model.dart';
import '../../../data/model/expense_model.dart';
import '../../../domain/usecase/add_expense_usecase.dart';
import '../../../domain/usecase/get_categories_usecase.dart';
import '../../../domain/usecase/update_expense_usecase.dart';

part 'expense_details_state.dart';

class ExpenseDetailsCubit extends Cubit<ExpenseDetailsState> {
  final AddExpenseUseCase _addExpenseUseCase;
  final UpdateExpenseUseCase _updateExpenseUseCase;
  final GetCategoriesUseCase _getCategoriesUseCase;

  ExpenseDetailsCubit(
    this._addExpenseUseCase,
    this._getCategoriesUseCase,
    this._updateExpenseUseCase,
  ) : super(ExpenseDetailsLoading());

  void loadCategories() {
    emit(ExpenseDetailsLoading());

    final result = _getCategoriesUseCase(Nothing());
    result.fold(
      (categories) => emit(ExpenseDetailsLoaded(categories: categories)),
      (error) => emit(ExpenseDetailsError('Failed to load categories: $error')),
    );
  }

  void updateExpense({
    required ExpenseModel expense,
    required double amount,
    required ExpenseCategoryModel category,
    required String description,
    String? imageUrl,
  }) async {
    final currentState = state;
    if (currentState is! ExpenseDetailsLoaded) return;

    emit(ExpenseDetailsSubmitting(categories: currentState.categories));

    try {
      final result = await _updateExpenseUseCase(
        UpdateExpenseParams(
          expense: expense,
          amount: amount,
          category: category,
          description: description,
          imageUrl: imageUrl,
        ),
      );

      result.fold(
            (success) => emit(
          ExpenseDetailsUpdatedSuccessfully(),
        ),
            (error) => emit(
          ExpenseDetailsSubmissionError(
            categories: currentState.categories,
            error: error,
          ),
        ),
      );
    } catch (e) {
      emit(
        ExpenseDetailsSubmissionError(
          categories: currentState.categories,
          error: 'Failed to update expense: $e',
        ),
      );
    }
  }


  Future<void> addExpense({
    required double amount,
    required ExpenseCategoryModel category,
    required String description,
    String? imageUrl,
  }) async {
    final currentState = state;
    if (currentState is! ExpenseDetailsLoaded) return;

    emit(ExpenseDetailsSubmitting(categories: currentState.categories));

    try {
      final result = await _addExpenseUseCase(
        AddExpenseParams(
          amount: amount,
          category: category,
          description: description,
          imageUrl: imageUrl,
        ),
      );

      result.fold(
        (success) => emit(
          ExpenseDetailsAddedSuccessfully(),
        ),
        (error) => emit(
          ExpenseDetailsSubmissionError(
            categories: currentState.categories,
            error: error,
          ),
        ),
      );
    } catch (e) {
      emit(
        ExpenseDetailsSubmissionError(
          categories: currentState.categories,
          error: 'Failed to add expense: $e',
        ),
      );
    }
  }
}
