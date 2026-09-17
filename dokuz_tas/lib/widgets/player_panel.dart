import 'package:flutter/material.dart';
import '../models/game_logic.dart';
import '../theme/app_theme.dart';
import 'stone_widget.dart';

/// Oyuncu bilgi paneli — taş sayısı, sıra göstergesi, alınan taşlar.
class PlayerPanel extends StatelessWidget {
  const PlayerPanel({
    super.key,
    required this.game,
    required this.player,
    this.compact = false,
    this.isThinking = false,
  });

  final DokuzTasGame game;
  final Player player;
  final bool compact;
  final bool isThinking;

  @override
  Widget build(BuildContext context) {
    final isActive = game.currentPlayer == player && game.phase != GamePhase.gameOver;
    final isWinner = game.phase == GamePhase.gameOver && game.winner == player;
    final isWhite = player == Player.white;
    final name = game.playerName(player);
    final onBoard = game.piecesOnBoard(player);
    final toPlace = game.piecesToPlace(player);
    final capturedCount = game.captured[player]!;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      padding: EdgeInsets.all(compact ? 12 : 16),
      decoration: BoxDecoration(
        color: isActive
            ? AppTheme.surfaceMid.withValues(alpha: 0.9)
            : AppTheme.surfaceDark.withValues(alpha: 0.7),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isActive
              ? AppTheme.gold.withValues(alpha: 0.6)
              : isWinner
                  ? AppTheme.success.withValues(alpha: 0.6)
                  : AppTheme.goldDark.withValues(alpha: 0.15),
          width: isActive || isWinner ? 2 : 1,
        ),
        boxShadow: [
          if (isActive)
            BoxShadow(
              color: AppTheme.goldGlow,
              blurRadius: 12,
              spreadRadius: -2,
            ),
        ],
      ),
      child: Row(
        children: [
          // Taş ikonu
          StoneWidget(
            player: isWhite ? 'white' : 'black',
            size: compact ? 30 : 36,
            selected: isActive,
            animate: false,
          ),
          SizedBox(width: compact ? 10 : 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // İsim + durum
                Row(
                  children: [
                    Text(
                      name,
                      style: TextStyle(
                        color: isActive
                            ? AppTheme.goldBright
                            : AppTheme.textSecondary,
                        fontWeight: FontWeight.w700,
                        fontSize: compact ? 14 : 16,
                      ),
                    ),
                    if (isActive) ...[
                      const SizedBox(width: 8),
                      if (isThinking)
                        Row(
                          children: [
                            const SizedBox(
                              width: 12,
                              height: 12,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: AppTheme.goldBright,
                              ),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              'Düşünüyor...',
                              style: TextStyle(
                                color: AppTheme.goldBright.withValues(alpha: 0.8),
                                fontSize: compact ? 10 : 12,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ],
                        )
                      else
                        _ActiveIndicator(),
                    ],
                    if (isWinner) ...[
                      const SizedBox(width: 8),
                      const Text('🏆', style: TextStyle(fontSize: 16)),
                    ],
                  ],
                ),
                const SizedBox(height: 4),
                // İstatistikler
                Row(
                  children: [
                    _StatChip(
                      icon: Icons.circle,
                      iconColor: isWhite
                          ? AppTheme.whiteStone
                          : AppTheme.blackStone,
                      label: '$onBoard tahtada',
                    ),
                    if (toPlace > 0) ...[
                      const SizedBox(width: 12),
                      _StatChip(
                        icon: Icons.back_hand_outlined,
                        iconColor: AppTheme.gold,
                        label: '$toPlace elde',
                      ),
                    ],
                    if (capturedCount > 0) ...[
                      const SizedBox(width: 12),
                      _StatChip(
                        icon: Icons.emoji_events_outlined,
                        iconColor: AppTheme.success,
                        label: '$capturedCount aldı',
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
          // Uçuş modu göstergesi
          if (game.allPiecesPlaced && onBoard == 3)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: AppTheme.info.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: AppTheme.info.withValues(alpha: 0.4),
                ),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.flight, size: 14, color: AppTheme.info),
                  SizedBox(width: 4),
                  Text(
                    'UÇUŞ',
                    style: TextStyle(
                      color: AppTheme.info,
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class _ActiveIndicator extends StatefulWidget {
  @override
  State<_ActiveIndicator> createState() => _ActiveIndicatorState();
}

class _ActiveIndicatorState extends State<_ActiveIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) => Container(
        width: 8,
        height: 8,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: AppTheme.gold.withValues(alpha: 0.5 + _controller.value * 0.5),
          boxShadow: [
            BoxShadow(
              color: AppTheme.goldGlow,
              blurRadius: 4 + _controller.value * 4,
            ),
          ],
        ),
      ),
    );
  }
}

class _StatChip extends StatelessWidget {
  const _StatChip({
    required this.icon,
    required this.iconColor,
    required this.label,
  });

  final IconData icon;
  final Color iconColor;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 10, color: iconColor),
        const SizedBox(width: 4),
        Text(
          label,
          style: const TextStyle(
            color: AppTheme.textMuted,
            fontSize: 11,
          ),
        ),
      ],
    );
  }
}
