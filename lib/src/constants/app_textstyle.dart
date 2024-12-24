import 'package:flutter/material.dart';

import 'app_colors.dart';

MyTextTheme textTheme(BuildContext context) =>
    MyTextTheme.fromTheme(Theme.of(context).textTheme);

extension TextColors on TextStyle {
  TextStyle get primary => copyWith(color: AppColors.textPrimary);

  TextStyle get secondary => copyWith(color: AppColors.textSecondary);

  TextStyle get subtitle => copyWith(color: AppColors.textSubtitle);

  TextStyle get accent => copyWith(color: AppColors.textAccent);

  TextStyle get cta => copyWith(color: AppColors.textCta);

  TextStyle get fixedWhite => copyWith(color: AppColors.textFixedWhite);

  TextStyle get fixedBlack => copyWith(color: AppColors.textFixedBlack);
}

extension Weight on TextStyle {
  TextStyle get bold => copyWith(fontWeight: FontWeight.bold);

  TextStyle get semiBold => copyWith(fontWeight: FontWeight.w600);

  TextStyle get regular => copyWith(fontWeight: FontWeight.normal);

  TextStyle get light => copyWith(fontWeight: FontWeight.w300);
}

class MyTextTheme extends TextTheme {
  MyTextTheme.fromTheme(TextTheme t)
      : super(
          titleSmall: t.titleSmall!,
          titleMedium: t.titleMedium!,
          titleLarge: t.titleLarge!,
          labelSmall: t.labelSmall!,
          labelMedium: t.labelMedium!,
          labelLarge: t.labelLarge!,
          bodySmall: t.bodySmall!,
          bodyMedium: t.bodyMedium!,
          bodyLarge: t.bodyLarge!,
          headlineSmall: t.headlineSmall!,
          headlineMedium: t.headlineMedium!,
          headlineLarge: t.headlineLarge!,
          displaySmall: t.displaySmall!,
          displayMedium: t.displayMedium!,
          displayLarge: t.displayLarge!,
        );

  @override
  TextStyle get displayLarge => super.displayLarge!;

  @override
  TextStyle get displayMedium => super.displayMedium!;

  @override
  TextStyle get displaySmall => super.displaySmall!;

  @override
  TextStyle get headlineLarge => super.headlineLarge!;

  @override
  TextStyle get headlineMedium => super.headlineMedium!;

  @override
  TextStyle get headlineSmall => super.headlineSmall!;

  @override
  TextStyle get bodyLarge => super.bodyLarge!;

  @override
  TextStyle get bodyMedium => super.bodyMedium!;

  @override
  TextStyle get bodySmall => super.bodySmall!;

  @override
  TextStyle get labelLarge => super.labelLarge!;

  @override
  TextStyle get labelMedium => super.labelMedium!;

  @override
  TextStyle get labelSmall => super.labelSmall!;

  @override
  TextStyle get titleLarge => super.titleLarge!;

  TextStyle get titleLargeBold => super.titleLarge!.copyWith(
        fontWeight: FontWeight.bold,
      );

  @override
  TextStyle get titleMedium => super.titleMedium!;

  @override
  TextStyle get titleSmall => super.titleSmall!;

  TextStyle get titleSmallBold =>
      titleSmall.copyWith(fontWeight: FontWeight.bold);

  TextStyle get titleMediumBold =>
      titleMedium.copyWith(fontWeight: FontWeight.bold);

  TextStyle get buttonLarge => bodyLarge.copyWith(
        color: AppColors.textCta,
        fontWeight: FontWeight.bold,
        fontSize: 16.0,
      );

  TextStyle get buttonMedium => bodyMedium.copyWith(
        color: AppColors.textCta,
        fontWeight: FontWeight.bold,
        fontSize: 13.0,
      );
}
