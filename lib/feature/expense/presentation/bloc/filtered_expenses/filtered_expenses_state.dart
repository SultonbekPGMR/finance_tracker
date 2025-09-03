part of 'filtered_expenses_cubit.dart';

abstract class FilteredExpensesState  {
  const FilteredExpensesState();

  List<Object?> get props => [];
}

class FilteredExpensesInitial extends FilteredExpensesState {}

class FilteredExpensesLoading extends FilteredExpensesState {}

class FilteredExpensesLoaded extends FilteredExpensesState {
  final List<ExpenseModel> expenses;

  const FilteredExpensesLoaded(this.expenses);

  @override
  List<Object?> get props => [expenses];
}

class FilteredExpensesError extends FilteredExpensesState {
  final Exception error;

  const FilteredExpensesError(this.error);

  @override
  List<Object?> get props => [error];
}