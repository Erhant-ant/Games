import 'ai_opponent.dart';

class TournamentLevel {
  final int level;
  final String title;
  final String description;
  final Difficulty aiDifficulty;
  final int playerTimeLimitSeconds;
  final int aiTimeLimitSeconds;

  const TournamentLevel({
    required this.level,
    required this.title,
    required this.description,
    required this.aiDifficulty,
    required this.playerTimeLimitSeconds,
    required this.aiTimeLimitSeconds,
  });

  static const List<TournamentLevel> levels = [
    TournamentLevel(
      level: 1,
      title: 'Çırak',
      description: 'Zaman sıkıntısı olmadan temel hamleleri öğrenin.',
      aiDifficulty: Difficulty.easy,
      playerTimeLimitSeconds: 600,
      aiTimeLimitSeconds: 600,
    ),
    TournamentLevel(
      level: 2,
      title: 'Kalfalık',
      description: 'Daha dikkatli bir rakip ve daha az zaman.',
      aiDifficulty: Difficulty.medium,
      playerTimeLimitSeconds: 300,
      aiTimeLimitSeconds: 600,
    ),
    TournamentLevel(
      level: 3,
      title: 'Usta',
      description: 'Rakibiniz artık bir usta. Süreniz kısıtlı.',
      aiDifficulty: Difficulty.medium,
      playerTimeLimitSeconds: 180,
      aiTimeLimitSeconds: 600,
    ),
    TournamentLevel(
      level: 4,
      title: 'Büyük Usta',
      description: 'Hata affetmeyen, acımasız bir zorluk seviyesi.',
      aiDifficulty: Difficulty.hard,
      playerTimeLimitSeconds: 300,
      aiTimeLimitSeconds: 600,
    ),
    TournamentLevel(
      level: 5,
      title: 'Efsane',
      description: 'En zorlu rakibe karşı sadece 2 dakikanız var!',
      aiDifficulty: Difficulty.hard,
      playerTimeLimitSeconds: 120,
      aiTimeLimitSeconds: 600,
    ),
  ];
}
