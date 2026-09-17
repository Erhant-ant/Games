import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../models/tournament_level.dart';
import '../models/game_logic.dart';
import '../services/tournament_service.dart';
import 'game_screen.dart';

class TournamentScreen extends StatefulWidget {
  const TournamentScreen({super.key});

  @override
  State<TournamentScreen> createState() => _TournamentScreenState();
}

class _TournamentScreenState extends State<TournamentScreen> {
  final TournamentService _service = TournamentService();

  @override
  void initState() {
    super.initState();
    _initService();
  }

  Future<void> _initService() async {
    await _service.init();
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('TURNUVA MODU', style: TextStyle(letterSpacing: 2, fontWeight: FontWeight.bold)),
        backgroundColor: AppTheme.surfaceDark,
        elevation: 0,
      ),
      backgroundColor: AppTheme.scaffoldBg,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [AppTheme.surfaceDark, AppTheme.scaffoldBg],
          ),
        ),
        child: ListView.builder(
          padding: const EdgeInsets.all(24),
          itemCount: TournamentLevel.levels.length,
          itemBuilder: (context, index) {
            final level = TournamentLevel.levels[index];
            final bool isUnlocked = _service.isLevelUnlocked(level.level);
            final int stars = _service.getStars(level.level);
            
            return _buildLevelCard(context, level, isUnlocked, stars);
          },
        ),
      ),
    );
  }

  Widget _buildLevelCard(BuildContext context, TournamentLevel level, bool isUnlocked, int stars) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      color: isUnlocked ? AppTheme.surfaceMid : AppTheme.surfaceDark.withValues(alpha: 0.5),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: isUnlocked ? AppTheme.gold.withValues(alpha: 0.5) : Colors.transparent,
          width: 1,
        ),
      ),
      child: InkWell(
        onTap: isUnlocked
            ? () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => GameScreen(
                      initialMode: GameMode.pve,
                      initialDifficulty: level.aiDifficulty,
                      isTournament: true,
                      tournamentLevel: level,
                    ),
                  ),
                ).then((_) {
                  // Oyun bittikten sonra geri dönüldüğünde ekranı güncelle
                  setState(() {});
                });
              }
            : null,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              // Sol Kısım: İkon / Kilit
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: isUnlocked ? AppTheme.goldDark.withValues(alpha: 0.2) : Colors.black26,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  isUnlocked ? Icons.emoji_events : Icons.lock,
                  color: isUnlocked ? AppTheme.goldBright : AppTheme.textMuted,
                  size: 28,
                ),
              ),
              const SizedBox(width: 16),
              // Orta Kısım: Başlık ve Açıklama
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Seviye ${level.level}: ${level.title}',
                      style: TextStyle(
                        color: isUnlocked ? Colors.white : AppTheme.textMuted,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      level.description,
                      style: TextStyle(
                        color: isUnlocked ? AppTheme.textSecondary : AppTheme.textMuted.withValues(alpha: 0.5),
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              // Sağ Kısım: Yıldızlar
              if (isUnlocked)
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: List.generate(3, (index) {
                    return Icon(
                      index < stars ? Icons.star : Icons.star_border,
                      color: index < stars ? AppTheme.goldBright : AppTheme.textMuted,
                      size: 20,
                    );
                  }),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
