// Created by Sultonbek Tulanov on 31-August 2025

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/util/no_params.dart';
import '../../domain/usecase/get_current_user_usecase.dart';

// auth_status_cubit.dart
class AuthStatusCubit extends Cubit<bool> {
  final GetCurrentUserUseCase getCurrentUserUseCase;

  AuthStatusCubit(this.getCurrentUserUseCase)
    : super(getCurrentUserUseCase(Nothing()) != null);

  void login() {
    emit(true);
  }

  void logout() {
    emit(false);
  }
}
