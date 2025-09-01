// Created by Sultonbek Tulanov on 01-September 2025
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';

import '../../../feature/profile/data/model/user_preferences.dart';

class PreferencesService {
  static const String _boxName = 'preferences';
  static const String _key = 'user_preferences';

  static Box<UserPreferences>? _box;

  static Future<void> init() async {
    await Hive.initFlutter();
    Hive.registerAdapter(UserPreferencesAdapter());
    _box = await Hive.openBox<UserPreferences>(_boxName);
  }

  static UserPreferences get preferences =>
      _box?.get(_key) ?? UserPreferences();

  static Future<void> updatePreferences(UserPreferences prefs) async {
    await _box?.put(_key, prefs);
  }

  static Future<void> updateTheme(String theme) async {
    final current = preferences;
    current.themeMode = theme;
    await updatePreferences(current);
  }

  static Future<void> updateLanguage(String language) async {
    final current = preferences;
    current.language = language;
    await updatePreferences(current);
  }

  static Future<void> updateCurrency(String currency) async {
    final current = preferences;
    current.currency = currency;
    await updatePreferences(current);
  }

  static Future<void> updateNotifications(bool enabled) async {
    final current = preferences;
    current.notificationsEnabled = enabled;
    await updatePreferences(current);
  }

  static ThemeMode get themeMode {
    switch (preferences.themeMode) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      default:
        return ThemeMode.system;
    }
  }

  static Locale get locale {
    return Locale(preferences.language);
  }

  static Future<void> resetToDefaults() async {
    await updatePreferences(UserPreferences());
  }

  static Future<void> clearAllPreferences() async {
    await _box?.clear();
  }

  static bool get isInitialized => _box != null;
}