part of 'expenses_bloc.dart';

abstract class ExpensesState {}

class ExpensesInitial extends ExpensesState {}

class ExpensesLoading extends ExpensesState {}

class ExpensesLoaded extends ExpensesState {
  final List<ExpenseModel> expenses;
  final List<ExpenseCategoryModel> categories;
  final ExpenseCategoryModel? selectedCategory;
  final String searchQuery;
  final double totalAmount;

  ExpensesLoaded({
    required this.expenses,
    required this.categories,
    this.selectedCategory,
    this.searchQuery = '',
    required this.totalAmount,
  });

  // Filtered expenses based on category and search
  List<ExpenseModel> get filteredExpenses {
    var filtered = expenses;

    // Filter by category
    if (selectedCategory != null) {
      filtered = filtered.where((expense) =>
      expense.category == selectedCategory!.name).toList();
    }

    // Filter by search query
    if (searchQuery.isNotEmpty) {
      filtered = filtered.where((expense) =>
      expense.description.toLowerCase().contains(searchQuery.toLowerCase()) ||
          expense.category.toLowerCase().contains(searchQuery.toLowerCase())
      ).toList();
    }

    return filtered;
  }

  // Filtered total amount
  double get filteredTotalAmount {
    return filteredExpenses.fold(0.0, (sum, expense) => sum + expense.amount);
  }

  ExpensesLoaded copyWith({
    List<ExpenseModel>? expenses,
    List<ExpenseCategoryModel>? categories,
    ExpenseCategoryModel? selectedCategory,
    String? searchQuery,
    double? totalAmount,
  }) {
    return ExpensesLoaded(
      expenses: expenses ?? this.expenses,
      categories: categories ?? this.categories,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      searchQuery: searchQuery ?? this.searchQuery,
      totalAmount: totalAmount ?? this.totalAmount,
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
  final List<ExpenseModel> expenses;
  final List<ExpenseCategoryModel> categories;

  ExpenseOperationError({
    required this.message,
    required this.expenses,
    required this.categories,
  });
}
