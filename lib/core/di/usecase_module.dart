// Created by Sultonbek Tulanov on 30-August 2025

import 'package:finance_tracker/feature/auth/domain/usecase/is_user_signed_in_usecase.dart';
import 'package:finance_tracker/feature/auth/domain/usecase/sign_in_usecase.dart';
import 'package:finance_tracker/feature/auth/domain/usecase/sign_up_usecase.dart';
import 'package:get_it/get_it.dart';

class UseCaseModule {
  UseCaseModule._();

  static void initialize(GetIt getIt) {
    getIt.registerSingleton(IsUserSignedInUseCase(getIt.get()));
    getIt.registerSingleton(SignInUseCase(getIt.get()));
    getIt.registerSingleton(SignUpUseCase(getIt.get()));
  }
}

 
