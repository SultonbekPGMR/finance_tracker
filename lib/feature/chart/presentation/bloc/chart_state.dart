part of 'chart_cubit.dart';

abstract class ChartState {}

class ChartInitial extends ChartState {}

class ChartLoading extends ChartState {}

class ChartLoaded extends ChartState {
  final List<CategoryExpenseData> chartData;
  final DateTime selectedMonth;
  final List<DateTime> availableMonths;

  ChartLoaded({
    required this.chartData,
    required this.selectedMonth,
    required this.availableMonths,
  });
}

class ChartError extends ChartState {
  final Exception exception;
  final DateTime selectedMonth;
  final List<DateTime> availableMonths;

  ChartError({
    required this.exception,
    required this.selectedMonth,
    required this.availableMonths,
  });
}
