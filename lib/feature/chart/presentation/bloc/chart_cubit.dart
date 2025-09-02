import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/model/category_expense_data.dart';
import '../../domain/usecase/get_chart_data_usecase.dart';

part 'chart_state.dart';

class ChartCubit extends Cubit<ChartState> {
  final GetChartDataUseCase _getChartDataUseCase;

  ChartCubit(this._getChartDataUseCase) : super(ChartInitial());

  List<DateTime> _getMonthsOfYear(DateTime year) {
    final now = DateTime.now();
    final months = <DateTime>[];

    final maxMonth = (year.year == now.year) ? now.month : 12;

    for (int i = 1; i <= maxMonth; i++) {
      months.add(DateTime(year.year, i, 1));
    }

    return months;
  }

  Future<void> loadChartData(DateTime month) async {
    
    emit(ChartLoading());

    try {
      final result = await _getChartDataUseCase(
        GetChartDataParams(month: month),
      );

      final months = _getMonthsOfYear(month);

      result.fold(
            (success) => emit(
          ChartLoaded(
            chartData: success,
            selectedMonth: month,
            availableMonths: months,
          ),
        ),
            (failure) => emit(
          ChartError(
            exception: failure,
            selectedMonth: month,
            availableMonths: months,
          ),
        ),
      );
    } catch (e) {
      final exception = e is Exception ? e : Exception(e.toString());
      final months = _getMonthsOfYear(month);
      emit(ChartError(
        exception: exception,
        selectedMonth: month,
        availableMonths: months,
      ));
    }
  }

  void changeYear(DateTime onlyYear) {
    final months = _getMonthsOfYear(onlyYear);
    final firstMonth = months.first;
    loadChartData(firstMonth);
  }


  Future<void> refreshData() async {
    final currentState = state;
    DateTime monthToRefresh = DateTime.now();

    if (currentState is ChartLoaded) {
      monthToRefresh = currentState.selectedMonth;
    } else if (currentState is ChartError) {
      monthToRefresh = currentState.selectedMonth;
    }

    await loadChartData(monthToRefresh);
  }

  Future<void> changeMonth(DateTime newMonth) async {
    await loadChartData(newMonth);
  }

  Future<void> loadCurrentMonthData() async {
    await loadChartData(DateTime.now());
  }


}
