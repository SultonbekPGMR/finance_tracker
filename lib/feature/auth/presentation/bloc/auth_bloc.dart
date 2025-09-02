import 'package:finance_tracker/core/util/eventbus/global_message_bus.dart';
import 'package:finance_tracker/feature/auth/domain/usecase/sign_in_usecase.dart';
import 'package:finance_tracker/feature/auth/domain/usecase/sign_up_usecase.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'auth_state_cubit.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthStatusCubit authStatusCubit;
  final SignInUseCase signInUseCase;
  final SignUpUseCase signUpUseCase;

  AuthBloc(this.signInUseCase, this.signUpUseCase, this.authStatusCubit)
    : super(AuthInitial()) {
    on<SignInEvent>((event, emit) async {
      emit(AuthLoading());
      final SignInParams params = SignInParams(event.email, event.password);
      final result = await signInUseCase(params);

      result.fold(
        (success) {
          emit(AuthSuccess());
          authStatusCubit.login();
        },
        (error) {
          emit(AuthFailure(exception: error));
          GlobalMessageBus.showError(error);
        },
      );
    });

    on<SignUpEvent>((event, emit) async {
      emit(AuthLoading());
      final SignUpParams params = SignUpParams(
        event.email,
        event.password,
        event.passwordConfirm,
      );
      final result = await signUpUseCase(params);
      authStatusCubit.login();

      result.fold(
        (success) {
          emit(AuthSuccess());
          authStatusCubit.login();
        },
        (error) {
          emit(AuthFailure(exception: error));
          GlobalMessageBus.showError(error);
        },
      );
    });

    on<SignOutEvent>((event, emit) {
      authStatusCubit.logout();
      emit(AuthInitial());
    });
  }
}
