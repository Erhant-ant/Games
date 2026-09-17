import 'package:flutter_test/flutter_test.dart';
import 'package:dokuz_tas/models/game_logic.dart';
import 'package:dokuz_tas/models/ai_opponent.dart';
import 'package:flutter/foundation.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  test('AI Calibration Test: Hard vs Medium', () async {
    int hardWins = 0;
    int mediumWins = 0;
    int draws = 0;
    int totalGames = 5; // Hızlı test için 5 maç

    print('Starting AI Calibration: Hard (White) vs Medium (Black) for $totalGames games.');

    for (int i = 0; i < totalGames; i++) {
      DokuzTasGame game = DokuzTasGame(mode: GameMode.pve, variant: GameVariant.classic);
      game.whiteTime = 999999;
      game.blackTime = 999999;

      AIOpponent hardAI = AIOpponent(game, Difficulty.hard);
      AIOpponent mediumAI = AIOpponent(game, Difficulty.medium);

      int turnCount = 0;
      while (game.phase != GamePhase.gameOver && turnCount < 100) { // Max 100 turns
        if (game.currentPlayer == Player.white) {
          await _simulateAiMove(hardAI);
        } else {
          await _simulateAiMove(mediumAI);
        }
        turnCount++;
      }

      if (game.winner == Player.white) {
        hardWins++;
        print('Game $i: Hard (White) won!');
      } else if (game.winner == Player.black) {
        mediumWins++;
        print('Game $i: Medium (Black) won!');
      } else {
        draws++;
        print('Game $i: Draw (Timeout / Loop)');
      }
    }

    print('\n--- CALIBRATION RESULTS ---');
    print('Hard AI Wins: $hardWins');
    print('Medium AI Wins: $mediumWins');
    print('Draws: $draws');

    expect(hardWins >= mediumWins, true);
  });
}

Future<void> _simulateAiMove(AIOpponent ai) async {
  List<int> taps = await compute(_computeAiTapsTesting, ai);
  for (int tap in taps) {
    ai.game.tap(tap);
  }
}

List<int> _computeAiTapsTesting(AIOpponent ai) {
  // We use getHintMove to bypass delays and get the exact taps
  List<int>? move = ai.getHintMove();
  List<int> taps = [];
  if (move != null) {
     for (var m in move) taps.add(m);
     // Simulate taps to see if removal is needed
     var clonedGame = ai.game.clone();
     for (var m in taps) clonedGame.tap(m);
     if (clonedGame.phase == GamePhase.removing) {
        // Need a remove move
        AIOpponent cloneAi = AIOpponent(clonedGame, ai.difficulty);
        List<int>? rMove = cloneAi.getHintMove();
        if (rMove != null && rMove.isNotEmpty) taps.add(rMove[0]);
     }
  }
  return taps;
}
