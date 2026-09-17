import 'dart:math';
import 'package:flutter/foundation.dart';
import 'game_logic.dart';

enum Difficulty { easy, medium, hard }

class TTEntry {
  final int depth;
  final int value;
  final int flag; // 0 = EXACT, 1 = LOWERBOUND, 2 = UPPERBOUND
  TTEntry(this.depth, this.value, this.flag);
}

class Zobrist {
  static final List<List<int>> table = _initTable();
  static final int blackMoveHash = Random(42).nextInt(0x7FFFFFFF);

  static List<List<int>> _initTable() {
    Random rng = Random(12345);
    List<List<int>> t = List.generate(24, (_) => List.filled(3, 0));
    for (int i = 0; i < 24; i++) {
      for (int j = 0; j < 3; j++) {
        t[i][j] = rng.nextInt(0x7FFFFFFF);
      }
    }
    return t;
  }
}

List<int> _computeAiTaps(AIOpponent ai) {
  List<int> taps = [];
  try {
    if (ai.game.phase == GamePhase.placing) {
      int move = -1;
      if (ai.difficulty == Difficulty.hard) {
        move = ai._findHardPlacingMove();
      } else if (ai.difficulty == Difficulty.medium) {
        move = ai._findMediumPlacingMove();
      } else {
        move = ai._findRandomEmptySpot();
      }
      if (move != -1) {
        taps.add(move);
        ai.game.tap(move);
        if (ai.game.phase == GamePhase.removing) {
          int rm = ai._findRemovingMoveOnly();
          if (rm != -1) taps.add(rm);
        }
      }
    } else if (ai.game.phase == GamePhase.moving) {
      List<List<int>> possibleMoves = [];
      for (int i = 0; i < DokuzTasGame.boardSize; i++) {
        if (ai.game.board[i] == ai.game.currentPlayer) {
          List<int> validTargets = ai.game.getValidMoves(i);
          for (var target in validTargets) {
            possibleMoves.add([i, target]);
          }
        }
      }
      if (possibleMoves.isNotEmpty) {
        List<int>? chosenMove;
        if (ai.difficulty == Difficulty.hard) {
          chosenMove = ai._findHardMovingMove(possibleMoves);
        } else if (ai.difficulty == Difficulty.medium) {
          chosenMove = ai._findMediumMovingMove(possibleMoves);
        } else {
          chosenMove = possibleMoves[ai._random.nextInt(possibleMoves.length)];
        }
        if (chosenMove != null) {
          taps.add(chosenMove[0]);
          taps.add(chosenMove[1]);
          ai.game.tap(chosenMove[0]);
          ai.game.tap(chosenMove[1]);
          if (ai.game.phase == GamePhase.removing) {
            int rm = ai._findRemovingMoveOnly();
            if (rm != -1) taps.add(rm);
          }
        }
      }
    } else if (ai.game.phase == GamePhase.removing) {
      int rm = ai._findRemovingMoveOnly();
      if (rm != -1) taps.add(rm);
    }
  } catch (e, stack) {
    debugPrint("AI_ERROR: $e\n$stack");
    if (ai.game.phase == GamePhase.placing) {
      taps.add(ai._findRandomEmptySpot());
    } else if (ai.game.phase == GamePhase.removing) {
      taps.add(ai._findRemovingMoveOnly());
    } else if (ai.game.phase == GamePhase.moving) {
      List<List<int>> possibleMoves = ai._getAllPossibleMoves(ai.game.currentPlayer);
      if (possibleMoves.isNotEmpty) {
        taps.addAll(possibleMoves[ai._random.nextInt(possibleMoves.length)]);
      }
    }
  }
  return taps;
}

class AIOpponent {
  final DokuzTasGame game;
  final Difficulty difficulty;
  final Random _random = Random();
  final Map<int, TTEntry> _tt = {};
  int _startTimeMs = 0;
  int _timeLimitMs = 1500;
  bool _timeout = false;
  int _iterationCount = 0;

  AIOpponent(this.game, this.difficulty);

