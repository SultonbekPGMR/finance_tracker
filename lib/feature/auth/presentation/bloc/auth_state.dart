part of 'auth_bloc.dart';

abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthSuccess extends AuthState {}

class AuthFailure extends AuthState {
  final Exception exception;
  AuthFailure({required this.exception});
}
class AuthPasswordResetEmailSent extends AuthState {}
class AuthPasswordResetLoading extends AuthState {}
