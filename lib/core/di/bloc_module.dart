// Created by Sultonbek Tulanov on 30-August 2025

import 'package:finance_tracker/core/di/app_di.dart';
import 'package:finance_tracker/feature/auth/presentation/bloc/auth_state_cubit.dart';
import 'package:finance_tracker/feature/chart/presentation/bloc/chart_cubit.dart';
import 'package:finance_tracker/feature/expense/presentation/bloc/filtered_expenses/filtered_expenses_cubit.dart';
import 'package:finance_tracker/feature/profile/presentation/bloc/profile_cubit.dart';
import 'package:get_it/get_it.dart';

import '../../feature/auth/presentation/bloc/auth_bloc.dart';
import '../../feature/expense/presentation/bloc/expense_details/expense_details_cubit.dart';
import '../../feature/expense/presentation/bloc/expenses_bloc.dart';

class BlocModule {
  BlocModule._();

  static void initialize(GetIt getIt) {
    getIt.registerFactory(() => AuthStatusCubit(getIt.get()));
    getIt.registerFactory(
      () => AuthBloc(getIt.get(), getIt.get(), getIt.get()),
    );
    getIt.registerFactory(
      () => ExpensesBloc(getIt.get(), getIt.get(), getIt.get()),
    );
    getIt.registerFactory(() => ExpenseDetailsCubit(get(), get(), get()));
    getIt.registerFactory(() => ProfileCubit(get(), get()));
    getIt.registerFactory(() => ChartCubit(get()));
    getIt.registerFactory(() => FilteredExpensesCubit(get()));
  }
}
