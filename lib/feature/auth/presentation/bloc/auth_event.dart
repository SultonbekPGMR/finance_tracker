part of 'auth_bloc.dart';

abstract class AuthEvent {}

class SignInEvent extends AuthEvent {
  final String email;
  final String password;

  SignInEvent(this.email, this.password);
}

class SignUpEvent extends AuthEvent {
  final String email;
  final String password;
  final String passwordConfirm;

  SignUpEvent(this.email, this.password, this.passwordConfirm);
}
class SignOutEvent extends AuthEvent {}


