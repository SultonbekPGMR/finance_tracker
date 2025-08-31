// Created by Sultonbek Tulanov on 31-August 2025
import 'package:finance_tracker/core/util/extension/build_context.dart';
import 'package:flutter/material.dart';

import '../../config/talker.dart';
import '../../presentation/navigation/app_router.dart';

class MessageService {
  static final GlobalKey<NavigatorState> navigatorKey = AppRouter.navigatorKey;

  static void showError(String message) {
    final context = navigatorKey.currentContext;
    appTalker?.log(context == null);
    if (context == null) return;

    showDialog(
      context: context,
      builder:
          (BuildContext dialogContext) => AlertDialog(
            backgroundColor: dialogContext.colorScheme.surfaceContainerHigh,
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
                color: dialogContext.colorScheme.error,
                fontWeight: FontWeight.w600,
              ),
            ),
            content: Text(
              message,
              style: dialogContext.textTheme.bodyMedium?.copyWith(
                color: dialogContext.colorScheme.onErrorContainer,
              ),
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
      builder:
          (BuildContext dialogContext) => AlertDialog(
            backgroundColor: dialogContext.colorScheme.primaryContainer,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            icon: Icon(
              Icons.check_circle_outline,
              color: dialogContext.colorScheme.primary,
              size: 32,
            ),
            title: Text(
              dialogContext.l10n.success,
              style: dialogContext.textTheme.titleLarge?.copyWith(
                color: dialogContext.colorScheme.onPrimaryContainer,
                fontWeight: FontWeight.w600,
              ),
            ),
            content: Text(
              message,
              style: dialogContext.textTheme.bodyMedium?.copyWith(
                color: dialogContext.colorScheme.onPrimaryContainer,
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

  static void showWarning(String message) {
    final context = navigatorKey.currentContext;
    if (context == null) return;

    showDialog(
      context: context,
      builder:
          (BuildContext dialogContext) => AlertDialog(
            backgroundColor: dialogContext.colorScheme.tertiaryContainer,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            icon: Icon(
              Icons.warning_outlined,
              color: dialogContext.colorScheme.tertiary,
              size: 32,
            ),
            title: Text(
              dialogContext.l10n.warning,
              style: dialogContext.textTheme.titleLarge?.copyWith(
                color: dialogContext.colorScheme.onTertiaryContainer,
                fontWeight: FontWeight.w600,
              ),
            ),
            content: Text(
              message,
              style: dialogContext.textTheme.bodyMedium?.copyWith(
                color: dialogContext.colorScheme.onTertiaryContainer,
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(dialogContext).pop(),
                style: TextButton.styleFrom(
                  foregroundColor: dialogContext.colorScheme.tertiary,
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
      builder:
          (BuildContext dialogContext) => AlertDialog(
            backgroundColor: dialogContext.colorScheme.surfaceContainer,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            icon: Icon(
              Icons.info_outline,
              color: dialogContext.colorScheme.primary,
              size: 32,
            ),
            title: Text(
              dialogContext.l10n.info,
              style: dialogContext.textTheme.titleLarge?.copyWith(
                color: dialogContext.colorScheme.onSurface,
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
