// Created by Sultonbek Tulanov on 31-August 2025
import 'dart:ui';

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

  static ExpenseCategoryModel fromString(String value) {
    return ExpenseCategoryModel.values.firstWhere(
          (category) => category.name == value,
      orElse: () => ExpenseCategoryModel.other,
    );
  }
  static List<ExpenseCategoryModel> get allCategories => ExpenseCategoryModel.values;
}
extension ExpenseCategoryModelExtension on ExpenseCategoryModel {
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
        return const Color(0xFFFF6B6B);
      case ExpenseCategoryModel.transport:
        return const Color(0xFF4ECDC4);
      case ExpenseCategoryModel.entertainment:
        return const Color(0xFFFFE66D);
      case ExpenseCategoryModel.utilities:
        return const Color(0xFF95E1D3);
      case ExpenseCategoryModel.shopping:
        return const Color(0xFFFF8B94);
      case ExpenseCategoryModel.health:
        return const Color(0xFFA8E6CF);
      case ExpenseCategoryModel.education:
        return const Color(0xFF88D8C0);
      case ExpenseCategoryModel.travel:
        return const Color(0xFFFFD93D);
      case ExpenseCategoryModel.home:
        return const Color(0xFFB4A7D6);
      case ExpenseCategoryModel.fitness:
        return const Color(0xFFFFB347);
      case ExpenseCategoryModel.other:
        return const Color(0xFFD3D3D3);
    }
  }
}