// Created by Sultonbek Tulanov on 30-August 2025

import 'package:finance_tracker/core/usecase/usecase.dart';
import 'package:finance_tracker/core/util/no_params.dart';
import 'package:finance_tracker/feature/auth/domain/repository/auth_repository.dart';

class IsUserSignedInUseCase extends UseCase<bool, Nothing> {
  final AuthRepository authRepository;

  IsUserSignedInUseCase(this.authRepository);

  @override
  bool call(Nothing params) {
    return authRepository.isSignedIn();
  }
}
