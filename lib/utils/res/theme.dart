import 'package:flutter/material.dart';
import 'package:reversi_battle/utils/res/res.dart';

/// https://flutter.dev/docs/release/breaking-changes/theme-data-accent-properties#migration-guide
ThemeData appThemeLight() {
  final theme =
      ThemeData.from(colorScheme: lightColorScheme, textTheme: textTheme);
  // return theme.copyWith(useMaterial3: true);
  return theme;
}

ThemeData appThemeDark() {
  final theme =
      ThemeData.from(colorScheme: darkColorScheme, textTheme: textTheme);
  // return theme.copyWith(useMaterial3: true);
  return theme;
}
