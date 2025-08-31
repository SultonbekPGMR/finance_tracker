// Created by Sultonbek Tulanov on 31-August 2025

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/presentation/router/app_router.dart';
import '../../../../core/util/no_params.dart';
import '../../domain/usecase/is_user_signed_in_usecase.dart';

// auth_status_cubit.dart
class AuthStatusCubit extends Cubit<bool> {
  final IsUserSignedInUseCase isUserSignedInUseCase;

  AuthStatusCubit(this.isUserSignedInUseCase) : super(isUserSignedInUseCase(Nothing()));

  void login() {
    emit(true);
  }

  void logout() {
    emit(false);
  }
}
