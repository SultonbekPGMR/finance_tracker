// Created by Sultonbek Tulanov on 30-August 2025

import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// The [AppTheme] defines light and dark themes for the app.
///
/// Theme setup for FlexColorScheme package v8.
/// Use same major flex_color_scheme package version. If you use a
/// lower minor version, some properties may not be supported.
/// In that case, remove them after copying this theme to your
/// app or upgrade the package to version 8.3.0.
///
/// Use it in a [MaterialApp] like this:
///
/// MaterialApp(
///   theme: AppTheme.light,
///   darkTheme: AppTheme.dark,
/// );
abstract final class AppTheme {
  static ThemeData light = FlexThemeData.light(
    scheme: FlexScheme.yellowM3,
    textTheme: appTextTheme,
    subThemesData: const FlexSubThemesData(
      inputDecoratorIsFilled: true,
      alignedDropdown: true,
      tooltipRadius: 4,
      tooltipSchemeColor: SchemeColor.inverseSurface,
      tooltipOpacity: 0.9,
      snackBarElevation: 6,
      snackBarBackgroundSchemeColor: SchemeColor.inverseSurface,
      navigationRailUseIndicator: true,
    ),
    keyColors: const FlexKeyColors(),
    visualDensity: FlexColorScheme.comfortablePlatformDensity,
    cupertinoOverrideTheme: const CupertinoThemeData(applyThemeToAll: true),
  );

  static ThemeData dark = FlexThemeData.dark(
    scheme: FlexScheme.yellowM3,
    textTheme: appTextTheme,
    subThemesData: const FlexSubThemesData(
      blendOnColors: true,
      inputDecoratorIsFilled: true,
      alignedDropdown: true,
      tooltipRadius: 4,
      tooltipSchemeColor: SchemeColor.inverseSurface,
      tooltipOpacity: 0.9,
      snackBarElevation: 6,
      snackBarBackgroundSchemeColor: SchemeColor.inverseSurface,
      navigationRailUseIndicator: true,
    ),
    keyColors: const FlexKeyColors(),
    visualDensity: FlexColorScheme.comfortablePlatformDensity,
    cupertinoOverrideTheme: const CupertinoThemeData(applyThemeToAll: true),
  );
}
final appTextTheme = TextTheme(
  displayLarge: GoogleFonts.schibstedGrotesk(
    fontSize: 48,
    fontWeight: FontWeight.w600,
  ),
  displayMedium: GoogleFonts.schibstedGrotesk(
    fontSize: 34,
    fontWeight: FontWeight.w600,
  ),
  displaySmall: GoogleFonts.schibstedGrotesk(
    fontSize: 28,
    fontWeight: FontWeight.w600,
  ),
  headlineLarge: GoogleFonts.schibstedGrotesk(
    fontSize: 24,
    fontWeight: FontWeight.w700,
  ),
  headlineMedium: GoogleFonts.schibstedGrotesk(
    fontSize: 20,
    fontWeight: FontWeight.w700,
  ),
  headlineSmall: GoogleFonts.schibstedGrotesk(
    fontSize: 18,
    fontWeight: FontWeight.w700,
  ),
  titleLarge: GoogleFonts.schibstedGrotesk(
    fontSize: 16,
    fontWeight: FontWeight.w600,
  ),
  titleMedium: GoogleFonts.schibstedGrotesk(
    fontSize: 14,
    fontWeight: FontWeight.w500,
  ),
  titleSmall: GoogleFonts.schibstedGrotesk(
    fontSize: 12,
    fontWeight: FontWeight.w500,
  ),
  bodyLarge: GoogleFonts.schibstedGrotesk(
    fontSize: 16,
    fontWeight: FontWeight.w400,
  ),
  bodyMedium: GoogleFonts.schibstedGrotesk(
    fontSize: 14,
    fontWeight: FontWeight.w400,
  ),
  bodySmall: GoogleFonts.hankenGrotesk(
    fontSize: 12,
    fontWeight: FontWeight.w400,
  ),
  labelLarge: GoogleFonts.schibstedGrotesk(
    fontSize: 14,
    fontWeight: FontWeight.w500,
  ),
  labelMedium: GoogleFonts.schibstedGrotesk(
    fontSize: 12,
    fontWeight: FontWeight.w500,
  ),
  labelSmall: GoogleFonts.schibstedGrotesk(
    fontSize: 11,
    fontWeight: FontWeight.w500,
  ),
);