// Created by Sultonbek Tulanov on 30-August 2025

import 'package:flutter/material.dart';

import '../../l10n/generated/l10n.dart';

extension ThemeExtensions on BuildContext {
  ColorScheme get colorScheme => Theme.of(this).colorScheme;

  TextTheme get textTheme => Theme.of(this).textTheme;

  ThemeData get theme => Theme.of(this);

  AppLocalizations get l10n => AppLocalizations.of(this);

  double get screenWidth => MediaQuery.of(this).size.width;

  double get screenHeight => MediaQuery.of(this).size.height;

  EdgeInsets get padding => MediaQuery.of(this).padding;

  double get statusBarHeight => MediaQuery.of(this).padding.top;

  double get bottomInset => MediaQuery.of(this).padding.bottom;

  double get appBarHeight => kToolbarHeight;
}
