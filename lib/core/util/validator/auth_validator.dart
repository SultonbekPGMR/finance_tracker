// Created by Sultonbek Tulanov on 31-August 2025
import 'package:finance_tracker/core/util/extension/string.dart';

class AuthValidator {
  AuthValidator._();

  static String? validateEmail(String email) {
    if (email.isEmpty) return "Email cannot be empty";
    if (!email.isValidEmail) return "Invalid email format";
    return null;
  }

  static String? validatePassword(String password) {
    if (password.isEmpty) return "Password cannot be empty";
    if (password.length < 6) return "Password must be at least 6 characters";
    return null;
  }
}
