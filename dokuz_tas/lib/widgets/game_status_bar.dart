import 'package:flutter/material.dart';
import '../models/game_logic.dart';
import '../theme/app_theme.dart';

/// Oyun durum çubuğu — mevcut faz, tur sayısı, durum mesajı.
class GameStatusBar extends StatelessWidget {
  const GameStatusBar({
    super.key,
    required this.game,
  });

  final DokuzTasGame game;

  @override
  Widget build(BuildContext context) {
    final isGameOver = game.phase == GamePhase.gameOver;
    final isRemoving = game.phase == GamePhase.removing;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
      decoration: BoxDecoration(
        color: isRemoving
            ? AppTheme.danger.withValues(alpha: 0.1)
            : isGameOver
                ? AppTheme.success.withValues(alpha: 0.1)
                : AppTheme.surfaceDark.withValues(alpha: 0.8),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isRemoving
              ? AppTheme.danger.withValues(alpha: 0.3)
              : isGameOver
                  ? AppTheme.success.withValues(alpha: 0.3)
                  : AppTheme.goldDark.withValues(alpha: 0.15),
        ),
      ),
      child: Row(
        children: [
          // Faz ikonu
          _PhaseIcon(phase: game.phase),
          const SizedBox(width: 12),
          // Durum mesajı
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: Text(
                    game.statusText,
                    key: ValueKey<String>(game.statusText),
                    style: TextStyle(
                      color: isRemoving
                          ? AppTheme.danger
                          : isGameOver
                              ? AppTheme.success
                              : AppTheme.goldBright,
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  game.phaseLabel,
                  style: const TextStyle(
                    color: AppTheme.textMuted,
                    fontSize: 10,
                    letterSpacing: 1.5,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          // Tur sayısı
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: AppTheme.goldDark.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              'TUR ${game.turnNumber}',
              style: const TextStyle(
                color: AppTheme.textMuted,
                fontSize: 11,
                fontWeight: FontWeight.w600,
                letterSpacing: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PhaseIcon extends StatelessWidget {
  const _PhaseIcon({required this.phase});

  final GamePhase phase;

  @override
  Widget build(BuildContext context) {
    IconData icon;
    Color color;

    switch (phase) {
      case GamePhase.placing:
        icon = Icons.add_circle_outline;
        color = AppTheme.gold;
      case GamePhase.moving:
        icon = Icons.open_with;
        color = AppTheme.gold;
      case GamePhase.removing:
        icon = Icons.remove_circle_outline;
        color = AppTheme.danger;
      case GamePhase.gameOver:
        icon = Icons.emoji_events;
        color = AppTheme.success;
    }

    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        shape: BoxShape.circle,
      ),
      child: Icon(icon, color: color, size: 20),
    );
  }
}
