// Created by Sultonbek Tulanov on 31-August 2025
extension EmailValidator on String {
  bool get isValidEmail {
    // Basic email regex pattern
    final regex = RegExp(
      r'^[\w-.]+@([\w-]+\.)+[\w-]{2,}$',
    );
    return regex.hasMatch(this);
  }
  String get firstLetter =>
      isNotEmpty ? substring(0, 1).toUpperCase() : '?';
}

 
