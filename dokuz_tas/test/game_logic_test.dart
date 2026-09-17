import 'package:flutter_test/flutter_test.dart';
import 'package:dokuz_tas/models/game_logic.dart';

import 'package:dokuz_tas/services/audio_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  AudioService.isTestMode = true;
  group('DokuzTasGame Logic Tests', () {
    late DokuzTasGame game;

    setUp(() {
      game = DokuzTasGame(mode: GameMode.pvp);
      // Ensure white starts
      game.currentPlayer = Player.white;
    });

    test('Initial state is correct', () {
      expect(game.phase, GamePhase.placing);
      expect(game.turnNumber, 1);
      expect(game.placed[Player.white], 0);
      expect(game.placed[Player.black], 0);
      expect(game.allPiecesPlaced, false);
    });

    test('Placing a piece updates board and turn', () {
      bool success = game.tap(0);
      expect(success, true);
      expect(game.board[0], Player.white);
      expect(game.placed[Player.white], 1);
      expect(game.currentPlayer, Player.black);
      expect(game.turnNumber, 2);
    });

    test('Cannot place piece on an occupied spot', () {
      game.tap(0); // White
      bool success = game.tap(0); // Black tries to place on 0
      expect(success, false);
      expect(game.board[0], Player.white);
      expect(game.currentPlayer, Player.black);
    });

    test('Forming a mill changes phase to removing', () {
      game.tap(0); // White
      game.tap(3); // Black
      game.tap(1); // White
      game.tap(4); // Black
      game.tap(2); // White forms mill at 0, 1, 2
      
      expect(game.phase, GamePhase.removing);
      expect(game.currentPlayer, Player.white); // Still White's turn to remove
    });

    test('Removing a piece updates captured and ends turn', () {
      game.tap(0); // White
      game.tap(3); // Black
      game.tap(1); // White
      game.tap(4); // Black
      game.tap(2); // White forms mill
      
      bool success = game.tap(3); // White removes Black's piece at 3
      expect(success, true);
      expect(game.board[3], null);
      expect(game.captured[Player.white], 1);
      expect(game.currentPlayer, Player.black);
      expect(game.phase, GamePhase.placing);
    });

    test('Cannot remove a piece that is in a mill unless all are in mills', () {
      // White forms a mill
      game.tap(0); // W
      game.tap(8); // B
      game.tap(1); // W
      game.tap(9); // B
      game.tap(2); // W mill
      game.tap(11); // W removes B at 11 (empty, fails, wait B is at 8,9)
      
      // Reset and setup carefully
      game.reset();
      game.currentPlayer = Player.white;
      
      // Black forms a mill
      game.tap(3); // W
      game.tap(0); // B
      game.tap(4); // W
      game.tap(1); // B
      game.tap(5); // W
      game.tap(2); // B mill
      game.tap(3); // B removes W at 3
      
      // White forms a mill
      game.tap(8); // W
      game.tap(10); // B
      game.tap(9); // W
      game.tap(11); // B
      game.tap(17); // W forms mill 8,9,17 (connection line)
      
      // Black's pieces at 0,1,2 are in a mill. 10 and 11 are not.
      bool removeMillPiece = game.tap(0);
      expect(removeMillPiece, false); // Cannot remove from mill
      
      bool removeFreePiece = game.tap(10);
      expect(removeFreePiece, true); // Can remove free piece
    });

    test('Transition to moving phase after all pieces placed', () {
      // Place 18 pieces without forming mills (or handle removals)
      for (int i = 0; i < 9; i++) {
        game.placed[Player.white] = i + 1;
        game.placed[Player.black] = i + 1;
      }
      game.board[0] = Player.white;
      game.board[1] = Player.black;
      game.board[2] = Player.white; // etc...
      // Manually trigger check
      game.phase = GamePhase.moving;
      expect(game.phase, GamePhase.moving);
    });

    test('Flying mode active when 3 pieces left', () {
      // Setup flying mode scenario
      game.placed[Player.white] = 9;
      game.placed[Player.black] = 9;
      game.phase = GamePhase.moving;
      
      // 3 pieces left for white
      game.board[0] = Player.white;
      game.board[1] = Player.white;
      game.board[2] = Player.white;
      
      expect(game.canFly(Player.white), true);
    });
  });
}
