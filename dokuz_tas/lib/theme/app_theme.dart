import 'package:flutter/material.dart';

/// Premium 9 Taş oyun teması — ahşap, mermer ve altın tonları.
class AppTheme {
  AppTheme._();

  // ── Arka plan ──
  static const Color scaffoldBg = Color(0xFF1A1410);
  static const Color surfaceDark = Color(0xFF231C14);
  static const Color surfaceMid = Color(0xFF2E241A);

  // ── Ahşap Masa (Arka Plan) ──
  static const Color tableWood = Color(0xFF4A2B18);
  static const Color tableWoodDark = Color(0xFF2A150A);

  // ── Tahta ──
  static const Color boardMarble = Color(0xFFE8D5B4);
  static const Color boardMarbleLight = Color(0xFFF2E4CC);
  static const Color boardMarbleDark = Color(0xFFC7B191);
  static const Color boardFrame = Color(0xFF4A2810);
  static const Color boardFrameLight = Color(0xFF6B3A18);
  static const Color boardFrameDark = Color(0xFF2A1508);
  
  // ── Tepsi (Tray) ──
  static const Color trayLeather = Color(0xFF1E2124);
  static const Color trayLeatherDark = Color(0xFF101214);

  // ── Altın / Pirinç ──
  static const Color gold = Color(0xFFB8943D);
  static const Color goldBright = Color(0xFFD4A948);
  static const Color goldDark = Color(0xFF8A6E2C);
  static const Color goldGlow = Color(0x40D4A948);

  // ── Taşlar ──
  static const Color whiteStone = Color(0xFFE8D5B0);
  static const Color whiteStoneBorder = Color(0xFFD4BF94);
  static const Color blackStone = Color(0xFF3D2216);
  static const Color blackStoneBorder = Color(0xFF5A3A28);

  // ── Metin ──
  static const Color textPrimary = Color(0xFFF0E0C8);
  static const Color textSecondary = Color(0xFFB8A48C);
  static const Color textMuted = Color(0xFF7A6A54);

  // ── Durum ──
  static const Color success = Color(0xFF6ABF69);
  static const Color danger = Color(0xFFD45D5D);
  static const Color info = Color(0xFF5D9BD4);

  // ── Köşe aksesuarı ──
  static const Color cornerStud = Color(0xFFC8A64A);
  static const Color cornerStudHighlight = Color(0xFFE0C060);

  static ThemeData get darkTheme => ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: scaffoldBg,
        colorScheme: ColorScheme.fromSeed(
          seedColor: gold,
          brightness: Brightness.dark,
          surface: surfaceDark,
        ),
        fontFamily: 'Georgia',
        textTheme: const TextTheme(
          headlineLarge: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w800,
            color: textPrimary,
            letterSpacing: 2,
          ),
          headlineMedium: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w700,
            color: textPrimary,
            letterSpacing: 1.5,
          ),
          titleMedium: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: textSecondary,
            letterSpacing: 1.2,
          ),
          bodyMedium: TextStyle(
            fontSize: 13,
            color: textSecondary,
          ),
          bodySmall: TextStyle(
            fontSize: 11,
            color: textMuted,
            letterSpacing: 1.5,
          ),
          labelLarge: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.3,
          ),
        ),
      );
}
