part of 'expense_details_cubit.dart';

sealed class ExpenseDetailsState {}

class ExpenseDetailsLoading extends ExpenseDetailsState {}

class ExpenseDetailsLoaded extends ExpenseDetailsState {
  final List<ExpenseCategoryModel> categories;

  ExpenseDetailsLoaded({required this.categories});
}

class ExpenseDetailsSubmitting extends ExpenseDetailsState {
  final List<ExpenseCategoryModel> categories;

  ExpenseDetailsSubmitting({required this.categories});
}

class ExpenseDetailsAddedSuccessfully extends ExpenseDetailsState {}

class ExpenseDetailsUpdatedSuccessfully extends ExpenseDetailsState {}

class ExpenseDetailsSubmissionError extends ExpenseDetailsState {
  final List<ExpenseCategoryModel> categories;
  final Exception exception;

  ExpenseDetailsSubmissionError({
    required this.categories,
    required this.exception,
  });
}

class ExpenseDetailsError extends ExpenseDetailsState {
  final Exception exception;

  ExpenseDetailsError(this.exception);
}
