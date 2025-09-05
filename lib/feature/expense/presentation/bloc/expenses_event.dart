part of 'expenses_bloc.dart';

abstract class ExpensesEvent {}

class LoadExpensesEvent extends ExpensesEvent {
  final DateTime? month;

  LoadExpensesEvent({this.month});
}

class ChangeMonthEvent extends ExpensesEvent {
  final DateTime month;
  ChangeMonthEvent(this.month);
}

class SearchExpensesEvent extends ExpensesEvent {
  final String query;
  SearchExpensesEvent(this.query);
}

class DeleteExpenseEvent extends ExpensesEvent {
  final String expenseId;
  DeleteExpenseEvent(this.expenseId);
}