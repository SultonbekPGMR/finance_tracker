// Created by Sultonbek Tulanov on 02-September 2025

abstract class LocalizedException implements Exception {
  String get localizationKey;
  Map<String, dynamic>? get params => null;
}

// Authentication exceptions
class InvalidCredentialsException extends LocalizedException {
  @override
  String get localizationKey => 'invalidCredentials';
}

class WeakPasswordException extends LocalizedException {
  @override
  String get localizationKey => 'weakPassword';
}

class EmailAlreadyInUseException extends LocalizedException {
  @override
  String get localizationKey => 'emailAlreadyInUse';
}

class UserNotFoundException extends LocalizedException {
  @override
  String get localizationKey => 'userNotFound';
}

// Network exceptions
class NoInternetException extends LocalizedException {
  @override
  String get localizationKey => 'noInternetConnection';
}

class ServerException extends LocalizedException {
  @override
  String get localizationKey => 'serverError';
}

class TimeoutException extends LocalizedException {
  @override
  String get localizationKey => 'connectionTimeout';
}

// Expense related exceptions
class ExpenseNotFoundException extends LocalizedException {
  @override
  String get localizationKey => 'expenseNotFound';
}

class InvalidAmountException extends LocalizedException {
  final double amount;

  InvalidAmountException(this.amount);

  @override
  String get localizationKey => 'invalidAmount';

  @override
  Map<String, dynamic> get params => {'amount': amount};
}

class CategoryNotFoundException extends LocalizedException {
  @override
  String get localizationKey => 'categoryNotFound';
}

// Storage exceptions
class StorageException extends LocalizedException {
  @override
  String get localizationKey => 'storageError';
}

class PermissionDeniedException extends LocalizedException {
  @override
  String get localizationKey => 'permissionDenied';
}

// Generic exception for unknown errors
class UnknownException extends LocalizedException {
  final String originalMessage;

  UnknownException(this.originalMessage);

  @override
  String get localizationKey => 'unknownError';

  @override
  Map<String, dynamic> get params => {'error': originalMessage};
}