// Created by Sultonbek Tulanov on 31-August 2025

import 'package:flutter/cupertino.dart';

import '../../../../core/l10n/generated/l10n.dart';

enum ExpenseCategoryModel {
  food('Food'),
  transport('Transport'),
  entertainment('Entertainment'),
  utilities('Utilities'),
  shopping('Shopping'),
  health('Health'),
  education('Education'),
  travel('Travel'),
  home('Home'),
  fitness('Fitness'),
  other('Other');

  const ExpenseCategoryModel(this.displayName);

  final String displayName;

  static ExpenseCategoryModel fromName(String value) {
    return ExpenseCategoryModel.values.firstWhere(
      (category) => category.name == value,
      orElse: () => ExpenseCategoryModel.other,
    );
  }

  static ExpenseCategoryModel fromDisplayName(String displayName) {
    return ExpenseCategoryModel.values.firstWhere(
          (category) => category.displayName == displayName,
      orElse: () => ExpenseCategoryModel.other,
    );
  }
  static List<ExpenseCategoryModel> get allCategories =>
      ExpenseCategoryModel.values;
}

extension ExpenseCategoryModelExtension on ExpenseCategoryModel {
  String getLocalizedName(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    switch (this) {
      case ExpenseCategoryModel.food:
        return l10n.categoryFood;
      case ExpenseCategoryModel.transport:
        return l10n.categoryTransport;
      case ExpenseCategoryModel.entertainment:
        return l10n.categoryEntertainment;
      case ExpenseCategoryModel.utilities:
        return l10n.categoryUtilities;
      case ExpenseCategoryModel.shopping:
        return l10n.categoryShopping;
      case ExpenseCategoryModel.health:
        return l10n.categoryHealth;
      case ExpenseCategoryModel.education:
        return l10n.categoryEducation;
      case ExpenseCategoryModel.travel:
        return l10n.categoryTravel;
      case ExpenseCategoryModel.home:
        return l10n.categoryHome;
      case ExpenseCategoryModel.fitness:
        return l10n.categoryFitness;
      case ExpenseCategoryModel.other:
        return l10n.categoryOther;
    }
  }

  String get icon {
    switch (this) {
      case ExpenseCategoryModel.food:
        return '🍽️';
      case ExpenseCategoryModel.transport:
        return '🚗';
      case ExpenseCategoryModel.entertainment:
        return '🎬';
      case ExpenseCategoryModel.utilities:
        return '⚡';
      case ExpenseCategoryModel.shopping:
        return '🛍️';
      case ExpenseCategoryModel.health:
        return '💊';
      case ExpenseCategoryModel.education:
        return '📚';
      case ExpenseCategoryModel.travel:
        return '✈️';
      case ExpenseCategoryModel.home:
        return '🏠';
      case ExpenseCategoryModel.fitness:
        return '💪';
      case ExpenseCategoryModel.other:
        return '📦';
    }
  }

  Color get color {
    switch (this) {
      case ExpenseCategoryModel.food:
        return const Color(0xFFE74C3C); // Red → appetite, food
      case ExpenseCategoryModel.transport:
        return const Color(0xFF2980B9); // Blue → roads, travel
      case ExpenseCategoryModel.entertainment:
        return const Color(0xFFF1C40F); // Yellow → fun, energy
      case ExpenseCategoryModel.utilities:
        return const Color(0xFF16A085); // Teal → water/electricity
      case ExpenseCategoryModel.shopping:
        return const Color(0xFF9B59B6); // Purple → retail, fashion
      case ExpenseCategoryModel.health:
        return const Color(0xFF27AE60); // Green → health, wellness
      case ExpenseCategoryModel.education:
        return const Color(0xFF34495E); // Dark Blue → knowledge
      case ExpenseCategoryModel.travel:
        return const Color(0xFFD35400); // Orange → adventure
      case ExpenseCategoryModel.home:
        return const Color(0xFF8E44AD); // Violet → stability
      case ExpenseCategoryModel.fitness:
        return const Color(0xFFE67E22); // Bright Orange → activity
      case ExpenseCategoryModel.other:
        return const Color(0xFF7F8C8D); // Gray → neutral
    }
  }
}
