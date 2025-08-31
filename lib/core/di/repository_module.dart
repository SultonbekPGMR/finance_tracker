// Created by Sultonbek Tulanov on 30-August 2025

import 'package:get_it/get_it.dart';

import '../../feature/auth/data/repository/auth_repository_impl.dart';
import '../../feature/auth/domain/repository/auth_repository.dart';
import '../../feature/expense/data/repository/expense_repository_impl.dart';
import '../../feature/expense/domain/repository/expense_repository.dart';

class RepositoryModule {
  RepositoryModule._();

  static void initialize( GetIt getIt) {
    getIt.registerSingleton<AuthRepository>(AuthRepositoryImpl());
    getIt.registerSingleton<ExpenseRepository>(ExpenseRepositoryImpl());
  }
}
