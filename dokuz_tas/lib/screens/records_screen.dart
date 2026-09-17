import 'package:flutter/material.dart';
import '../services/stats_service.dart';
import '../theme/app_theme.dart';

class RecordsScreen extends StatefulWidget {
  const RecordsScreen({super.key});

  @override
  State<RecordsScreen> createState() => _RecordsScreenState();
}

class _RecordsScreenState extends State<RecordsScreen> {
  final StatsService _stats = StatsService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rekorlar & Başarımlar'),
        backgroundColor: AppTheme.surfaceDark,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [AppTheme.surfaceDark, AppTheme.scaffoldBg],
          ),
        ),
        child: ListView(
          padding: const EdgeInsets.all(24.0),
          children: [
            _buildStatCard('En Hızlı Galibiyet', _stats.fastestWinSeconds == -1 ? '-' : '${_stats.fastestWinSeconds} sn', Icons.timer),
            const SizedBox(height: 16),
            _buildStatCard('En Uzun Galibiyet Serisi', '${_stats.maxWinStreak}', Icons.local_fire_department),
            const SizedBox(height: 32),
            const Text(
              'Başarımlar',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: AppTheme.goldBright,
              ),
            ),
            const SizedBox(height: 16),
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              children: [
                _buildAchievementBadge(
                  id: 'first_win',
                  title: 'İlk Kan',
                  desc: 'İlk oyununu kazan.',
                  icon: Icons.emoji_events,
                ),
                _buildAchievementBadge(
                  id: 'streak_5',
                  title: 'Yenilmez',
                  desc: '5 maç üst üste kazan.',
                  icon: Icons.military_tech,
                ),
                _buildAchievementBadge(
                  id: 'pacifist_win',
                  title: 'Barışçıl',
                  desc: 'Hiç değirmen kurmadan kazan.',
                  icon: Icons.front_hand,
                ),
                _buildAchievementBadge(
                  id: 'fast_capture_10s',
                  title: 'Hızlı Pençe',
                  desc: '10 saniyede taş al.',
                  icon: Icons.flash_on,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.surfaceMid,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.gold.withValues(alpha: 0.2)),
      ),
      child: Row(
        children: [
          Icon(icon, size: 40, color: AppTheme.gold),
          const SizedBox(width: 20),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: AppTheme.textSecondary,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(
                  color: AppTheme.textPrimary,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAchievementBadge({
    required String id,
    required String title,
    required String desc,
    required IconData icon,
  }) {
    bool isUnlocked = _stats.unlockedAchievements.contains(id);
    
    // For 'first_win', we can manually unlock it if wins > 0
    if (id == 'first_win' && _stats.wins > 0) isUnlocked = true;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isUnlocked ? AppTheme.surfaceMid : AppTheme.surfaceDark.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isUnlocked ? AppTheme.goldBright : AppTheme.textMuted.withValues(alpha: 0.2),
          width: isUnlocked ? 2 : 1,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 48,
            color: isUnlocked ? AppTheme.goldBright : AppTheme.textMuted.withValues(alpha: 0.3),
          ),
          const SizedBox(height: 12),
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: isUnlocked ? AppTheme.textPrimary : AppTheme.textMuted,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            desc,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: isUnlocked ? AppTheme.textSecondary : AppTheme.textMuted.withValues(alpha: 0.5),
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }
}
