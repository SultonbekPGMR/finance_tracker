// Created by Sultonbek Tulanov on 30-August 2025

import 'package:get_it/get_it.dart';

import '../../feature/auth/domain/usecase/is_user_signed_in_usecase.dart';
import '../../feature/auth/presentation/bloc/auth_bloc.dart';

class BlocModule {
  BlocModule._();

  static void initialize( GetIt getIt) {
    getIt.registerFactory(() => AuthBloc(getIt.get()));
  }
}
 
