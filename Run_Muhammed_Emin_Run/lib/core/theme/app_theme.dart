import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/app_colors.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: AppColors.background,
      colorScheme: ColorScheme.light(
        primary: AppColors.primary,
        secondary: AppColors.secondary,
        surface: AppColors.surface,
      ),
      textTheme: GoogleFonts.nunitoTextTheme().copyWith(
        displayLarge: GoogleFonts.nunito(
          fontWeight: FontWeight.w900,
          color: AppColors.textMain,
        ),
        bodyLarge: GoogleFonts.nunito(
          fontSize: 18,
          color: AppColors.textMain,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

// Helper widget for Duolingo style thick buttons
class FlatThickButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color color;
  final Color shadowColor;
  final Color textColor;

  const FlatThickButton({
    super.key,
    required this.text,
    required this.onPressed,
    required this.color,
    required this.shadowColor,
    this.textColor = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(16),
          border: Border(
            bottom: BorderSide(
              color: shadowColor,
              width: 5,
            ),
          ),
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              color: textColor,
              fontSize: 20,
              fontWeight: FontWeight.w900,
              letterSpacing: 1.2,
            ),
          ),
        ),
      ),
    );
  }
}
