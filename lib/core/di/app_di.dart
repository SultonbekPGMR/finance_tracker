// Created by Sultonbek Tulanov on 30-August 2025

import 'package:finance_tracker/core/di/repository_module.dart';
import 'package:finance_tracker/core/di/usecase_module.dart';
import 'package:get_it/get_it.dart';

import 'bloc_module.dart';

final get = GetIt.instance;

class AppDi {
  AppDi._();

  static void initialize() {
    RepositoryModule.initialize(get);
    UseCaseModule.initialize(get);
    BlocModule.initialize(get);
  }
}