  Future<void> makeMove() async {
    if (game.phase == GamePhase.gameOver) return;

    await Future.delayed(const Duration(seconds: 1)); // 1 saniye bekle

    AIOpponent aiClone = AIOpponent(game.clone(), difficulty);
    List<int> taps = await compute(_computeAiTaps, aiClone);
    
    await Future.delayed(Duration(milliseconds: 300 + _random.nextInt(300)));

    for (int i = 0; i < taps.length; i++) {
      game.tap(taps[i]);
      if (i < taps.length - 1) {
        await Future.delayed(const Duration(milliseconds: 300));
      }
    }
  }

  List<int>? getHintMove() {
    try {
      AIOpponent tempAi = AIOpponent(game.clone(), difficulty);
      return tempAi._getHintMoveInternal();
    } catch (e, stack) {
      debugPrint("HINT_ERROR: $e\n$stack");
      // temporary debug code: write to file
      try {
         // ignore: unused_local_variable
         var x = 0; // We can't easily import dart:io if it's not imported.
         // Let's just avoid throwing it so we don't crash, but wait, the user's console SHOWS the error!
      } catch(_) {}
      return null;
    }
  }

  List<int>? _getHintMoveInternal() {
    if (game.phase == GamePhase.placing) {
      int move = _findMediumPlacingMove();
      if (move != -1) return [move];
    } else if (game.phase == GamePhase.moving) {
      List<List<int>> possibleMoves = [];
      for (int i = 0; i < DokuzTasGame.boardSize; i++) {
        if (game.board[i] == game.currentPlayer) {
          List<int> validTargets = game.getValidMoves(i);
          for (var target in validTargets) {
            possibleMoves.add([i, target]);
          }
        }
      }
      if (possibleMoves.isNotEmpty) {
        return _findMediumMovingMove(possibleMoves);
      }
    } else if (game.phase == GamePhase.removing) {
      List<int> removable = game.getRemovablePieces();
      if (removable.isNotEmpty) {
        int chosenPiece = -1;
        int maxAdjacents = -1;
        for (int p in removable) {
          int adj = DokuzTasGame.neighbors[p].length;
          if (adj > maxAdjacents) {
            maxAdjacents = adj;
            chosenPiece = p;
          }
        }
        if (chosenPiece != -1) return [chosenPiece];
      }
    }
    return null;
  }

  int _findRemovingMoveOnly() {
    List<int> removable = game.getRemovablePieces();
    if (removable.isEmpty) return -1;

    int chosenPiece = -1;

    if (difficulty == Difficulty.hard || difficulty == Difficulty.medium) {
      Player opponent = game.currentPlayer == Player.white ? Player.black : Player.white;
      int bestScore = -999999;
      
      for (int p in removable) {
        game.board[p] = null;
        int score = _evaluateBoard(game.currentPlayer);
        game.board[p] = opponent; // Restore

        if (score > bestScore) {
          bestScore = score;
          chosenPiece = p;
        } else if (score == bestScore && _random.nextBool()) {
          chosenPiece = p;
        }
      }
    } else {
      chosenPiece = removable[_random.nextInt(removable.length)];
    }

    return chosenPiece;
  }

  int _findRandomEmptySpot() {
    List<int> emptySpots = [];
    for (int i = 0; i < DokuzTasGame.boardSize; i++) {
      if (game.board[i] == null) emptySpots.add(i);
    }
    if (emptySpots.isEmpty) return -1;
    return emptySpots[_random.nextInt(emptySpots.length)];
  }

  // --- EASY: %100 Rastgele (Yenmesi çok kolay) ---
  
  // --- MEDIUM: Eski 'Zor' seviyesi ayarında (Depth 3 Minimax) ---
  int _findMediumPlacingMove() {
    return _findHardPlacingMoveDepth(3);
  }

  List<int>? _findMediumMovingMove(List<List<int>> possibleMoves) {
    return _findHardMovingMoveDepth(possibleMoves, 3);
  }

