// Created by Sultonbek Tulanov on 31-August 2025

import 'package:finance_tracker/core/util/exception/localized_exception.dart';
import 'package:finance_tracker/core/util/usecase.dart';
import 'package:result_dart/result_dart.dart';

import '../repository/auth_repository.dart';

class SignInUseCase
    implements UseCase<Future<Result<bool>>, SignInParams> {
  final AuthRepository authRepository;

  SignInUseCase(this.authRepository);

  @override
  Future<Result<bool>> call(SignInParams params) async {
    return await authRepository.signIn(params.email, params.password);
  }


}

class SignInParams {
  final String email;
  final String password;

  SignInParams(this.email, this.password);
}
