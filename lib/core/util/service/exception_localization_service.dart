// Created by Sultonbek Tulanov on 02-September 2025
// core/services/exception_localization_service.dart
import 'package:finance_tracker/core/config/talker.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:finance_tracker/core/util/extension/build_context.dart';
import '../../navigation/app_router.dart';
import '../exception/localized_exception.dart';

class ExceptionLocalizationService {
  /// Get localized message for any exception using global navigator key
  static String getLocalizedMessage(Exception exception) {
    final context = AppRouter.navigatorKey.currentContext;

    if (context == null) {
      // Fallback to English when context is unavailable
      return _getFallbackMessage(exception);
    }

    return _getLocalizedMessageWithContext(context, exception);
  }

  static String _getLocalizedMessageWithContext(BuildContext context, Exception exception) {
    // If it's already a LocalizedException, use its key
    if (exception is LocalizedException) {
      return _resolveLocalizedExceptionMessage(context, exception);
    }

    // If it's a Firebase exception, map it directly
    if (exception is FirebaseAuthException) {
      return _mapFirebaseAuthExceptionMessage(context, exception);
    }

    return context.l10n.unknownError;
  }

  static String _getFallbackMessage(Exception exception) {
    // Return English messages as fallback when context is unavailable
    if (exception is FirebaseAuthException) {
      switch (exception.code) {
        case 'user-not-found':
          return 'User not found';
        case 'wrong-password':
        case 'invalid-credential':
          return 'Invalid email or password';
        case 'email-already-in-use':
          return 'Email is already in use';
        case 'weak-password':
          return 'Password is too weak';
        case 'too-many-requests':
          return 'Too many requests. Please try again later';
        case 'network-request-failed':
          return 'No internet connection';
        case 'user-disabled':
          return 'This account has been disabled';
        case 'operation-not-allowed':
          return 'This operation is not allowed';
        case 'invalid-email':
          return 'Invalid email address';
        default:
          return 'Authentication error occurred';
      }
    }

    if (exception is LocalizedException) {
      return _getFallbackForLocalizedKey(exception.localizationKey, exception.params ?? {});
    }

    return 'An unknown error occurred';
  }

  static String _getFallbackForLocalizedKey(String key, Map<String, dynamic> params) {
    switch (key) {
      case 'invalidCredentials':
        return 'Invalid email or password';
      case 'weakPassword':
        return 'Password is too weak';
      case 'emailAlreadyInUse':
        return 'Email is already in use';
      case 'userNotFound':
        return 'User not found';
      case 'noInternetConnection':
        return 'No internet connection';
      case 'serverError':
        return 'Server error occurred';
      case 'connectionTimeout':
        return 'Connection timeout';
      case 'expenseNotFound':
        return 'Expense not found';
      case 'invalidAmount':
        final amount = params['amount']?.toString() ?? '';
        return 'Invalid amount: $amount';
      case 'categoryNotFound':
        return 'Category not found';
      case 'storageError':
        return 'Storage error occurred';
      case 'permissionDenied':
        return 'Permission denied';
      case 'unknownError':
        final error = params['error']?.toString() ?? '';
        return 'Unknown error: $error';
      default:
        return 'Error';
    }
  }

  static String _resolveLocalizedExceptionMessage(
      BuildContext context,
      LocalizedException exception,
      ) {
    return _resolveLocalizedKey(
      context,
      exception.localizationKey,
      exception.params ?? {},
    );
  }

  static String _resolveLocalizedKey(
      BuildContext context,
      String key,
      Map<String, dynamic> params,
      ) {
    switch (key) {
      case 'invalidCredentials':
        return context.l10n.invalidCredentials;
      case 'weakPassword':
        return context.l10n.weakPassword;
      case 'emailAlreadyInUse':
        return context.l10n.emailAlreadyInUse;
      case 'userNotFound':
        return context.l10n.userNotFound;
      case 'noInternetConnection':
        return context.l10n.noInternetConnection;
      case 'serverError':
        return context.l10n.serverError;
      case 'connectionTimeout':
        return context.l10n.connectionTimeout;
      case 'expenseNotFound':
        return context.l10n.expenseNotFound;
      case 'invalidAmount':
        final amount = params['amount']?.toString() ?? '';
        return context.l10n.invalidAmountWithValue(amount);
      case 'categoryNotFound':
        return context.l10n.categoryNotFound;
      case 'storageError':
        return context.l10n.storageError;
      case 'permissionDenied':
        return context.l10n.permissionDenied;
      case 'unknownError':
        final error = params['error']?.toString() ?? '';
        return context.l10n.unknownErrorWithDetails(error);
      default:
        return context.l10n.error;
    }
  }

  static String _mapFirebaseAuthExceptionMessage(
      BuildContext context,
      FirebaseAuthException exception,
      ) {
    appTalker?.debug(exception);
    switch (exception.code) {
      case 'user-not-found':
        return context.l10n.userNotFound;
      case 'wrong-password':
        return context.l10n.invalidPassword;
      case 'invalid-credential':
        return context.l10n.invalidCredentials;
      case 'email-already-in-use':
        return context.l10n.emailAlreadyInUse;
      case 'weak-password':
        return context.l10n.weakPassword;
      case 'too-many-requests':
        return context.l10n.tooManyRequests;
      case 'network-request-failed':
        return context.l10n.noInternetConnection;
      case 'user-disabled':
        return context.l10n.userDisabled;
      case 'operation-not-allowed':
        return context.l10n.operationNotAllowed;
      case 'invalid-email':
        return context.l10n.invalidEmail;
      default:
        return context.l10n.authenticationError;
    }
  }
}