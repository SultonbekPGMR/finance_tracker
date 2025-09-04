// Created by Sultonbek Tulanov on 30-August 2025

import 'package:finance_tracker/feature/auth/domain/usecase/get_current_user_usecase.dart';
import 'package:finance_tracker/feature/auth/domain/usecase/request_password_reset_usecase.dart';
import 'package:finance_tracker/feature/auth/domain/usecase/sign_in_usecase.dart';
import 'package:finance_tracker/feature/auth/domain/usecase/sign_up_usecase.dart';
import 'package:finance_tracker/feature/chart/domain/usecase/get_chart_data_usecase.dart';
import 'package:finance_tracker/feature/expense/domain/usecase/get_expenses_by_filter_usecase.dart';
import 'package:finance_tracker/feature/expense/domain/usecase/get_expenses_usecase.dart';
import 'package:get_it/get_it.dart';

import '../../feature/expense/domain/usecase/add_expense_usecase.dart';
import '../../feature/expense/domain/usecase/delete_expense_usecase.dart';
import '../../feature/expense/domain/usecase/get_categories_usecase.dart';
import '../../feature/expense/domain/usecase/get_expense_by_id_usecase.dart';
import '../../feature/expense/domain/usecase/get_expense_stream_usecase.dart';
import '../../feature/expense/domain/usecase/update_expense_usecase.dart';



class UseCaseModule {
  UseCaseModule._();

  static void initialize(GetIt getIt) {
    getIt.registerSingleton(GetCurrentUserUseCase(getIt.get()));
    getIt.registerSingleton(SignInUseCase(getIt.get()));
    getIt.registerSingleton(SignUpUseCase(getIt.get()));
    getIt.registerSingleton(RequestPasswordResetUseCase(getIt.get()));

    getIt.registerSingleton(AddExpenseUseCase(getIt.get(),getIt.get()));
    getIt.registerSingleton(GetExpenseByIdUseCase(getIt.get(),getIt.get()));
    getIt.registerSingleton(GetExpensesStreamUseCase(getIt.get(),getIt.get()));
    getIt.registerSingleton(GetExpensesUseCase(getIt.get(),getIt.get()));
    getIt.registerSingleton(DeleteExpenseUseCase(getIt.get(),getIt.get()));
    getIt.registerSingleton(UpdateExpenseUseCase(getIt.get(),getIt.get()));
    getIt.registerSingleton(GetCategoriesUseCase());
    getIt.registerSingleton(GetChartDataUseCase(getIt(), getIt()));
    getIt.registerSingleton(GetExpensesByFilterUseCase(getIt(), getIt()));
  }
}

 
