// Created by Sultonbek Tulanov on 31-August 2025

import 'package:finance_tracker/core/util/usecase.dart';
import 'package:finance_tracker/core/util/validator/auth_validator.dart';
import 'package:result_dart/result_dart.dart';

import '../repository/auth_repository.dart';

class SignUpUseCase
    implements UseCase<Future<ResultDart<bool, String>>, SignUpParams> {
  final AuthRepository authRepository;

  SignUpUseCase(this.authRepository);

  @override
  Future<ResultDart<bool, String>> call(SignUpParams params) async {
    final validationResult = _validateParams(params);
    if (validationResult != null) return Failure(validationResult);

    return await authRepository.signUp(params.email, params.password);
  }

  String? _validateParams(SignUpParams params) {
    final emailError = AuthValidator.validateEmail(params.email);
    if (emailError != null) return emailError;

    final passwordError = AuthValidator.validatePassword(params.password);
    if (passwordError != null) return passwordError;

    final passwordConfirmError = AuthValidator.validatePassword(
      params.passwordConfirm,
    );
    if (passwordConfirmError != null) return passwordConfirmError;

    if (params.password != params.passwordConfirm) {
      return 'Passwords do not match';
    }

    return null;
  }
}

class SignUpParams {
  final String email;
  final String password;
  final String passwordConfirm;

  SignUpParams(this.email, this.password, this.passwordConfirm);
}