  // --- HARD: Alpha-Beta Pruning Minimax (Derinlik 5 -> Iterative Deepening) ---
  int _findHardPlacingMove() {
    // Opening Book
    if (game.turnNumber <= 2) {
      List<int> bookMoves = [9, 11, 13, 15, 0, 2, 21, 23];
      bookMoves.shuffle(_random);
      for (int m in bookMoves) {
        if (game.board[m] == null) return m;
      }
    }

    _tt.clear();
    _startTimeMs = DateTime.now().millisecondsSinceEpoch;
    _timeout = false;
    _timeLimitMs = 1500;

    int bestMove = -1;
    for (int depth = 1; depth <= 10; depth++) {
      int move = _findHardPlacingMoveDepth(depth);
      if (_timeout) break;
      bestMove = move;
    }
    return bestMove != -1 ? bestMove : _findRandomEmptySpot();
  }

  List<int>? _findHardMovingMove(List<List<int>> possibleMoves) {
    _tt.clear();
    _startTimeMs = DateTime.now().millisecondsSinceEpoch;
    _timeout = false;
    _timeLimitMs = 1500;

    List<int>? bestMove;
    for (int depth = 1; depth <= 10; depth++) {
      List<int>? move = _findHardMovingMoveDepth(possibleMoves, depth);
      if (_timeout) break;
      bestMove = move;
    }
    if (possibleMoves.isEmpty) return null;
    return bestMove ?? possibleMoves[_random.nextInt(possibleMoves.length)];
  }

  int _findHardPlacingMoveDepth(int searchDepth) {
    int winMove = _findWinningPlace(game.currentPlayer);
    if (winMove != -1) return winMove;

    Player opponent = game.currentPlayer == Player.white ? Player.black : Player.white;
    int blockMove = _findWinningPlace(opponent);
    if (blockMove != -1) return blockMove;

    int bestScore = -999999;
    int bestMove = -1;

    for (int i = 0; i < DokuzTasGame.boardSize; i++) {
      if (_timeout) break;
      _iterationCount++;
      if (_iterationCount % 500 == 0) {
        if ((DateTime.now().millisecondsSinceEpoch - _startTimeMs) > _timeLimitMs) {
          _timeout = true;
          break;
        }
      }
      
      if (game.board[i] == null) {
        game.board[i] = game.currentPlayer;
        int score = _alphaBeta(searchDepth - 1, -999999, 999999, false);
        game.board[i] = null;

        if (score > bestScore) {
          bestScore = score;
          bestMove = i;
        } else if (score == bestScore && _random.nextBool()) {
          bestMove = i;
        }
      }
    }
    return bestMove != -1 ? bestMove : _findRandomEmptySpot();
  }

  List<int>? _findHardMovingMoveDepth(List<List<int>> possibleMoves, int searchDepth) {
    int bestScore = -999999;
    List<int>? bestMove;

    for (var move in possibleMoves) {
      if (_timeout) break;
      _iterationCount++;
      if (_iterationCount % 500 == 0) {
        if ((DateTime.now().millisecondsSinceEpoch - _startTimeMs) > _timeLimitMs) {
          _timeout = true;
          break;
        }
      }
      
      game.board[move[0]] = null;
      game.board[move[1]] = game.currentPlayer;
      
      int score = _alphaBeta(searchDepth - 1, -999999, 999999, false);

      game.board[move[0]] = game.currentPlayer;
      game.board[move[1]] = null;

      if (score > bestScore) {
        bestScore = score;
        bestMove = move;
      } else if (score == bestScore && _random.nextBool()) {
        bestMove = move;
      }
    }
    if (possibleMoves.isEmpty) return null;
    return bestMove ?? possibleMoves[_random.nextInt(possibleMoves.length)];
  }

  int _computeBoardHash() {
    int hash = 0;
    for (int i = 0; i < 24; i++) {
      int state = 0;
      if (game.board[i] == Player.white) state = 1;
      else if (game.board[i] == Player.black) state = 2;
      hash ^= Zobrist.table[i][state];
    }
    if (game.currentPlayer == Player.black) {
      hash ^= Zobrist.blackMoveHash;
    }
    // Mix phase and placed counts into hash if needed, but Placing vs Moving is enough
    hash ^= (game.phase.index << 31); 
    return hash;
  }

