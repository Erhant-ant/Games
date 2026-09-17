
import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefsService {
  static const String _highScoreKey = 'highScore';
  static const String _coinsKey = 'coins';
  static const String _hintCountKey = 'hintCount';
  static const String _timeCountKey = 'timeCount';
  static const String _changeCountKey = 'changeCount';
  static const String _nicknameKey = 'nickname';
  static const String _currentThemeKey = 'currentTheme';
  static const String _unlockedThemesKey = 'unlockedThemes';
  
  static late SharedPreferences _prefs;

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
    // Klasik tema her zaman açıktır
    if (_prefs.getStringList(_unlockedThemesKey) == null) {
      await _prefs.setStringList(_unlockedThemesKey, ['classic']);
    }
  }

  static String get currentTheme => _prefs.getString(_currentThemeKey) ?? 'classic';
  static Future<void> setCurrentTheme(String themeId) async {
    await _prefs.setString(_currentThemeKey, themeId);
  }

  static List<String> get unlockedThemes => _prefs.getStringList(_unlockedThemesKey) ?? ['classic'];
  static Future<void> unlockTheme(String themeId) async {
    final themes = unlockedThemes;
    if (!themes.contains(themeId)) {
      themes.add(themeId);
      await _prefs.setStringList(_unlockedThemesKey, themes);
    }
  }

  static String? get nickname => _prefs.getString(_nicknameKey);
  static Future<void> setNickname(String name) async {
    await _prefs.setString(_nicknameKey, name);
  }

  static int get highScore => _prefs.getInt(_highScoreKey) ?? 0;
  static Future<void> setHighScore(int score) async {
    await _prefs.setInt(_highScoreKey, score);
  }

  static int get coins => _prefs.getInt(_coinsKey) ?? 0;
  static Future<void> setCoins(int value) async {
    await _prefs.setInt(_coinsKey, value);
  }

  static int get hintCount => _prefs.getInt(_hintCountKey) ?? 1; // Default 1 for first time
  static Future<void> setHintCount(int value) async {
    await _prefs.setInt(_hintCountKey, value);
  }

  static int get timeCount => _prefs.getInt(_timeCountKey) ?? 1; // Default 1 for first time
  static Future<void> setTimeCount(int value) async {
    await _prefs.setInt(_timeCountKey, value);
  }

  static int get changeCount => _prefs.getInt(_changeCountKey) ?? 1; // Default 1 for first time
  static Future<void> setChangeCount(int value) async {
    await _prefs.setInt(_changeCountKey, value);
  }

  // Settings
  static const String _soundKey = 'isSoundEnabled';
  static const String _musicKey = 'isMusicEnabled';
  static const String _vibrationKey = 'isVibrationEnabled';
  static const String _notificationsKey = 'areNotificationsEnabled';

  static bool get isSoundEnabled => _prefs.getBool(_soundKey) ?? true;
  static Future<void> setSoundEnabled(bool value) async {
    await _prefs.setBool(_soundKey, value);
  }

  static bool get isMusicEnabled => _prefs.getBool(_musicKey) ?? true;
  static Future<void> setMusicEnabled(bool value) async {
    await _prefs.setBool(_musicKey, value);
  }

  static bool get isVibrationEnabled => _prefs.getBool(_vibrationKey) ?? true;
  static Future<void> setVibrationEnabled(bool value) async {
    await _prefs.setBool(_vibrationKey, value);
  }

  static bool get areNotificationsEnabled => _prefs.getBool(_notificationsKey) ?? true;
  static Future<void> setNotificationsEnabled(bool value) async {
    await _prefs.setBool(_notificationsKey, value);
  }

  // Statistics
  static const String _gamesPlayedKey = 'totalGamesPlayed';
  static const String _correctAnswersKey = 'totalCorrectAnswers';
  static const String _wrongAnswersKey = 'totalWrongAnswers';

  static int get totalGamesPlayed => _prefs.getInt(_gamesPlayedKey) ?? 0;
  static Future<void> setTotalGamesPlayed(int value) async {
    await _prefs.setInt(_gamesPlayedKey, value);
  }

  static int get totalCorrectAnswers => _prefs.getInt(_correctAnswersKey) ?? 0;
  static Future<void> setTotalCorrectAnswers(int value) async {
    await _prefs.setInt(_correctAnswersKey, value);
  }

  static int get totalWrongAnswers => _prefs.getInt(_wrongAnswersKey) ?? 0;
  static Future<void> setTotalWrongAnswers(int value) async {
    await _prefs.setInt(_wrongAnswersKey, value);
  }
}
