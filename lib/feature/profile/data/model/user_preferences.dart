// Created by Sultonbek Tulanov on 01-September 2025
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

part 'user_preferences.g.dart';

@HiveType(typeId: 0)
class UserPreferences extends HiveObject {
  @HiveField(0)
  String themeMode;

  @HiveField(1)
  String language;

  @HiveField(2)
  String currency;

  @HiveField(3)
  bool notificationsEnabled;

  ThemeMode get appTheme {
    switch (themeMode) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      default:
        return ThemeMode.system;
    }
  }

  Locale get appLocale {
    switch (language) {
      case 'uz':
        return const Locale('uz');
      case 'ru':
        return const Locale('ru');
      default:
        return const Locale('en');
    }
  }

  UserPreferences({
    this.themeMode = 'system',
    this.language = 'en',
    this.currency = 'USD',
    this.notificationsEnabled = true,
  });

  UserPreferences copyWith({
    String? themeMode,
    String? language,
    String? currency,
    bool? notificationsEnabled,
  }) {
    return UserPreferences(
      themeMode: themeMode ?? this.themeMode,
      language: language ?? this.language,
      currency: currency ?? this.currency,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
    );
  }

  @override
  String toString() {
    return 'UserPreferences(themeMode: $themeMode, language: $language, currency: $currency, notificationsEnabled: $notificationsEnabled)';
  }
}
