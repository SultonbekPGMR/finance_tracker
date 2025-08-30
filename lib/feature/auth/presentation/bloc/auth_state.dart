part of 'auth_bloc.dart';

abstract class AuthState {}

class AuthInitial extends AuthState {
  final bool isSignedIn;
  AuthInitial({required this.isSignedIn});
}

class AuthLoading extends AuthState {}

class AuthSuccess extends AuthState {}

class AuthFailure extends AuthState {
  final String message;
  AuthFailure({required this.message});
}
