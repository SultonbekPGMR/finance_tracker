// Created by Sultonbek Tulanov on 31-August 2025

import 'package:finance_tracker/core/util/extension/build_context.dart';
import 'package:flutter/material.dart';

import '../config/talker.dart';
import '../navigation/app_router.dart';

class MessageService {
  static final GlobalKey<NavigatorState> navigatorKey = AppRouter.navigatorKey;

  static void showError(String message) {
    final context = navigatorKey.currentContext;
    appTalker?.log(context == null);
    if (context == null) return;

    showDialog(
      context: context,
      builder: (BuildContext dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        icon: Icon(
          Icons.error_outline,
          color: dialogContext.colorScheme.error,
          size: 32,
        ),
        title: Text(
          dialogContext.l10n.error,
          style: dialogContext.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        content: Text(
          message,
          style: dialogContext.textTheme.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            style: TextButton.styleFrom(
              foregroundColor: dialogContext.colorScheme.error,
            ),
            child: Text(
              dialogContext.l10n.ok,
              style: dialogContext.textTheme.labelLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  static void showSuccess(String message) {
    final context = navigatorKey.currentContext;
    if (context == null) return;

    showDialog(
      context: context,
      builder: (BuildContext dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        icon: Icon(
          Icons.check_circle_outline,
          color: Colors.green,
          size: 32,
        ),
        title: Text(
          dialogContext.l10n.success,
          style: dialogContext.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        content: Text(
          message,
          style: dialogContext.textTheme.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            style: TextButton.styleFrom(
              foregroundColor: Colors.green,
            ),
            child: Text(
              dialogContext.l10n.ok,
              style: dialogContext.textTheme.labelLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  static void showWarning(String message) {
    final context = navigatorKey.currentContext;
    if (context == null) return;

    showDialog(
      context: context,
      builder: (BuildContext dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        icon: Icon(
          Icons.warning_outlined,
          color: Colors.orange,
          size: 32,
        ),
        title: Text(
          dialogContext.l10n.warning,
          style: dialogContext.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        content: Text(
          message,
          style: dialogContext.textTheme.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            style: TextButton.styleFrom(
              foregroundColor: Colors.orange,
            ),
            child: Text(
              dialogContext.l10n.ok,
              style: dialogContext.textTheme.labelLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  static void showInfo(String message) {
    final context = navigatorKey.currentContext;
    if (context == null) return;

    showDialog(
      context: context,
      builder: (BuildContext dialogContext) => AlertDialog(
        backgroundColor: dialogContext.colorScheme.surfaceContainerHighest.withOpacity(0.3),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(
            color: dialogContext.colorScheme.outline.withOpacity(0.2),
            width: 1,
          ),
        ),
        icon: Icon(
          Icons.info_outline,
          color: dialogContext.colorScheme.primary,
          size: 32,
        ),
        title: Text(
          dialogContext.l10n.info,
          style: dialogContext.textTheme.titleLarge?.copyWith(
            color: dialogContext.colorScheme.primary,
            fontWeight: FontWeight.w600,
          ),
        ),
        content: Text(
          message,
          style: dialogContext.textTheme.bodyMedium?.copyWith(
            color: dialogContext.colorScheme.onSurface,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            style: TextButton.styleFrom(
              foregroundColor: dialogContext.colorScheme.primary,
            ),
            child: Text(
              dialogContext.l10n.ok,
              style: dialogContext.textTheme.labelLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}