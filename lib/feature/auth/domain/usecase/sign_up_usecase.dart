// Created by Sultonbek Tulanov on 31-August 2025

import 'package:finance_tracker/core/util/usecase.dart';
import 'package:result_dart/result_dart.dart';

import '../repository/auth_repository.dart';

class SignUpUseCase implements UseCase<Future<Result<bool>>, SignUpParams> {
  final AuthRepository authRepository;

  SignUpUseCase(this.authRepository);

  @override
  Future<Result<bool>> call(SignUpParams params) async {
    return await authRepository.signUp(params.email, params.password);
  }
}

class SignUpParams {
  final String email;
  final String password;
  final String passwordConfirm;

  SignUpParams(this.email, this.password, this.passwordConfirm);
}