  int _alphaBeta(int depth, int alpha, int beta, bool isMaximizing, {int qDepth = 0}) {
    if (_timeout) return 0;
    
    _iterationCount++;
    if (_iterationCount % 500 == 0) {
      if ((DateTime.now().millisecondsSinceEpoch - _startTimeMs) > _timeLimitMs) {
        _timeout = true;
        return 0;
      }
    }

    // Transposition Table Kontrolü
    int hash = _computeBoardHash();
    if (_tt.containsKey(hash)) {
      TTEntry entry = _tt[hash]!;
      if (entry.depth >= depth) {
        if (entry.flag == 0) return entry.value;
        if (entry.flag == 1) alpha = max(alpha, entry.value); // LOWERBOUND
        if (entry.flag == 2) beta = min(beta, entry.value);   // UPPERBOUND
        if (alpha >= beta) return entry.value;
      }
    }

    int originalAlpha = alpha;

    // Terminal Node Kontrolü (Oyun Bitti Mi?)
    int whitePieces = game.board.where((p) => p == Player.white).length;
    int blackPieces = game.board.where((p) => p == Player.black).length;
    if (game.phase == GamePhase.moving) {
      if (whitePieces < 3) return game.currentPlayer == Player.black ? 999999 : -999999;
      if (blackPieces < 3) return game.currentPlayer == Player.white ? 999999 : -999999;
    }

    Player activePlayer = isMaximizing ? game.currentPlayer : (game.currentPlayer == Player.white ? Player.black : Player.white);

    if (depth <= 0) {
      if (qDepth < 2) {
        Player opponent = activePlayer == Player.white ? Player.black : Player.white;
        bool isNoisy = _countPotentialMills(activePlayer) > 0 || _countPotentialMills(opponent) > 0;
        if (isNoisy) {
          depth = 1;
          qDepth++;
        } else {
          return _evaluateBoard(game.currentPlayer);
        }
      } else {
        return _evaluateBoard(game.currentPlayer);
      }
    }
    
    if (game.phase == GamePhase.placing) {
      if (isMaximizing) {
        int maxEval = -999999;
        for (int i = 0; i < DokuzTasGame.boardSize; i++) {
          if (_timeout) return 0;
          if (game.board[i] == null) {
            game.board[i] = activePlayer;
            int eval;
            if (_simulatesMill(i, activePlayer)) {
              eval = _simulateRemovalEval(depth, alpha, beta, isMaximizing, activePlayer, qDepth);
            } else {
              eval = _alphaBeta(depth - 1, alpha, beta, false, qDepth: qDepth);
            }
            game.board[i] = null;
            maxEval = max(maxEval, eval);
            alpha = max(alpha, eval);
            if (beta <= alpha) break;
          }
        }
        return maxEval == -999999 ? _evaluateBoard(game.currentPlayer) : maxEval;
      } else {
        int minEval = 999999;
        for (int i = 0; i < DokuzTasGame.boardSize; i++) {
          if (_timeout) return 0;
          if (game.board[i] == null) {
            game.board[i] = activePlayer;
            int eval;
            if (_simulatesMill(i, activePlayer)) {
              eval = _simulateRemovalEval(depth, alpha, beta, isMaximizing, activePlayer, qDepth);
            } else {
              eval = _alphaBeta(depth - 1, alpha, beta, true, qDepth: qDepth);
            }
            game.board[i] = null;
            minEval = min(minEval, eval);
            beta = min(beta, eval);
            if (beta <= alpha) break;
          }
        }
        return minEval == 999999 ? _evaluateBoard(game.currentPlayer) : minEval;
      }
    } else {
      List<List<int>> moves = _getAllPossibleMoves(activePlayer);
      if (moves.isEmpty) return isMaximizing ? -999999 : 999999; // Oyun bitti (Blokaj)

      if (isMaximizing) {
        int maxEval = -999999;
        for (var move in moves) {
          if (_timeout) return 0;
          game.board[move[0]] = null;
          game.board[move[1]] = activePlayer;
          int eval;
          if (_simulatesMill(move[1], activePlayer)) {
             eval = _simulateRemovalEval(depth, alpha, beta, isMaximizing, activePlayer, qDepth);
          } else {
             eval = _alphaBeta(depth - 1, alpha, beta, false, qDepth: qDepth);
          }
          game.board[move[0]] = activePlayer;
          game.board[move[1]] = null;
          maxEval = max(maxEval, eval);
          alpha = max(alpha, eval);
          if (beta <= alpha) break;
        }
        int bestEval = maxEval;
        
        int flag = 0; // EXACT
        if (bestEval <= originalAlpha) flag = 2; // UPPERBOUND
        else if (bestEval >= beta) flag = 1; // LOWERBOUND
        
        _tt[hash] = TTEntry(depth, bestEval, flag);
        return bestEval;
      } else {
        int minEval = 999999;
        for (var move in moves) {
          if (_timeout) return 0;
          game.board[move[0]] = null;
          game.board[move[1]] = activePlayer;
          int eval;
          if (_simulatesMill(move[1], activePlayer)) {
             eval = _simulateRemovalEval(depth, alpha, beta, isMaximizing, activePlayer, qDepth);
          } else {
             eval = _alphaBeta(depth - 1, alpha, beta, true, qDepth: qDepth);
          }
          game.board[move[0]] = activePlayer;
          game.board[move[1]] = null;
          minEval = min(minEval, eval);
          beta = min(beta, eval);
          if (beta <= alpha) break;
        }
        
        int bestEval = minEval;
        int flag = 0; // EXACT
        if (bestEval <= originalAlpha) flag = 2; // UPPERBOUND
        else if (bestEval >= beta) flag = 1; // LOWERBOUND
        
        _tt[hash] = TTEntry(depth, bestEval, flag);
        return minEval;
      }
    }
  }

