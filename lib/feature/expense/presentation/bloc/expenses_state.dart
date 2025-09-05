part of 'expenses_bloc.dart';

abstract class ExpensesState {}

class ExpensesInitial extends ExpensesState {}

class ExpensesLoading extends ExpensesState {}

class ExpensesLoaded extends ExpensesState {
  final List<ExpenseListItem> expenses;
  final List<ExpenseCategoryModel> categories;
  final double totalAmount;
  final DateTime selectedDate;
  final String searchQuery;

  ExpensesLoaded({
    required this.expenses,
    required this.categories,
    required this.totalAmount,
    required this.selectedDate,
    this.searchQuery = '',
  });
}

class ExpensesError extends ExpensesState {
  final Exception exception;
  ExpensesError(this.exception);
}