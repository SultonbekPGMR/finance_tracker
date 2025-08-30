import 'package:finance_tracker/core/util/no_params.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecase/is_user_signed_in_usecase.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final IsUserSignedInUseCase isUserSignedInUseCase;

  AuthBloc(this.isUserSignedInUseCase)
    : super(AuthInitial(isSignedIn: isUserSignedInUseCase(Nothing()))) {
    on<AuthEvent>((event, emit) {

    });
  }
}
