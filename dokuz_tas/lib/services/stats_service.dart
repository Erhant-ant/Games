import 'package:shared_preferences/shared_preferences.dart';

class StatsService {
  static final StatsService _instance = StatsService._internal();
  factory StatsService() => _instance;

  StatsService._internal();

  int wins = 0;
  int losses = 0;
  int totalGames = 0;
  
  // Kullanıcı Profili
  String username = 'Oyuncu';
  
  // Yeni Kayıtlar
  int fastestWinSeconds = -1; // -1 means no win yet
  int currentWinStreak = 0;
  int maxWinStreak = 0;
  
  // Başarımlar
  Set<String> unlockedAchievements = {};

  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    wins = prefs.getInt('wins') ?? 0;
    losses = prefs.getInt('losses') ?? 0;
    totalGames = prefs.getInt('totalGames') ?? 0;
    
    fastestWinSeconds = prefs.getInt('fastestWinSeconds') ?? -1;
    currentWinStreak = prefs.getInt('currentWinStreak') ?? 0;
    maxWinStreak = prefs.getInt('maxWinStreak') ?? 0;
    username = prefs.getString('username') ?? 'Oyuncu';
    
    final achList = prefs.getStringList('unlockedAchievements');
    if (achList != null) {
      unlockedAchievements = achList.toSet();
    }
  }

  Future<void> setUsername(String newName) async {
    username = newName;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('username', newName);
  }

  Future<void> recordWin({int? durationSeconds}) async {
    wins++;
    totalGames++;
    currentWinStreak++;
    if (currentWinStreak > maxWinStreak) {
      maxWinStreak = currentWinStreak;
    }
    
    if (durationSeconds != null) {
      if (fastestWinSeconds == -1 || durationSeconds < fastestWinSeconds) {
        fastestWinSeconds = durationSeconds;
      }
    }
    
    if (currentWinStreak >= 5) {
      unlockAchievement('streak_5');
    }
    
    await _save();
  }

  Future<void> recordLoss() async {
    losses++;
    totalGames++;
    currentWinStreak = 0; // Seri bozuldu
    await _save();
  }
  
  Future<void> unlockAchievement(String id) async {
    if (!unlockedAchievements.contains(id)) {
      unlockedAchievements.add(id);
      await _save();
    }
  }

  Future<void> _save() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('wins', wins);
    await prefs.setInt('losses', losses);
    await prefs.setInt('totalGames', totalGames);
    await prefs.setInt('fastestWinSeconds', fastestWinSeconds);
    await prefs.setInt('currentWinStreak', currentWinStreak);
    await prefs.setInt('maxWinStreak', maxWinStreak);
    await prefs.setStringList('unlockedAchievements', unlockedAchievements.toList());
  }
}
