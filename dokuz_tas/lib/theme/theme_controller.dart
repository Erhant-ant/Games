import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum BoardTheme {
  islamicWood,
  antiqueMarble,
  neonCyberpunk
}

class ThemeController extends ChangeNotifier {
  static final ThemeController _instance = ThemeController._internal();
  factory ThemeController() => _instance;
  ThemeController._internal();
  
  BoardTheme _currentTheme = BoardTheme.islamicWood;

  BoardTheme get currentTheme => _currentTheme;

  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    
    // Load board theme
    final themeIndex = prefs.getInt('board_theme');
    if (themeIndex != null && themeIndex >= 0 && themeIndex < BoardTheme.values.length) {
      _currentTheme = BoardTheme.values[themeIndex];
    }
    
    notifyListeners();
  }

  void setTheme(BoardTheme theme) async {
    if (_currentTheme != theme) {
      _currentTheme = theme;
      notifyListeners();
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt('board_theme', theme.index);
    }
  }

  String get whiteStoneImage {
    switch (_currentTheme) {
      case BoardTheme.islamicWood:
        return 'assets/images/white_stone.jpg';
      case BoardTheme.antiqueMarble:
        return 'assets/images/marble_white.jpg';
      case BoardTheme.neonCyberpunk:
        return 'assets/images/neon_blue.jpg';
    }
  }

  String get blackStoneImage {
    switch (_currentTheme) {
      case BoardTheme.islamicWood:
        return 'assets/images/black_stone.jpg';
      case BoardTheme.antiqueMarble:
        return 'assets/images/marble_black.jpg';
      case BoardTheme.neonCyberpunk:
        return 'assets/images/neon_pink.jpg';
    }
  }
}
