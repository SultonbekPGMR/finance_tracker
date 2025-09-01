part of 'expenses_bloc.dart';

abstract class ExpensesEvent {}

// Load/Refresh Events
class LoadExpensesEvent extends ExpensesEvent {}

class RefreshExpensesEvent extends ExpensesEvent {}

// CRUD Events
class AddExpenseEvent extends ExpensesEvent {
  final double amount;
  final ExpenseCategoryModel category;
  final String description;
  final String? imageUrl;

  AddExpenseEvent({
    required this.amount,
    required this.category,
    required this.description,
    this.imageUrl,
  });
}
class ChangeMonthEvent extends ExpensesEvent {
  final DateTime month;
  ChangeMonthEvent(this.month);
}
class UpdateExpenseEvent extends ExpensesEvent {
  final ExpenseModel expense;
  final double amount;
  final ExpenseCategoryModel category;
  final String description;
  final String? imageUrl;

  UpdateExpenseEvent({
    required this.expense,
    required this.amount,
    required this.category,
    required this.description,
    this.imageUrl,
  });
}

class DeleteExpenseEvent extends ExpensesEvent {
  final String expenseId;

  DeleteExpenseEvent(this.expenseId);
}

// Category Events
class LoadCategoriesEvent extends ExpensesEvent {}

// Filter/Search Events
class FilterExpensesByCategoryEvent extends ExpensesEvent {
  final ExpenseCategoryModel? category; // null means show all

  FilterExpensesByCategoryEvent(this.category);
}

class SearchExpensesEvent extends ExpensesEvent {
  final String query;

  SearchExpensesEvent(this.query);
}
