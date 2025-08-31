import 'dart:async';

import 'package:finance_tracker/core/util/eventbus/global_message_bus.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/util/no_params.dart';
import '../../data/model/expense_category_model.dart';
import '../../data/model/expense_model.dart';
import '../../domain/usecase/add_expense_usecase.dart';
import '../../domain/usecase/delete_expense_usecase.dart';
import '../../domain/usecase/get_categories_usecase.dart';
import '../../domain/usecase/get_expense_stream_usecase.dart';
import '../../domain/usecase/get_expenses_usecase.dart';
import '../../domain/usecase/update_expense_usecase.dart';

part 'expenses_event.dart';
part 'expenses_state.dart';

class ExpensesBloc extends Bloc<ExpensesEvent, ExpensesState> {
  final GetExpensesStreamUseCase getExpensesStreamsUseCase;
  final GetExpensesUseCase getExpensesUseCase;
  final AddExpenseUseCase addExpenseUseCase;
  final UpdateExpenseUseCase updateExpenseUseCase;
  final DeleteExpenseUseCase deleteExpenseUseCase;
  final GetCategoriesUseCase getCategoriesUseCase;

  StreamSubscription<List<ExpenseModel>>? _expensesSubscription;

  ExpensesBloc(
    this.getExpensesUseCase,
    this.addExpenseUseCase,
    this.updateExpenseUseCase,
    this.deleteExpenseUseCase,
    this.getCategoriesUseCase,
    this.getExpensesStreamsUseCase,
  ) : super(ExpensesInitial()) {
    // Load Expenses
    on<LoadExpensesEvent>(_onLoadExpenses);
    on<RefreshExpensesEvent>(_onRefreshExpenses);

    // CRUD Operations
    on<AddExpenseEvent>(_onAddExpense);
    on<UpdateExpenseEvent>(_onUpdateExpense);
    on<DeleteExpenseEvent>(_onDeleteExpense);

    // Categories
    on<LoadCategoriesEvent>(_onLoadCategories);

    // Filters
    on<FilterExpensesByCategoryEvent>(_onFilterByCategory);
    on<SearchExpensesEvent>(_onSearchExpenses);
  }

  void _onLoadExpenses(
    LoadExpensesEvent event,
    Emitter<ExpensesState> emit,
  ) async {
    emit(ExpensesLoading());

    try {
      // Load categories first
      final categoriesResult = getCategoriesUseCase(Nothing());
      List<ExpenseCategoryModel> categories = [];

      categoriesResult.fold(
        (data) => categories = data,
        (error) => emit(ExpensesError('Failed to load categories: $error')),
      );

      await _setupExpensesStream(emit, categories);
    } catch (e) {
      emit(ExpensesError('Failed to load records: $e'));
    }
  }

  Future<void> _setupExpensesStream(
    Emitter<ExpensesState> emit,
    List<ExpenseCategoryModel> categories,
  ) async {
    await _expensesSubscription?.cancel();

    await emit.forEach<List<ExpenseModel>>(
      getExpensesStreamsUseCase(Nothing()),
      onData: (expenses) {
        final totalAmount = expenses.fold(
          0.0,
          (sum, expense) => sum + expense.amount,
        );

        return ExpensesLoaded(
          expenses: expenses,
          categories: categories,
          totalAmount: totalAmount,
        );
      },
      onError: (error, _) {
        GlobalMessageBus.showError(error.toString());
        return ExpensesError('Failed to load expenses: $error');
      },
    );
  }

  void _onRefreshExpenses(
    RefreshExpensesEvent event,
    Emitter<ExpensesState> emit,
  ) {
    add(LoadExpensesEvent());
  }

  void _onAddExpense(AddExpenseEvent event, Emitter<ExpensesState> emit) async {
    // Keep current state while processing
    final currentState = state;

    try {
      final result = await addExpenseUseCase(
        AddExpenseParams(
          amount: event.amount,
          category: event.category,
          description: event.description,
          imageUrl: event.imageUrl,
        ),
      );

      result.fold(
        (data) {
          emit(ExpenseAddedSuccess('Expense added successfully'));
          // Data will be automatically updated via stream
        },
        (error) {
          if (currentState is ExpensesLoaded) {
            emit(
              ExpenseOperationError(
                message: error,
                expenses: currentState.expenses,
                categories: currentState.categories,
              ),
            );
          } else {
            emit(ExpensesError(error));
          }
        },
      );
    } catch (e) {
      emit(ExpensesError('Failed to add expense: $e'));
    }
  }

  void _onUpdateExpense(
    UpdateExpenseEvent event,
    Emitter<ExpensesState> emit,
  ) async {
    final currentState = state;

    try {
      final result = await updateExpenseUseCase(
        UpdateExpenseParams(
          expense: event.expense,
          amount: event.amount,
          category: event.category,
          description: event.description,
          imageUrl: event.imageUrl,
        ),
      );

      result.fold(
        (data) {
          emit(ExpenseUpdatedSuccess('Expense updated successfully'));
        },
        (error) {
          if (currentState is ExpensesLoaded) {
            emit(
              ExpenseOperationError(
                message: error,
                expenses: currentState.expenses,
                categories: currentState.categories,
              ),
            );
          } else {
            emit(ExpensesError(error));
          }
        },
      );
    } catch (e) {
      emit(ExpensesError('Failed to update expense: $e'));
    }
  }

  void _onDeleteExpense(
    DeleteExpenseEvent event,
    Emitter<ExpensesState> emit,
  ) async {
    final currentState = state;

    try {
      final result = await deleteExpenseUseCase(
        DeleteExpenseParams(event.expenseId),
      );

      result.fold(
        (data) {
          emit(ExpenseDeletedSuccess('Expense deleted successfully'));
        },
        (error) {
          if (currentState is ExpensesLoaded) {
            emit(
              ExpenseOperationError(
                message: error,
                expenses: currentState.expenses,
                categories: currentState.categories,
              ),
            );
          } else {
            emit(ExpensesError(error));
          }
        },
      );
    } catch (e) {
      emit(ExpensesError('Failed to delete expense: $e'));
    }
  }

  void _onLoadCategories(
    LoadCategoriesEvent event,
    Emitter<ExpensesState> emit,
  ) {
    final categoriesResult = getCategoriesUseCase(Nothing());

    categoriesResult.fold(
      (categories) {
        if (state is ExpensesLoaded) {
          final currentState = state as ExpensesLoaded;
          emit(currentState.copyWith(categories: categories));
        }
      },
      (error) {
        emit(ExpensesError('Failed to load categories: $error'));
      },
    );
  }

  void _onFilterByCategory(
    FilterExpensesByCategoryEvent event,
    Emitter<ExpensesState> emit,
  ) {
    if (state is ExpensesLoaded) {
      final currentState = state as ExpensesLoaded;
      emit(currentState.copyWith(selectedCategory: event.category));
    }
  }

  void _onSearchExpenses(
    SearchExpensesEvent event,
    Emitter<ExpensesState> emit,
  ) {
    if (state is ExpensesLoaded) {
      final currentState = state as ExpensesLoaded;
      emit(currentState.copyWith(searchQuery: event.query));
    }
  }

  @override
  Future<void> close() {
    _expensesSubscription?.cancel();
    return super.close();
  }
}