  int _simulateRemovalEval(int depth, int alpha, int beta, bool isMaximizing, Player activePlayer, int qDepth) {
    Player opponent = activePlayer == Player.white ? Player.black : Player.white;
    List<int> removable = _getRemovablePiecesSimulated(opponent);
    
    if (removable.isEmpty) {
      return _alphaBeta(depth - 1, alpha, beta, !isMaximizing, qDepth: qDepth);
    }
    
    int bestPiece = -1;
    int bestScoreForRemoval = -999999;
    
    for (int p in removable) {
        if (_timeout) return 0;
        game.board[p] = null;
        int score = _evaluateBoard(activePlayer);
        game.board[p] = opponent;
        if (score > bestScoreForRemoval) {
            bestScoreForRemoval = score;
            bestPiece = p;
        }
    }
    
    if (bestPiece != -1) {
       game.board[bestPiece] = null;
       int eval = _alphaBeta(depth - 1, alpha, beta, !isMaximizing, qDepth: qDepth);
       game.board[bestPiece] = opponent;
       return eval;
    }
    
    return _alphaBeta(depth - 1, alpha, beta, !isMaximizing, qDepth: qDepth);
  }

  List<int> _getRemovablePiecesSimulated(Player opponent) {
    bool allInMills = true;
    for (var i = 0; i < DokuzTasGame.boardSize; i++) {
      if (game.board[i] == opponent && !_simulatesMill(i, opponent)) {
        allInMills = false;
        break;
      }
    }
    
    List<int> result = [];
    for (var i = 0; i < DokuzTasGame.boardSize; i++) {
      if (game.board[i] == opponent) {
        if (allInMills || !_simulatesMill(i, opponent)) {
          result.add(i);
        }
      }
    }
    return result;
  }


