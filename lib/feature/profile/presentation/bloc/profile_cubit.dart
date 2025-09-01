import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../auth/data/model/user_model.dart';
import '../../data/model/user_preferences.dart';
import '../../domain/repository/user_repository.dart';

part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final UserRepository _repository;

  ProfileCubit(this._repository) : super(ProfileInitial());

  void loadProfile() async {
    emit(ProfileLoading());

    try {
      final user = await _repository.getCurrentUser();
      final preferences = _repository.getUserPreferences();

      if (user != null) {
        emit(ProfileLoaded(user: user, preferences: preferences));
      } else {
        emit(ProfileError('No user found'));
      }
    } catch (e) {
      emit(ProfileError('Failed to load profile: $e'));
    }
  }

  void updateDisplayName(String name) async {
    final currentState = state;
    if (currentState is! ProfileLoaded) return;

    emit(ProfileUpdating(user: currentState.user, preferences: currentState.preferences));

    try {
      await _repository.updateUserProfile(name);
      final updatedUser = await _repository.getCurrentUser();
      if (updatedUser != null) {
        emit(ProfileLoaded(user: updatedUser, preferences: currentState.preferences));
      }
    } catch (e) {
      emit(ProfileError('Failed to update name: $e'));
    }
  }

  void updateTheme(String theme) async {
    final currentState = state;
    if (currentState is! ProfileLoaded) return;

    try {
      await _repository.updateThemePreference(theme);
      final preferences = _repository.getUserPreferences();
      emit(ProfileLoaded(user: currentState.user, preferences: preferences));
    } catch (e) {
      emit(ProfileError('Failed to update theme: $e'));
    }
  }

  void updateLanguage(String language) async {
    final currentState = state;
    if (currentState is! ProfileLoaded) return;

    try {
      await _repository.updateLanguagePreference(language);
      final preferences = _repository.getUserPreferences();
      emit(ProfileLoaded(user: currentState.user, preferences: preferences));
    } catch (e) {
      emit(ProfileError('Failed to update language: $e'));
    }
  }

  void updateCurrency(String currency) async {
    final currentState = state;
    if (currentState is! ProfileLoaded) return;

    try {
      await _repository.updateCurrencyPreference(currency);
      final preferences = _repository.getUserPreferences();
      emit(ProfileLoaded(user: currentState.user, preferences: preferences));
    } catch (e) {
      emit(ProfileError('Failed to update currency: $e'));
    }
  }

  void updateNotifications(bool enabled) async {
    final currentState = state;
    if (currentState is! ProfileLoaded) return;

    try {
      await _repository.updateNotificationPreference(enabled);
      final preferences = _repository.getUserPreferences();
      emit(ProfileLoaded(user: currentState.user, preferences: preferences));
    } catch (e) {
      emit(ProfileError('Failed to update notifications: $e'));
    }
  }
}
