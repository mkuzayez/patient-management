// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';

extension ThemeExtensions on BuildContext {
  ColorScheme get colorScheme => Theme.of(this).colorScheme;

  ThemeData get theme => Theme.of(this);

  TextTheme get textTheme => Theme.of(this).textTheme;

  Color get primaryColor => colorScheme.primary;

  Color get onPrimaryColor => colorScheme.onPrimary;

  Color get secondary => colorScheme.secondary;

  Color get onSecondary => colorScheme.onSecondary;

  Color get surface => colorScheme.surface;

  Color get onSurface => colorScheme.onSurface;

  Color get background => colorScheme.background;

  Color get onBackground => colorScheme.onBackground;

  Color get error => colorScheme.error;

  Color get onError => colorScheme.onError;

  Color get shadow => colorScheme.shadow;

  Color get outLine => colorScheme.outline;

  Color get inverse => colorScheme.inversePrimary;

  Color get primaryContainer => colorScheme.primaryContainer;

  Color get onPrimaryContainer => colorScheme.onPrimaryContainer;

  Color get secondaryContainer => colorScheme.secondaryContainer;

  Color get onSecondaryContainer => colorScheme.onSecondaryContainer;

  Color get surfaceContainer => colorScheme.surfaceContainer;

  Color get onTertiary => colorScheme.onTertiary;

  DefaultTextStyle get defaultTextStyle => DefaultTextStyle.of(this);
}
