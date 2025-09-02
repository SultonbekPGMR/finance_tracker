// Created by Sultonbek Tulanov on 01-September 2025
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finance_tracker/core/util/extension/firebase_auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../../core/config/talker.dart';
import '../../../../core/util/service/preferences_service.dart';
import '../../../auth/data/model/user_model.dart';
import '../../domain/repository/user_repository.dart';

import '../model/user_preferences.dart';

class UserRepositoryImpl implements UserRepository {
  final FirebaseAuth _auth;

  UserRepositoryImpl(this._auth);

  @override
  Future<UserModel?> getCurrentUser() async {
    final firebaseUser = _auth.currentUser;
    if (firebaseUser == null) return null;

    return UserModel(
      firebaseUser.uid,
      firebaseUser.displayName ?? 'User',
      firebaseUser.email ?? '',
    );
  }

  @override
  Future<void> updateUserProfile(String displayName) async {
    final user = _auth.currentUser;
    if (user == null) throw Exception('No authenticated user');

    try {
      await user.updateDisplayName(displayName);
      await user.reload();
    } catch (e) {
      throw Exception('Failed to update profile: $e');
    }
  }


  @override
  Stream<UserModel?> getCurrentUserStream() {
    return _auth.authStateChanges().asyncMap((firebaseUser) async {
      if (firebaseUser == null) return null;
      return await getCurrentUser();
    });
  }

  // Preference methods
  @override
  Future<void> updateThemePreference(String theme) async {
    await PreferencesService.updateTheme(theme);
  }

  @override
  Future<void> updateLanguagePreference(String language) async {
    await PreferencesService.updateLanguage(language);
  }

  @override
  Future<void> updateCurrencyPreference(String currency) async {
    await PreferencesService.updateCurrency(currency);
  }

  @override
  Future<void> updateNotificationPreference(bool enabled) async {
    await PreferencesService.updateNotifications(enabled);
  }

  @override
  UserPreferences getUserPreferences() {
    appTalker?.debug('getUserPreferences: ${PreferencesService.preferences}');
    return PreferencesService.preferences;
  }

  @override
  Future<void> resetPreferences() async {
    await PreferencesService.updatePreferences(UserPreferences());
  }

}
 
