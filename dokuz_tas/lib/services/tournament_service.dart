import 'package:shared_preferences/shared_preferences.dart';

class TournamentService {
  static final TournamentService _instance = TournamentService._internal();
  factory TournamentService() => _instance;
  TournamentService._internal();

  late SharedPreferences _prefs;
  bool _initialized = false;

  Future<void> init() async {
    if (_initialized) return;
    _prefs = await SharedPreferences.getInstance();
    _initialized = true;
  }

  /// Belirli bir seviyenin yıldız sayısını getirir (Yoksa 0).
  int getStars(int level) {
    if (!_initialized) return 0;
    return _prefs.getInt('tournament_stars_level_$level') ?? 0;
  }

  /// Eğer kazanılan yeni yıldız sayısı eskisinden yüksekse kaydeder.
  Future<void> saveStars(int level, int newStars) async {
    if (!_initialized) return;
    final currentStars = getStars(level);
    if (newStars > currentStars) {
      await _prefs.setInt('tournament_stars_level_$level', newStars);
    }
  }

  /// Bir seviyenin açık olup olmadığını kontrol eder.
  /// 1. seviye her zaman açıktır. Diğerleri için bir önceki seviyenin
  /// en az 1 yıldızla bitirilmiş olması gerekir.
  bool isLevelUnlocked(int level) {
    if (level == 1) return true;
    return getStars(level - 1) > 0;
  }
}
