// Created by Sultonbek Tulanov on 01-September 2025
import '../../../auth/data/model/user_model.dart';
import '../../data/model/user_preferences.dart';
abstract class UserRepository {
  Future<UserModel?> getCurrentUser();
  Future<void> updateUserProfile(String displayName);
  Stream<UserModel?> getCurrentUserStream();

  // Preference methods
  Future<void> updateThemePreference(String theme);
  Future<void> updateLanguagePreference(String language);
  Future<void> updateCurrencyPreference(String currency);
  Future<void> updateNotificationPreference(bool enabled);
  UserPreferences getUserPreferences();
  Future<void> resetPreferences();
}
