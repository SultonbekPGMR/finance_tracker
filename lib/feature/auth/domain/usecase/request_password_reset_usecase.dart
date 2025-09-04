// Created by Sultonbek Tulanov on 04-September 2025
import 'package:finance_tracker/core/util/no_params.dart';
import 'package:finance_tracker/core/util/usecase.dart';
import 'package:result_dart/result_dart.dart';

import '../repository/auth_repository.dart';

class RequestPasswordResetUseCase
    implements FutureUseCase<Result<Nothing>, PasswordResetParams> {
  final AuthRepository _authRepository;

  RequestPasswordResetUseCase(this._authRepository);

  @override
  Future<Result<Nothing>> call(PasswordResetParams params) async {
    return await _authRepository.requestPasswordReset(params.email);
  }
}

class PasswordResetParams {
  final String email;

  PasswordResetParams(this.email);
}
