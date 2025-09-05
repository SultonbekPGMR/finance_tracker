import 'dart:async';

import 'package:finance_tracker/core/config/talker.dart';
import 'package:finance_tracker/core/util/eventbus/global_message_bus.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../../core/util/no_params.dart';
import '../../data/model/expense_category_model.dart';
import '../../data/model/expense_model.dart';
import '../../domain/usecase/delete_expense_usecase.dart';
import '../../domain/usecase/get_categories_usecase.dart';
import '../../domain/usecase/get_expense_stream_usecase.dart';
import '../model/expense_list_item.dart';

part 'expenses_event.dart';
part 'expenses_state.dart';

class ExpensesBloc extends Bloc<ExpensesEvent, ExpensesState> {
  final GetExpensesStreamUseCase _getExpensesStreamUseCase;
  final DeleteExpenseUseCase _deleteExpenseUseCase;
  final GetCategoriesUseCase _getCategoriesUseCase;

  DateTime _selectedMonth = DateTime.now();
  String _currentQuery = '';
  List<ExpenseCategoryModel>? _categories;

  ExpensesBloc(
    this._deleteExpenseUseCase,
    this._getCategoriesUseCase,
    this._getExpensesStreamUseCase,
  ) : super(ExpensesInitial()) {
    on<LoadExpensesEvent>(_onLoadExpenses);
    on<ChangeMonthEvent>(_onChangeMonth);
    on<SearchExpensesEvent>(_onSearchExpenses);
    on<DeleteExpenseEvent>(_onDeleteExpense);
  }

  Future<void> _onLoadExpenses(
    LoadExpensesEvent event,
    Emitter<ExpensesState> emit,
  ) async {
    emit(ExpensesLoading());
    final month = event.month ?? DateTime.now();
    _selectedMonth = month;

    _categories = await _loadCategories();
    if (_categories == null) {
      emit(ExpensesError(Exception('Failed to load categories')));
      return;
    }

    await _setupExpensesStream(emit);
  }

  Future<void> _onChangeMonth(
    ChangeMonthEvent event,
    Emitter<ExpensesState> emit,
  ) async {
    if (_categories == null) return;

    _selectedMonth = event.month;
    emit(ExpensesLoading());
    await _setupExpensesStream(emit);
  }

  Future<void> _onSearchExpenses(
    SearchExpensesEvent event,
    Emitter<ExpensesState> emit,
  ) async {
    if (_categories == null) return;

    _currentQuery = event.query;
    emit(ExpensesLoading());
    await _setupExpensesStream(emit);
  }

  Future<void> _onDeleteExpense(
    DeleteExpenseEvent event,
    Emitter<ExpensesState> emit,
  ) async {
    final result = await _deleteExpenseUseCase(
      DeleteExpenseParams(event.expenseId),
    );
    result.fold(
      (_) {}, // Success - stream will automatically update
      (error) => GlobalMessageBus.showError(error),
    );
  }

  Future<void> _setupExpensesStream(Emitter<ExpensesState> emit) async {
    final params = GetExpensesParams(
      month: _selectedMonth,
      query: _currentQuery.isEmpty ? null : _currentQuery,
    );

    await emit.forEach<List<ExpenseModel>>(
      _getExpensesStreamUseCase(params),
      onData: (expenses) {
        appTalker?.debug('Expenses loaded: $expenses');
        return ExpensesLoaded(
          expenses: _groupExpensesByDate(expenses),
          categories: _categories!,
          totalAmount: _calculateTotal(expenses),
          selectedDate: _selectedMonth,
          searchQuery: _currentQuery,
        );
      },
      onError:
          (error, stackTrace) =>
              ExpensesError(Exception('Failed to load expenses: $error')),
    );
  }

  Future<List<ExpenseCategoryModel>?> _loadCategories() async {
    final result = await _getCategoriesUseCase(Nothing());
    return result.fold((categories) => categories, (error) => null);
  }

  List<ExpenseListItem> _groupExpensesByDate(List<ExpenseModel> expenses) {
    final grouped = <String, List<ExpenseModel>>{};
    final dateFormatter = DateFormat('yyyy-MM-dd');

    for (final expense in expenses) {
      final dateKey = dateFormatter.format(expense.createdAt);
      grouped.putIfAbsent(dateKey, () => []).add(expense);
    }

    final items = <ExpenseListItem>[];

    // Sort dates in descending order (newest first)
    final sortedDates = grouped.keys.toList()..sort((a, b) => b.compareTo(a));

    for (final dateKey in sortedDates) {
      final expensesForDate = grouped[dateKey]!;
      final dayTotal = _calculateTotal(expensesForDate);

      items.add(ExpenseHeaderItem(dateKey, DateTime.parse(dateKey), dayTotal));

      // Sort expenses within the day by creation time (newest first)
      expensesForDate.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      items.addAll(expensesForDate.map(ExpenseDataItem.new));
    }

    return items;
  }

  double _calculateTotal(List<ExpenseModel> expenses) {
    return expenses.fold(0.0, (sum, expense) => sum + expense.amount);
  }
}
