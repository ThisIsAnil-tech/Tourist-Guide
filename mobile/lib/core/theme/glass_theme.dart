import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

class GlassTheme {
  final Color tint;
  final Color border;
  final double blurSigma;

  const GlassTheme({
    required this.tint,
    required this.border,
    this.blurSigma = 18,
  });

  static GlassTheme of(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return GlassTheme(
      tint: isDark ? AppColors.glassDarkTint : AppColors.glassLightTint,
      border: isDark ? AppColors.glassBorderDark : AppColors.glassBorderLight,
    );
  }

  static LinearGradient backgroundGradient(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: isDark
          ? [AppColors.gradientDarkStart, AppColors.gradientDarkEnd]
          : [AppColors.gradientLightStart, AppColors.gradientLightEnd],
    );
  }
}