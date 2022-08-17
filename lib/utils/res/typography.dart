import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

const kFontWeightLight = FontWeight.w300;
const kFontWeightRegular = FontWeight.w400;
const kFontWeightMedium = FontWeight.w500;
const kFontWeightBold = FontWeight.w700;

final kFontFamily =
    defaultTargetPlatform == TargetPlatform.android ? 'Robot' : 'San Francisco';

/// https://m3.material.io/styles/typography/tokens
TextTheme get textTheme {
  // https://api.flutter.dev/flutter/painting/TextStyle-class.html
  final style = TextStyle(
    fontFamily: kFontFamily,
    fontWeight: kFontWeightMedium,
    letterSpacing: 0,
    leadingDistribution: TextLeadingDistribution.even,
  );
  return TextTheme(
    displayLarge: style.copyWith(
      fontSize: 57,
      height: 64 / 57,
      fontWeight: kFontWeightBold,
    ),
    displayMedium: style.copyWith(
      fontSize: 45,
      height: 52 / 45,
      fontWeight: kFontWeightBold,
    ),
    displaySmall: style.copyWith(
      fontSize: 36,
      height: 44 / 36,
      fontWeight: kFontWeightBold,
    ),
    headlineLarge: style.copyWith(
      fontSize: 32,
      height: 40 / 32,
      fontWeight: kFontWeightBold,
    ),
    headlineMedium: style.copyWith(
      fontSize: 28,
      height: 36 / 28,
      fontWeight: kFontWeightBold,
    ),
    headlineSmall: style.copyWith(
      fontSize: 24,
      height: 32 / 24,
      fontWeight: kFontWeightBold,
    ),
    titleLarge: style.copyWith(
      fontSize: 22,
      height: 28 / 22,
      fontWeight: kFontWeightBold,
    ),
    titleMedium: style.copyWith(
      fontSize: 16,
      height: 24 / 16,
      letterSpacing: 0.15,
      fontWeight: kFontWeightBold,
    ),
    titleSmall: style.copyWith(
      fontSize: 14,
      height: 20 / 14,
      letterSpacing: 0.1,
      fontWeight: kFontWeightBold,
    ),
    labelLarge: style.copyWith(
      fontSize: 14,
      height: 20 / 14,
      letterSpacing: 0.1,
    ),
    labelMedium: style.copyWith(
      fontSize: 12,
      height: 16 / 16,
      letterSpacing: 0.5,
    ),
    labelSmall: style.copyWith(
      fontSize: 11,
      height: 16 / 11,
      letterSpacing: 0.5,
      fontWeight: kFontWeightBold,
    ),
    bodyLarge: style.copyWith(
      fontSize: 16,
      height: 24 / 16,
      letterSpacing: 0.15,
      fontWeight: kFontWeightRegular,
    ),
    bodyMedium: style.copyWith(
      fontSize: 14,
      height: 20 / 14,
      letterSpacing: 0.25,
      fontWeight: kFontWeightRegular,
    ),
    bodySmall: style.copyWith(
      fontSize: 12,
      height: 16 / 12,
      letterSpacing: 0.4,
      fontWeight: kFontWeightRegular,
    ),
  );
}
