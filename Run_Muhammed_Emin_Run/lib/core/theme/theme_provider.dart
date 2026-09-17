import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../services/shared_prefs_service.dart';

class ThemeProvider extends ChangeNotifier {
  String _currentTheme = 'classic';
  
  String get currentTheme => _currentTheme;

  ThemeProvider() {
    _currentTheme = SharedPrefsService.currentTheme;
    _applyTheme(_currentTheme);
  }

  void setTheme(String themeId) {
    _currentTheme = themeId;
    SharedPrefsService.setCurrentTheme(themeId);
    _applyTheme(themeId);
    notifyListeners();
  }

  void _applyTheme(String themeId) {
    switch (themeId) {
      case 'dark':
        AppColors.background = const Color(0xFF1E1E24);
        AppColors.surface = const Color(0xFF2B2B36);
        AppColors.primary = const Color(0xFFF9A03F); // Gold/Orange
        AppColors.primaryShadow = const Color(0xFFD67E28);
        AppColors.secondary = const Color(0xFF4A4E69);
        AppColors.secondaryShadow = const Color(0xFF22223B);
        AppColors.textMain = const Color(0xFFF2E9E4);
        AppColors.textLight = const Color(0xFF9A8C98);
        break;
      case 'neon':
        AppColors.background = const Color(0xFF0D0D1A);
        AppColors.surface = const Color(0xFF1A1A2E);
        AppColors.primary = const Color(0xFF00FFCC); // Neon Cyan
        AppColors.primaryShadow = const Color(0xFF00B38F);
        AppColors.secondary = const Color(0xFFFF007F); // Neon Pink
        AppColors.secondaryShadow = const Color(0xFFCC0066);
        AppColors.textMain = Colors.white;
        AppColors.textLight = const Color(0xFFB0B0C0);
        break;
      case 'retro':
        AppColors.background = const Color(0xFFF4ECD8); // Cream
        AppColors.surface = const Color(0xFFEBE1C5);
        AppColors.primary = const Color(0xFFD93829); // Retro Red
        AppColors.primaryShadow = const Color(0xFFA1251A);
        AppColors.secondary = const Color(0xFF4A7C59); // Muted Green
        AppColors.secondaryShadow = const Color(0xFF33583E);
        AppColors.textMain = const Color(0xFF3A332C);
        AppColors.textLight = const Color(0xFF8C8074);
        break;
      case 'classic':
      default:
        AppColors.background = const Color(0xFFE5F0FF); 
        AppColors.surface = Colors.white;
        AppColors.primary = const Color(0xFF58CC02); 
        AppColors.primaryShadow = const Color(0xFF58A700);
        AppColors.secondary = const Color(0xFF1CB0F6); 
        AppColors.secondaryShadow = const Color(0xFF1899D6);
        AppColors.textMain = const Color(0xFF4B4B4B);
        AppColors.textLight = const Color(0xFFAFAFAF);
        break;
    }
  }
}
