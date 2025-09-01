part of 'expenses_bloc.dart';

abstract class ExpensesState {}

class ExpensesInitial extends ExpensesState {}

class ExpensesLoading extends ExpensesState {}

class ExpensesLoaded extends ExpensesState {
  final List<ExpenseListItem> expenses; // For UI display
  final List<ExpenseCategoryModel> categories;
  final ExpenseCategoryModel? selectedCategory;
  final String searchQuery;
  final double totalAmount;
  final DateTime selectedDate;

  ExpensesLoaded({
    required this.expenses,
    required this.categories,
    this.selectedCategory,
    this.searchQuery = '',
    required this.totalAmount,
    required this.selectedDate,
  });

  ExpensesLoaded copyWith({
    List<ExpenseListItem>? expenses,
    List<ExpenseCategoryModel>? categories,
    ExpenseCategoryModel? selectedCategory,
    String? searchQuery,
    double? totalAmount,
    DateTime? selectedMonth,
  }) {
    return ExpensesLoaded(
      expenses: expenses ?? this.expenses,
      categories: categories ?? this.categories,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      searchQuery: searchQuery ?? this.searchQuery,
      totalAmount: totalAmount ?? this.totalAmount,
      selectedDate: selectedMonth ?? this.selectedDate,
    );
  }
}

// Success States
class ExpenseAddedSuccess extends ExpensesState {
  final String message;

  ExpenseAddedSuccess(this.message);
}

class ExpenseUpdatedSuccess extends ExpensesState {
  final String message;

  ExpenseUpdatedSuccess(this.message);
}

class ExpenseDeletedSuccess extends ExpensesState {
  final String message;

  ExpenseDeletedSuccess(this.message);
}

// Error States
class ExpensesError extends ExpensesState {
  final String message;

  ExpensesError(this.message);
}

class ExpenseOperationError extends ExpensesState {
  final String message;
  final List<ExpenseListItem> expenses;
  final List<ExpenseCategoryModel> categories;

  ExpenseOperationError({
    required this.message,
    required this.expenses,
    required this.categories,
  });
}
