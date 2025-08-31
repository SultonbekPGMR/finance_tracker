// Created by Sultonbek Tulanov on 30-August 2025

import 'package:finance_tracker/core/util/no_params.dart';
import 'package:finance_tracker/core/util/usecase.dart';
import 'package:finance_tracker/feature/auth/data/model/user_model.dart';
import 'package:finance_tracker/feature/auth/domain/repository/auth_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';

class GetCurrentUserUseCase implements UseCase<UserModel?, Nothing> {
  final AuthRepository authRepository;

  GetCurrentUserUseCase(this.authRepository);

  @override
  UserModel? call(Nothing params) {
    return authRepository.getCurrentUser();
  }

}
