import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';

abstract final class AppTheme {
  static ThemeData get light => ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: AppColors.cream,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.forest,
          brightness: Brightness.light,
        ),
        textTheme: const TextTheme(
          headlineLarge: TextStyle(
            color: AppColors.forest,
            fontSize: 48,
            fontWeight: FontWeight.w700,
            height: 1.06,
          ),
          headlineMedium: TextStyle(
            color: AppColors.forest,
            fontSize: 32,
            fontWeight: FontWeight.w700,
          ),
          titleLarge: TextStyle(color: AppColors.forest, fontWeight: FontWeight.w700),
          bodyMedium: TextStyle(color: AppColors.ink, height: 1.5),
        ),
      );
}
