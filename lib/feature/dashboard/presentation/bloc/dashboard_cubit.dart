// Created by Sultonbek Tulanov on 05-September 2025

import 'dart:async';

import 'package:finance_tracker/feature/dashboard/domain/usecase/get_dashboard_data_usecase.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/util/no_params.dart';
import '../../data/model/dashboard_data.dart';

part 'dashboard_state.dart';

class DashboardCubit extends Cubit<DashboardState> {
  final GetDashboardDataUseCase _getDashboardDataUseCase;
  StreamSubscription<DashboardData>? _dashboardSubscription;

  DashboardCubit(this._getDashboardDataUseCase) : super(DashboardInitial());

  Future<void> loadDashboardData() async {
    emit(DashboardLoading());

    try {
      await _dashboardSubscription?.cancel();
      _dashboardSubscription = _getDashboardDataUseCase(Nothing()).listen(
            (dashboardData) {
          if (!isClosed) {
            emit(DashboardLoaded(dashboardData));
          }
        },
        onError: (error) {
          if (!isClosed) {
            emit(DashboardError('Failed to load dashboard data: $error'));
          }
        },
      );
    } catch (e) {
      emit(DashboardError('Failed to load dashboard data: $e'));
    }
  }

  void refreshDashboard() {
    loadDashboardData();
  }

  @override
  Future<void> close() {
    _dashboardSubscription?.cancel();
    return super.close();
  }
}
