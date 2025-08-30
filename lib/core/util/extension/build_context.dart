// Created by Sultonbek Tulanov on 30-August 2025

import 'package:flutter/material.dart';

import '../../l10n/generated/l10n.dart';

extension ThemeExtensions on BuildContext {
  ColorScheme get colorScheme => Theme.of(this).colorScheme;

  TextTheme get textTheme => Theme.of(this).textTheme;

  ThemeData get theme => Theme.of(this);

  AppLocalizations? get l10n => AppLocalizations.of(this);
}
