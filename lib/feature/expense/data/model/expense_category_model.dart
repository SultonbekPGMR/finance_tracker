// Created by Sultonbek Tulanov on 31-August 2025
import 'dart:ui';

enum ExpenseCategoryModel {
  food('Food'),
  transport('Transport'),
  entertainment('Entertainment'),
  utilities('Utilities'),
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
        return '🏠';
      case ExpenseCategoryModel.other:
        return '📦';
    }
  }

  // Optional: Get color for each category
  Color get color {
    switch (this) {
      case ExpenseCategoryModel.food:
        return const Color(0xFFFF6B6B); // Red
      case ExpenseCategoryModel.transport:
        return const Color(0xFF4ECDC4); // Teal
      case ExpenseCategoryModel.entertainment:
        return const Color(0xFF45B7D1); // Blue
      case ExpenseCategoryModel.utilities:
        return const Color(0xFF96CEB4); // Green
      case ExpenseCategoryModel.other:
        return const Color(0xFFFECA57); // Yellow
    }
  }
}
