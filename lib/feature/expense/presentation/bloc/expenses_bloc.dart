import 'dart:async';

import 'package:finance_tracker/core/config/talker.dart';
import 'package:finance_tracker/core/util/eventbus/global_message_bus.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../../core/util/no_params.dart';
import '../../data/model/expense_category_model.dart';
import '../../data/model/expense_model.dart';
import '../../domain/usecase/add_expense_usecase.dart';
import '../../domain/usecase/delete_expense_usecase.dart';
import '../../domain/usecase/get_categories_usecase.dart';
import '../../domain/usecase/get_expense_stream_usecase.dart';
import '../../domain/usecase/get_expenses_usecase.dart';
import '../../domain/usecase/update_expense_usecase.dart';
import '../model/expense_list_item.dart';

part 'expenses_event.dart';
part 'expenses_state.dart';

class ExpensesBloc extends Bloc<ExpensesEvent, ExpensesState> {
  final GetExpensesStreamUseCase _getExpensesStreamsUseCase;
  final DeleteExpenseUseCase _deleteExpenseUseCase;
  final GetCategoriesUseCase _getCategoriesUseCase;

  StreamSubscription<List<ExpenseModel>>? _expensesSubscription;

  ExpensesBloc(
    this._deleteExpenseUseCase,
    this._getCategoriesUseCase,
    this._getExpensesStreamsUseCase,
  ) : super(ExpensesInitial()) {
    // Load Expenses
    on<LoadExpensesEvent>(_onLoadExpenses);
    on<RefreshExpensesEvent>(_onRefreshExpenses);

    on<ChangeMonthEvent>(_onChangeMonth);

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
      final categoriesResult = _getCategoriesUseCase(Nothing());
      List<ExpenseCategoryModel> categories = [];

      categoriesResult.fold(
        (data) => categories = data,
        (error) => emit(ExpensesError('Failed to load categories: $error')),
      );

      await _setupExpensesStream(emit, categories, DateTime.now());
    } catch (e) {
      emit(ExpensesError('Failed to load records: $e'));
    }
  }

  Future<void> _setupExpensesStream(
      Emitter<ExpensesState> emit,
      List<ExpenseCategoryModel> categories,
      DateTime selectedMonth,
      ) async {
    await _expensesSubscription?.cancel();

    appTalker?.debug('Setting up stream for month: $selectedMonth');

    await emit.forEach<List<ExpenseModel>>(
      _getExpensesStreamsUseCase(GetExpensesParams(month: selectedMonth)),
      onData: (expenses) {
        appTalker?.debug('Received ${expenses.length} expenses');
        final groupedItems = _groupExpensesByDate(expenses);
        final totalAmount = expenses.fold(0.0, (sum, expense) => sum + expense.amount);

        return ExpensesLoaded(
          expenses: groupedItems,
          categories: categories,
          totalAmount: totalAmount,
          selectedDate: selectedMonth,
        );
      },
      onError: (error, _) {
        appTalker?.error('Stream error: $error');
        GlobalMessageBus.showError(error.toString());
        return ExpensesError('Failed to load expenses: $error');
      },
    );
  }
  void _onChangeMonth(
      ChangeMonthEvent event,
      Emitter<ExpensesState> emit,
      ) async {
    final currentState = state;
    if (currentState is ExpensesLoaded) {
      emit(ExpensesLoading());

      try {
        await _setupExpensesStream(
          emit,
          currentState.categories,
          event.month,
        );
      } catch (e) {
        emit(ExpensesError('Failed to load expenses for selected month: $e'));
      }
    }
  }

  void _onRefreshExpenses(
    RefreshExpensesEvent event,
    Emitter<ExpensesState> emit,
  ) {
    add(LoadExpensesEvent());
  }


  void _onDeleteExpense(
    DeleteExpenseEvent event,
    Emitter<ExpensesState> emit,
  ) async {
    final currentState = state;
appTalker?.debug('eventtttt-> $event');
    try {
      final result = await _deleteExpenseUseCase(
        DeleteExpenseParams(event.expenseId),
      );

      appTalker?.debug('resulttttt-> $result');
      result.fold(
        (data) {},
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
    final categoriesResult = _getCategoriesUseCase(Nothing());

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

  List<ExpenseListItem> _groupExpensesByDate(List<ExpenseModel> expenses) {
    final DateFormat dateFormatter = DateFormat('yyyy-MM-dd');

    // Group expenses by date
    final Map<String, List<ExpenseModel>> groupedMap = {};
    for (final expense in expenses) {
      final dateKey = dateFormatter.format(expense.createdAt);
      groupedMap.putIfAbsent(dateKey, () => []).add(expense);
    }

    final List<ExpenseListItem> items = [];

    // Create items with headers and data
    for (final entry in groupedMap.entries) {
      final dayTotal = entry.value.fold<double>(
        0,
            (sum, expense) => sum + expense.amount,
      );

      // Add header
      items.add(
        ExpenseHeaderItem(entry.key, DateTime.parse(entry.key), dayTotal),
      );

      // Add expenses for that day
      items.addAll(entry.value.map((expense) => ExpenseDataItem(expense)));
    }

    return items;
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
