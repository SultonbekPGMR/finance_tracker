import 'package:finance_tracker/core/config/talker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../auth/data/model/user_model.dart';
import '../../../auth/domain/repository/auth_repository.dart';
import '../../data/model/user_preferences.dart';
import '../../domain/repository/user_repository.dart';

part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final UserRepository _repository;
  final AuthRepository _authRepository;

  ProfileCubit(this._repository, this._authRepository)
    : super(ProfileInitial());

  void loadProfile() async {
    emit(ProfileLoading());
    final preferences = _repository.getUserPreferences();
    final user = await _repository.getCurrentUser();
    emit(ProfileLoaded(user: user, preferences: preferences));
  }

  void updateDisplayName(String name) async {
    final currentState = state;
    if (currentState is! ProfileLoaded) return;

    emit(
      ProfileUpdating(
        user: currentState.user,
        preferences: currentState.preferences,
      ),
    );

    await _repository.updateUserProfile(name);
    final updatedUser = await _repository.getCurrentUser();
    if (updatedUser != null) {
      emit(
        ProfileLoaded(user: updatedUser, preferences: currentState.preferences),
      );
    }
  }

  void updateTheme(String theme) async {
    final currentState = state;
    if (currentState is! ProfileLoaded) return;
    await _repository.updateThemePreference(theme);
    final preferences = _repository.getUserPreferences();
    emit(ProfileLoaded(user: currentState.user, preferences: preferences));
  }

  void updateLanguage(String language) async {
    final currentState = state;
    if (currentState is! ProfileLoaded) return;
    await _repository.updateLanguagePreference(language);
    final preferences = _repository.getUserPreferences();
    emit(ProfileLoaded(user: currentState.user, preferences: preferences));
  }

  void updateCurrency(String currency) async {
    final currentState = state;
    if (currentState is! ProfileLoaded) return;
    await _repository.updateCurrencyPreference(currency);
    final preferences = _repository.getUserPreferences();
    emit(ProfileLoaded(user: currentState.user, preferences: preferences));
  }

  void updateNotifications(bool enabled) async {
    final currentState = state;
    if (currentState is! ProfileLoaded) return;
    appTalker?.debug('updateNotifications: $enabled');
    await _repository.updateNotificationPreference(enabled);
    final preferences = _repository.getUserPreferences();
    emit(ProfileLoaded(user: currentState.user, preferences: preferences));
  }

  Future<void> signOut() async {
    final result = await _authRepository.signOut();
    result.fold(
      (isSignedOut) {
        if (isSignedOut) {
          emit(ProfileSignedOut());
        }
      },
      (error) {
        emit(ProfileError(error));
      },
    );
  }
}