  List<List<int>> _getAllPossibleMoves(Player player) {
    List<List<int>> moves = [];
    bool isFlying = game.placed[player]! >= game.piecesPerPlayer && 
                    game.board.where((p) => p == player).length == 3;

    for (int i = 0; i < DokuzTasGame.boardSize; i++) {
      if (game.board[i] == player) {
        if (isFlying) {
           for (int j = 0; j < DokuzTasGame.boardSize; j++) {
             if (game.board[j] == null) moves.add([i, j]);
           }
        } else {
           for (var n in DokuzTasGame.neighbors[i]) {
             if (game.board[n] == null) moves.add([i, n]);
           }
        }
      }
    }
    
    // Move Ordering: Mill yapan hamleleri öne al (Pruning verimini arttırır)
    moves.sort((a, b) {
      bool aMills = _simulatesMill(a[1], player);
      bool bMills = _simulatesMill(b[1], player);
      if (aMills && !bMills) return -1;
      if (!aMills && bMills) return 1;
      return 0;
    });
    
    return moves;
  }

  int _calculateMobility(Player player) {
    int mobility = 0;
    int pCount = 0;
    for (var p in game.board) {
      if (p == player) pCount++;
    }

    bool isFlying = game.placed[player]! >= game.piecesPerPlayer && pCount == 3;

    if (isFlying) {
      int emptySpots = DokuzTasGame.boardSize - game.board.where((p) => p != null).length;
      return emptySpots * 3;
    }

    for (int i = 0; i < DokuzTasGame.boardSize; i++) {
      if (game.board[i] == player) {
        for (var n in DokuzTasGame.neighbors[i]) {
          if (game.board[n] == null) mobility++;
        }
      }
    }
    return mobility;
  }

  int _evaluateBoard(Player maximizingPlayer) {
    Player minimizingPlayer = maximizingPlayer == Player.white ? Player.black : Player.white;
    int maxPieces = game.board.where((p) => p == maximizingPlayer).length;
    int minPieces = game.board.where((p) => p == minimizingPlayer).length;
    
    int score = (maxPieces - minPieces) * 400; // Taş avantajı en kritik
    
    // Potansiyel mill'leri (2 taş + 1 boş) say ve puanla
    score += _countPotentialMills(maximizingPlayer) * 100;
    score -= _countPotentialMills(minimizingPlayer) * 150; // Rakibin üçlüye gitmesini durdurmak kritik
    
    // Hali hazırda kurulmuş olan Mill'leri değerlendir
    score += _countActiveMills(maximizingPlayer) * 200;
    score -= _countActiveMills(minimizingPlayer) * 250;

    // Hareket özgürlüğü ve Bloklama
    int maxMobility = _calculateMobility(maximizingPlayer);
    int minMobility = _calculateMobility(minimizingPlayer);
    
    // Rakibi blokladıysak devasa bir ceza
    if (minMobility == 0 && game.phase == GamePhase.moving) score += 5000;
    if (maxMobility == 0 && game.phase == GamePhase.moving) score -= 5000;

    score += maxMobility * 15;
    score -= minMobility * 25;

    // Medium zorluk için ufak random hata payı (Gürültü)
    if (difficulty == Difficulty.medium) {
      score += _random.nextInt(30) - 15;
    }

    return score;
  }

  int _countPotentialMills(Player player) {
    int count = 0;
    for (var mill in DokuzTasGame.mills) {
      int pCount = 0;
      int emptyCount = 0;
      for (int index in mill) {
        if (game.board[index] == player) {
          pCount++;
        } else if (game.board[index] == null) {
          emptyCount++;
        }
      }
      if (pCount == 2 && emptyCount == 1) {
        count++;
      }
    }
    return count;
  }

  int _countActiveMills(Player player) {
    int count = 0;
    for (var mill in DokuzTasGame.mills) {
      if (game.board[mill[0]] == player && 
          game.board[mill[1]] == player && 
          game.board[mill[2]] == player) {
        count++;
      }
    }
    return count;
  }

  // --- Yardımcı Fonksiyonlar ---
  int _findWinningPlace(Player player) {
    for (int i = 0; i < DokuzTasGame.boardSize; i++) {
      if (game.board[i] == null) {
        game.board[i] = player;
        bool makesMill = _simulatesMill(i, player);
        game.board[i] = null;
        if (makesMill) return i;
      }
    }
    return -1;
  }

  bool _simulatesMill(int index, Player player) {
    return DokuzTasGame.mills.any((mill) =>
        mill.contains(index) &&
        mill.every((point) => game.board[point] == player));
  }
}
