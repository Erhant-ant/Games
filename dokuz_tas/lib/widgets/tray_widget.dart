import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../models/game_logic.dart';
import 'stone_widget.dart';

class TrayWidget extends StatelessWidget {
  const TrayWidget({
    super.key,
    required this.player,
    required this.game,
    this.isThinking = false,
  });

  final Player player;
  final DokuzTasGame game;
  final bool isThinking;

  @override
  Widget build(BuildContext context) {
    int unplaced = game.piecesToPlace(player);
    int captured = game.captured[player] ?? 0;
    bool isWhite = player == Player.white;
    bool isActive = game.currentPlayer == player && game.phase != GamePhase.gameOver;

    return Container(
      width: 140,
      decoration: BoxDecoration(
        color: AppTheme.tableWood, // Dış çerçeve rengi
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isActive ? AppTheme.goldBright : AppTheme.boardFrameDark,
          width: isActive ? 3 : 2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.6),
            blurRadius: 15,
            offset: const Offset(4, 4),
          ),
          if (isActive)
            BoxShadow(
              color: AppTheme.goldGlow,
              blurRadius: 20,
              spreadRadius: 2,
            ),
        ],
      ),
      child: Container(
        margin: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppTheme.trayLeather, // İç deri yüzey
          borderRadius: BorderRadius.circular(6),
          border: Border.all(
            color: Colors.black.withValues(alpha: 0.8),
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.8),
              blurRadius: 4,
            ),
          ],
        ),
        child: Column(
          children: [
            // Timer
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text(
                '${(player == Player.white ? game.whiteTime : game.blackTime) ~/ 60}:${((player == Player.white ? game.whiteTime : game.blackTime) % 60).toString().padLeft(2, '0')}',
                style: TextStyle(
                  color: isActive ? AppTheme.goldBright : AppTheme.textMuted,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2,
                ),
              ),
            ),
            // Bekleyen Taşlar (Unplaced)
            Expanded(
              flex: 3,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    if (isThinking && player == Player.black)
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 14,
                            height: 14,
                            child: CircularProgressIndicator(strokeWidth: 2, color: AppTheme.goldBright),
                          ),
                          SizedBox(width: 6),
                          Text('DÜŞÜNÜYOR...', style: TextStyle(color: AppTheme.goldBright, fontSize: 10, fontStyle: FontStyle.italic)),
                        ],
                      )
                    else ...[
                      Text(
                        'BEKLEYEN',
                        style: TextStyle(
                          color: AppTheme.goldDark,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.5,
                        ),
                      ),
                      const SizedBox(height: 12),
                    ],
                    Wrap(
                      spacing: 8,
                      runSpacing: 12,
                      alignment: WrapAlignment.center,
                      children: List.generate(unplaced, (index) {
                        return StoneWidget(
                          player: isWhite ? 'white' : 'black',
                          size: 32,
                          animate: false,
                        );
                      }),
                    ),
                  ],
                ),
              ),
            ),
            
            // Ayrıcı Çizgi
            Container(
              height: 2,
              margin: const EdgeInsets.symmetric(horizontal: 16),
              color: AppTheme.goldDark.withValues(alpha: 0.3),
            ),

            // Alınan Taşlar (Captured)
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      'ALINAN',
                      style: TextStyle(
                        color: AppTheme.textMuted,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.5,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      alignment: WrapAlignment.center,
                      children: List.generate(captured, (index) {
                        // Alınan taşlar karşı takımın taşıdır.
                        return StoneWidget(
                          player: isWhite ? 'black' : 'white',
                          size: 24, // Alınan taşlar biraz daha küçük gösterilebilir
                          animate: false,
                        );
                      }),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
