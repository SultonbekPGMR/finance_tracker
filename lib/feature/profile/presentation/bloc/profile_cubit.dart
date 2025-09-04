import 'package:finance_tracker/core/service/notificaion/notification_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/config/talker.dart';
import '../../../../core/di/app_di.dart';
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

  Future<void> loadProfile() async {
    emit(ProfileLoading());
    final preferences = _repository.getUserPreferences();
    final user = await _repository.getCurrentUser();
    emit(ProfileLoaded(user: user, preferences: preferences));
  }

  Future<void> updateDisplayName(String name) async {
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

  Future<void> updateTheme(String theme) async {
    final currentState = state;
    if (currentState is! ProfileLoaded) return;

    await _repository.updateThemePreference(theme);
    await _emitUpdatedPreferences(currentState);
  }

  Future<void> updateLanguage(String language) async {
    final currentState = state;
    if (currentState is! ProfileLoaded) return;

    await _repository.updateLanguagePreference(language);
    await _emitUpdatedPreferences(currentState);
  }

  Future<void> updateCurrency(String currency) async {
    final currentState = state;
    if (currentState is! ProfileLoaded) return;

    await _repository.updateCurrencyPreference(currency);
    await _emitUpdatedPreferences(currentState);
  }

  Future<void> updateNotifications(
    bool enabled,
    String title,
    String body,
  ) async {
    final currentState = state;
    if (currentState is! ProfileLoaded) return;

    if (!enabled) {
      await _updateNotificationPreferenceAndEmit(currentState, enabled);
      return;
    }

    // Only request permission when enabling notifications
    final hasPermission = await _requestNotificationPermission();
    appTalker?.debug('Notification permission result: $hasPermission');

    if (!hasPermission) return;

    await _updateNotificationPreferenceAndEmit(
      currentState,
      enabled,
      title: title,
      body: body,
    );
  }

  Future<bool> _requestNotificationPermission() async {
    final notificationService = get<NotificationService>();

    final permissionResult = await notificationService.requestPermission(true);
    if (permissionResult != PermissionResult.granted) {
      return false;
    }

    final canScheduleExactAlarms =
        await notificationService.canScheduleExactAlarms();
    appTalker?.debug('Exact alarm permission result: $canScheduleExactAlarms');
    if (!canScheduleExactAlarms) {
      await notificationService.openExactAlarmSettings();
      return false;
    }

    return true;
  }

  Future<void> _updateNotificationPreferenceAndEmit(
    ProfileLoaded currentState,
    bool enabled, {
    String? title,
    String? body,
  }) async {
    if (enabled && title != null && body != null) {
      await get<NotificationService>().scheduleDailyExpenseReminder(
        hour: 20,
        minute: 05,
        title: title,
        body: body,
      );
    } else {
      await get<NotificationService>().cancelAllScheduledNotifications();
    }
    await _repository.updateNotificationPreference(enabled);
    await _emitUpdatedPreferences(currentState);
  }

  Future<void> _emitUpdatedPreferences(ProfileLoaded currentState) async {
    final preferences = _repository.getUserPreferences();
    emit(ProfileLoaded(user: currentState.user, preferences: preferences));
  }

  Future<bool> isNotificationEnabled() async =>
      get<NotificationService>().areNotificationsEnabled();

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
