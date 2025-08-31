// Created by Sultonbek Tulanov on 30-August 2025

import 'package:finance_tracker/feature/auth/presentation/bloc/auth_state_cubit.dart';
import 'package:get_it/get_it.dart';

import '../../feature/auth/presentation/bloc/auth_bloc.dart';

class BlocModule {
  BlocModule._();

  static void initialize(GetIt getIt) {
    getIt.registerFactory(() => AuthStatusCubit(getIt.get()));
    getIt.registerFactory(
      () => AuthBloc(getIt.get(), getIt.get(), getIt.get()),
    );
  }
}
