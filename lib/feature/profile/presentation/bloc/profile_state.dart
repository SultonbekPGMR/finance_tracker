part of 'profile_cubit.dart';

sealed class ProfileState {}

class ProfileInitial extends ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileLoaded extends ProfileState {
  final UserModel user;
  final UserPreferences preferences;

  ProfileLoaded({required this.user, required this.preferences});
}

class ProfileUpdating extends ProfileState {
  final UserModel user;
  final UserPreferences preferences;

  ProfileUpdating({required this.user, required this.preferences});
}

class ProfileError extends ProfileState {
  final String message;

  ProfileError(this.message);
}
