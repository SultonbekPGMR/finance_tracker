import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/model/category_expense_data.dart';
import '../../domain/usecase/get_chart_data_usecase.dart';

part 'chart_state.dart';

class ChartCubit extends Cubit<ChartState> {
  final GetChartDataUseCase _getChartDataUseCase;
  StreamSubscription? _chartDataSubscription;
  DateTime? _currentMonth;
  final _now = DateTime.now();


  ChartCubit(this._getChartDataUseCase) : super(ChartInitial());

  List<DateTime> _getMonthsOfYear(DateTime year) {
    final months = <DateTime>[];

    final maxMonth = (year.year == _now.year) ? _now.month : 12;

    for (int i = 1; i <= maxMonth; i++) {
      months.add(DateTime(year.year, i, 1));
    }

    return months;
  }

  void loadChartData(DateTime month) {
    // Cancel previous subscription to avoid memory leaks
    _chartDataSubscription?.cancel();
    _currentMonth = month;

    emit(ChartLoading());

    try {
      final chartDataStream = _getChartDataUseCase(
        GetChartDataParams(month: month),
      );

      _chartDataSubscription = chartDataStream.listen(
        (result) {
          // Only emit if we're still interested in this month's data
          if (_currentMonth == month && !isClosed) {
            final months = _getMonthsOfYear(month);
            result
                .onSuccess(
                  (success) => emit(
                    ChartLoaded(
                      chartData: success,
                      selectedMonth: month,
                      availableMonths: months,
                    ),
                  ),
                )
                .onFailure((failure) {
                  emit(
                    ChartError(
                      exception: failure,
                      selectedMonth: month,
                      availableMonths: months,
                    ),
                  );
                });
          }
        },
        onError: (error) {
          // Only emit error if we're still interested in this month's data
          if (_currentMonth == month && !isClosed) {
            final exception =
                error is Exception ? error : Exception(error.toString());
            final months = _getMonthsOfYear(month);
            emit(
              ChartError(
                exception: exception,
                selectedMonth: month,
                availableMonths: months,
              ),
            );
          }
        },
      );
    } catch (e) {
      final exception = e is Exception ? e : Exception(e.toString());
      final months = _getMonthsOfYear(month);
      emit(
        ChartError(
          exception: exception,
          selectedMonth: month,
          availableMonths: months,
        ),
      );
    }
  }

  void changeYear(DateTime onlyYear) {
    final months = _getMonthsOfYear(onlyYear);
    final firstMonth = _now.year == onlyYear.year ? _now : months.first;
    loadChartData(firstMonth);
  }

  void refreshData() {
    final currentState = state;
    DateTime monthToRefresh = DateTime.now();

    if (currentState is ChartLoaded) {
      monthToRefresh = currentState.selectedMonth;
    } else if (currentState is ChartError) {
      monthToRefresh = currentState.selectedMonth;
    }

    loadChartData(monthToRefresh);
  }

  void changeMonth(DateTime newMonth) {
    loadChartData(newMonth);
  }

  void loadCurrentMonthData() {
    loadChartData(DateTime.now());
  }

  @override
  Future<void> close() {
    // Clean up subscription to prevent memory leaks
    _chartDataSubscription?.cancel();
    return super.close();
  }
}
