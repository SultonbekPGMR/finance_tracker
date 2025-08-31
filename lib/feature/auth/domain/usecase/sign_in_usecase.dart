// Created by Sultonbek Tulanov on 31-August 2025

import 'package:finance_tracker/core/util/usecase.dart';
import 'package:finance_tracker/core/util/validator/auth_validator.dart';
import 'package:result_dart/result_dart.dart';

import '../repository/auth_repository.dart';

class SignInUseCase
    implements UseCase<Future<ResultDart<bool, String>>, SignInParams> {
  final AuthRepository authRepository;

  SignInUseCase(this.authRepository);

  @override
  Future<ResultDart<bool, String>> call(SignInParams params) async {
    final validationResult = _validateParams(params);
    if (validationResult != null) return Failure(validationResult);

    return await authRepository.signIn(params.email, params.password);
  }

  String? _validateParams(SignInParams params) {
    final emailError = AuthValidator.validateEmail(params.email);
    if (emailError != null) return emailError;

    final passwordError = AuthValidator.validatePassword(params.password);
    if (passwordError != null) return passwordError;

    return null;
  }
}

class SignInParams {
  final String email;
  final String password;

  SignInParams(this.email, this.password);
}
