import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_text_styles.dart';

class AppTheme {
  AppTheme._();

  static ThemeData get light => ThemeData(
        brightness: Brightness.light,
        scaffoldBackgroundColor: AppColors.lightBg,
        primaryColor: AppColors.primary,
        fontFamily: '.SF Pro Text',
        colorScheme: const ColorScheme.light(
          primary: AppColors.primary,
          secondary: AppColors.accent,
          error: AppColors.danger,
          surface: AppColors.lightSurface,
        ),
        textTheme: const TextTheme(
          headlineLarge: AppTextStyles.largeTitle,
          headlineMedium: AppTextStyles.title1,
          headlineSmall: AppTextStyles.title2,
          titleMedium: AppTextStyles.headline,
          bodyLarge: AppTextStyles.body,
          bodyMedium: AppTextStyles.subhead,
          labelSmall: AppTextStyles.caption,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
          foregroundColor: AppColors.lightText,
        ),
      );

  static ThemeData get dark => ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: AppColors.darkBg,
        primaryColor: AppColors.primary,
        fontFamily: '.SF Pro Text',
        colorScheme: const ColorScheme.dark(
          primary: AppColors.primary,
          secondary: AppColors.accent,
          error: AppColors.danger,
          surface: AppColors.darkSurface,
        ),
        textTheme: const TextTheme(
          headlineLarge: AppTextStyles.largeTitle,
          headlineMedium: AppTextStyles.title1,
          headlineSmall: AppTextStyles.title2,
          titleMedium: AppTextStyles.headline,
          bodyLarge: AppTextStyles.body,
          bodyMedium: AppTextStyles.subhead,
          labelSmall: AppTextStyles.caption,
        ).apply(bodyColor: AppColors.darkText, displayColor: AppColors.darkText),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
          foregroundColor: AppColors.darkText,
        ),
      );
}