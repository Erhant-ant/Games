import 'dart:math' as math;
import '../services/audio_service.dart';

enum Player { white, black }

enum GamePhase { placing, moving, removing, gameOver }
enum GameMode { pvp, pve, multiplayer }
enum GameVariant { classic, shortMill, flyingOnly, dailyChallenge }

class GameStateSnapshot {
  final List<Player?> board;
  final Player currentPlayer;
  final GamePhase phase;
  final Map<Player, int> placed;
  final Map<Player, int> captured;
  final int turnNumber;
  final Player? winner;
  final int movesWithoutCaptureOrMill;
  final Map<String, int> boardStateFrequencies;

  GameStateSnapshot({
    required this.board,
    required this.currentPlayer,
    required this.phase,
    required this.placed,
    required this.captured,
    required this.turnNumber,
    this.winner,
    required this.movesWithoutCaptureOrMill,
    required this.boardStateFrequencies,
  });
}

class DokuzTasGame {
  DokuzTasGame({
    this.mode = GameMode.pvp,
    this.variant = GameVariant.classic,
    this.initialTimeSeconds = 600,
  }) {
    reset();
  }

  GameMode mode;
  GameVariant variant;
  int initialTimeSeconds;

  static const int boardSize = 24;
  
  int get piecesPerPlayer {
    if (variant == GameVariant.shortMill) return 6;
    if (variant == GameVariant.flyingOnly) return 3;
    return 9;
  }

  // ── 16 olası mill (üçlü) ──
  static const List<List<int>> mills = [
    // Dış kare
    [0, 1, 2],
    [2, 3, 4],
    [4, 5, 6],
    [6, 7, 0],
    // Orta kare
    [8, 9, 10],
    [10, 11, 12],
    [12, 13, 14],
    [14, 15, 8],
    // İç kare
    [16, 17, 18],
    [18, 19, 20],
    [20, 21, 22],
    [22, 23, 16],
    // Bağlantı çizgileri (kenar ortaları)
    [1, 9, 17],
    [3, 11, 19],
    [5, 13, 21],
    [7, 15, 23],
  ];

  // ── Komşuluk grafiği ──
  static const List<List<int>> neighbors = [
    [1, 7],         // 0
    [0, 2, 9],      // 1
    [1, 3],         // 2
    [2, 4, 11],     // 3
    [3, 5],         // 4
    [4, 6, 13],     // 5
    [5, 7],         // 6
    [6, 0, 15],     // 7
    [9, 15],        // 8
    [8, 10, 1, 17], // 9
    [9, 11],        // 10
    [10, 12, 3, 19],// 11
    [11, 13],       // 12
    [12, 14, 5, 21],// 13
    [13, 15],       // 14
    [14, 8, 7, 23], // 15
    [17, 23],       // 16
    [16, 18, 9],    // 17
    [17, 19],       // 18
    [18, 20, 11],   // 19
    [19, 21],       // 20
    [20, 22, 13],   // 21
    [21, 23],       // 22
    [22, 16, 15],   // 23
  ];

  // ── Durum ──
  late List<Player?> board;
  late Player currentPlayer;
  late GamePhase phase;
  late Map<Player, int> placed;
  late Map<Player, int> captured;
  int? selectedIndex;
  int turnNumber = 1;
  Player? winner;

  List<int>? lastFormedMill;
  final List<GameStateSnapshot> _history = [];
  final List<String> moveHistory = [];
  final List<String> pgnMoves = [];
  
  // -- Track last moves for UI --
  int? lastMovedPieceFrom;
  int? lastMovedPieceTo;
  int? lastCapturedPiece;

  // -- Draw Rules State --
  int movesWithoutCaptureOrMill = 0;
  Map<String, int> boardStateFrequencies = {};

  DokuzTasGame clone() {
    DokuzTasGame copy = DokuzTasGame(mode: mode);
    copy.board = List.from(board);
    copy.currentPlayer = currentPlayer;
    copy.phase = phase;
    copy.placed = Map.from(placed);
    copy.captured = Map.from(captured);
    copy.turnNumber = turnNumber;
    copy.movesWithoutCaptureOrMill = movesWithoutCaptureOrMill;
    copy.boardStateFrequencies = Map.from(boardStateFrequencies);
    copy.isMuted = true;
    return copy;
  }

  int undoCount = 0;
  static const int maxUndos = 2;
  bool isMuted = false;

  // Timers (in seconds)
  late int whiteTime;
  late int blackTime;
  bool isTimerRunning = false;

  int currentMoveThinkingTime = 0;
  List<int>? currentHint;

  bool get canUndo => _history.isNotEmpty && undoCount < maxUndos;

  void tickTimer(Function onTimeUp) {
    if (!isTimerRunning || phase == GamePhase.gameOver) return;
    currentMoveThinkingTime++;
    if (currentPlayer == Player.white) {
      whiteTime--;
      if (whiteTime <= 0) {
        whiteTime = 0;
        phase = GamePhase.gameOver;
        _determineWinnerOnTimeout();
        onTimeUp();
      }
    } else {
      blackTime--;
      if (blackTime <= 0) {
        blackTime = 0;
        phase = GamePhase.gameOver;
        _determineWinnerOnTimeout();
        onTimeUp();
      }
    }
  }

  void _determineWinnerOnTimeout() {
    int whiteScore = piecesOnBoard(Player.white) + piecesToPlace(Player.white);
    int blackScore = piecesOnBoard(Player.black) + piecesToPlace(Player.black);
    if (whiteScore > blackScore) {
      winner = Player.white;
    } else if (blackScore > whiteScore) {
      winner = Player.black;
    } else {
      winner = null; // Draw
    }
  }

  // Kolaylık getter'ları
  int piecesOnBoard(Player p) =>
      board.where((s) => s == p).length;

  int piecesToPlace(Player p) =>
      piecesPerPlayer - placed[p]!;

  bool get allPiecesPlaced =>
      placed[Player.white]! >= piecesPerPlayer &&
      placed[Player.black]! >= piecesPerPlayer;

  Player _opponent(Player p) =>
      p == Player.white ? Player.black : Player.white;

  String playerName(Player p) =>
      p == Player.white ? 'Beyaz' : 'Siyah';

  bool canFly(Player p) =>
      allPiecesPlaced && piecesOnBoard(p) == 3;

  // ── Durum Metinleri ──
  String get statusText {
    if (phase == GamePhase.gameOver) {
      if (winner == null) return 'Berabere Bitti! 🤝';
      return '${playerName(winner!)} Kazandı! 🏆';
    }
    if (phase == GamePhase.removing) {
      return '${playerName(currentPlayer)} — Rakipten taş al!';
    }
    if (phase == GamePhase.placing) {
      return '${playerName(currentPlayer)} — Taşını yerleştir';
    }
    if (selectedIndex != null) {
      return 'Hedef noktayı seç';
    }
    if (canFly(currentPlayer)) {
      return '${playerName(currentPlayer)} — Uçuş modu! ✈️';
    }
    return '${playerName(currentPlayer)} oynuyor';
  }

  String get phaseLabel {
    switch (phase) {
      case GamePhase.placing:
        return 'TAŞLAR YERLEŞTİRİLİYOR';
      case GamePhase.moving:
        return canFly(currentPlayer) ? 'UÇUŞ MODU' : 'TAŞLAR HAREKET EDİYOR';
      case GamePhase.removing:
        return 'RAKİPTEN TAŞ AL';
      case GamePhase.gameOver:
        return 'OYUN BİTTİ';
    }
  }

  // ── Sıfırlama ve Geri Alma ──
  void reset() {
    board = List.filled(boardSize, null);
    currentPlayer = Player.white;
    phase = GamePhase.placing;
    placed = {Player.white: 0, Player.black: 0};
    captured = {Player.white: 0, Player.black: 0};
    selectedIndex = null;
    turnNumber = 0;
    winner = null;
    lastFormedMill = null;
    _history.clear();
    moveHistory.clear();
    lastMovedPieceFrom = null;
    lastMovedPieceTo = null;
    lastCapturedPiece = null;
    movesWithoutCaptureOrMill = 0;
    boardStateFrequencies.clear();
    pgnMoves.clear();
    
    whiteTime = initialTimeSeconds;
    blackTime = initialTimeSeconds;
    isTimerRunning = true;
    
    if (variant == GameVariant.dailyChallenge) {
      // Place pieces randomly using today's date as seed
      final now = DateTime.now();
      final seed = now.year * 10000 + now.month * 100 + now.day;
      final random = math.Random(seed);
      
      List<int> available = List.generate(boardSize, (i) => i);
      available.shuffle(random);
      
      for (int i = 0; i < 9; i++) {
        board[available[i]] = Player.white;
        placed[Player.white] = placed[Player.white]! + 1;
      }
      for (int i = 9; i < 18; i++) {
        board[available[i]] = Player.black;
        placed[Player.black] = placed[Player.black]! + 1;
      }
      phase = GamePhase.moving;
    }
    
    undoCount = 0;
    currentMoveThinkingTime = 0;
    currentHint = null;
  }

  void _saveSnapshot() {
    _history.add(GameStateSnapshot(
      board: List.from(board),
      currentPlayer: currentPlayer,
      phase: phase,
      placed: Map.from(placed),
      captured: Map.from(captured),
      turnNumber: turnNumber,
      winner: winner,
      movesWithoutCaptureOrMill: movesWithoutCaptureOrMill,
      boardStateFrequencies: Map.from(boardStateFrequencies),
    ));
    currentMoveThinkingTime = 0;
    currentHint = null;
  }

  void undo() {
    if (_history.isEmpty) return;
    final last = _history.removeLast();
    board = List.from(last.board);
    currentPlayer = last.currentPlayer;
    phase = last.phase;
    placed = Map.from(last.placed);
    captured = Map.from(last.captured);
    turnNumber = last.turnNumber;
    winner = last.winner;
    movesWithoutCaptureOrMill = last.movesWithoutCaptureOrMill;
    boardStateFrequencies = Map.from(last.boardStateFrequencies);
    selectedIndex = null;
    lastFormedMill = null;
    undoCount++;
    if (moveHistory.isNotEmpty) moveHistory.removeLast();
  }

  // ── Ana dokunma işleyicisi ──
  bool tap(int index) {
    if (phase == GamePhase.gameOver) return false;
    if (index < 0 || index >= boardSize) return false;

    switch (phase) {
      case GamePhase.placing:
        return _placePiece(index);
      case GamePhase.moving:
        return _handleMovePiece(index);
      case GamePhase.removing:
        return _removePiece(index);
      case GamePhase.gameOver:
        return false;
    }
  }

  // ── Yerleştirme ──
  bool _placePiece(int index) {
    if (board[index] != null) return false;

    _saveSnapshot();
    board[index] = currentPlayer;
    placed[currentPlayer] = placed[currentPlayer]! + 1;
    moveHistory.add('${playerName(currentPlayer)} taşı $index noktasına yerleştirdi.');
    
    String pStr = currentPlayer == Player.white ? 'W' : 'B';
    pgnMoves.add('$pStr$index');
    
    if (!isMuted) AudioService().playPlaceSound();

    final formedMill = _getFormedMill(index, currentPlayer);
    if (formedMill != null) {
      lastFormedMill = formedMill;
      phase = GamePhase.removing;
      if (!isMuted) AudioService().playMillSound();
    } else {
      lastFormedMill = null;
      _finishTurn();
    }
    
    lastMovedPieceFrom = null;
    lastMovedPieceTo = index;
    return true;
  }

  // ── Hareket ──
  bool _handleMovePiece(int index) {
    // Seçim yapılmamış — kendi taşını seç
    if (selectedIndex == null) {
      if (board[index] != currentPlayer) return false;
      // Hareket edebilecek mi kontrol et
      if (!canFly(currentPlayer) &&
          !neighbors[index].any((n) => board[n] == null)) {
        return false; // Bu taş kilitli, hareket edemez
      }
      selectedIndex = index;
      currentMoveThinkingTime = 0;
      currentHint = null;
      return true;
    }

    // Aynı taşa tekrar tıklama — seçimi iptal
    if (selectedIndex == index) {
      selectedIndex = null;
      return true;
    }

    // Başka kendi taşına tıklama — seçimi değiştir
    if (board[index] == currentPlayer) {
      if (!canFly(currentPlayer) &&
          !neighbors[index].any((n) => board[n] == null)) {
        return false;
      }
      selectedIndex = index;
      currentMoveThinkingTime = 0;
      currentHint = null;
      return true;
    }

    // Boş noktaya hareket
    if (board[index] != null) return false;
    if (!_canMoveTo(selectedIndex!, index)) {
      selectedIndex = null;
      return false;
    }

    _saveSnapshot();
    board[index] = currentPlayer;
    board[selectedIndex!] = null;
    moveHistory.add('${playerName(currentPlayer)} taşı ${selectedIndex!} noktasından $index noktasına oynadı.');
    
    String pStr = currentPlayer == Player.white ? 'W' : 'B';
    pgnMoves.add('$pStr${selectedIndex!}-$index');
    
    lastMovedPieceFrom = selectedIndex;
    lastMovedPieceTo = index;
    if (!isMuted) AudioService().playPlaceSound();
    
    final formedMill = _getFormedMill(index, currentPlayer);
    selectedIndex = null;

    if (formedMill != null) {
      movesWithoutCaptureOrMill = 0; // Reset for mill
      lastFormedMill = formedMill;
      phase = GamePhase.removing;
      if (!isMuted) AudioService().playMillSound();
    } else {
      movesWithoutCaptureOrMill++; // No mill, increment 50-move counter
      lastFormedMill = null;
      _finishTurn();
    }
    return true;
  }

  // ── Taş Alma ──
  bool _removePiece(int index) {
    final opponent = _opponent(currentPlayer);

    if (board[index] != opponent) return false;

    // Mill'deki taş alınamaz, tüm taşlar mill'deyse alınabilir
    if (_isInMill(index, opponent) && !_allPiecesInMills(opponent)) {
      return false;
    }

    _saveSnapshot();
    board[index] = null;
    captured[currentPlayer] = captured[currentPlayer]! + 1;
    moveHistory.add('${playerName(currentPlayer)} rakibin taşını aldı ($index).');
    
    if (pgnMoves.isNotEmpty) {
      pgnMoves[pgnMoves.length - 1] += 'x$index';
    }
    
    lastCapturedPiece = index;
    movesWithoutCaptureOrMill = 0; // Reset for capture
    
    if (!isMuted) AudioService().playCaptureSound();
    lastFormedMill = null; // Kırılma bitince parlaklığı söndür

    // Kazanma kontrolü: Rakibin 2 taşı kaldıysa
    if (allPiecesPlaced && piecesOnBoard(opponent) < 3) {
      phase = GamePhase.gameOver;
      winner = currentPlayer;
      return true;
    }

    _finishTurn();
    return true;
  }

  // ── Hareket Kontrolü ──
  bool _canMoveTo(int from, int to) {
    if (board[to] != null) return false;
    // Uçuş modu: 3 taş kalan oyuncu istediği yere gidebilir
    if (canFly(currentPlayer)) return true;
    return neighbors[from].contains(to);
  }

  // ── Mill Kontrolü ──
  bool _formsMill(int index, Player player) {
    return _getFormedMill(index, player) != null;
  }

  List<int>? _getFormedMill(int index, Player player) {
    for (var mill in mills) {
      if (mill.contains(index) && mill.every((point) => board[point] == player)) {
        return mill;
      }
    }
    return null;
  }

  bool _isInMill(int index, Player player) => _formsMill(index, player);

  bool _allPiecesInMills(Player player) {
    for (var i = 0; i < boardSize; i++) {
      if (board[i] == player && !_isInMill(i, player)) {
        return false;
      }
    }
    return true;
  }

  // ── Hamle yapabilme kontrolü ──
  bool _hasValidMoves(Player player) {
    if (canFly(player)) return true;
    for (var i = 0; i < boardSize; i++) {
      if (board[i] == player) {
        if (neighbors[i].any((n) => board[n] == null)) {
          return true;
        }
      }
    }
    return false;
  }

  // ── Tur Sonu ──
  void _finishTurn() {
    currentPlayer = _opponent(currentPlayer);
    turnNumber++;
    selectedIndex = null;

    if (allPiecesPlaced) {
      phase = GamePhase.moving;

      // Blokaj kontrolü: Hamle yapamıyorsa kaybeder
      if (!_hasValidMoves(currentPlayer)) {
        phase = GamePhase.gameOver;
        winner = _opponent(currentPlayer);
        return;
      }

      // 2 taş kaldıysa kaybeder
      if (piecesOnBoard(currentPlayer) < 3) {
        phase = GamePhase.gameOver;
        winner = _opponent(currentPlayer);
        return;
      }
      
      // 50-move rule
      if (movesWithoutCaptureOrMill >= 50) {
        phase = GamePhase.gameOver;
        winner = null; // Draw
        return;
      }
      
      // Repetition rule
      final stateStr = _getBoardStateString();
      boardStateFrequencies[stateStr] = (boardStateFrequencies[stateStr] ?? 0) + 1;
      if (boardStateFrequencies[stateStr]! >= 3) {
        phase = GamePhase.gameOver;
        winner = null; // Draw
        return;
      }
    } else {
      phase = GamePhase.placing;
    }
  }
  
  String _getBoardStateString() {
    return board.map((p) {
      if (p == Player.white) return 'W';
      if (p == Player.black) return 'B';
      return '0';
    }).join() + "_$currentPlayer";
  }

  // ── Olası hedef noktalar (UI yardımcısı) ──
  List<int> getValidMoves(int fromIndex) {
    if (board[fromIndex] != currentPlayer) return [];
    final result = <int>[];
    if (canFly(currentPlayer)) {
      for (var i = 0; i < boardSize; i++) {
        if (board[i] == null) result.add(i);
      }
    } else {
      for (final n in neighbors[fromIndex]) {
        if (board[n] == null) result.add(n);
      }
    }
    return result;
  }

  /// Kaldırılabilir rakip taşları döndürür.
  List<int> getRemovablePieces() {
    if (phase != GamePhase.removing) return [];
    final opponent = _opponent(currentPlayer);
    final allInMills = _allPiecesInMills(opponent);
    final result = <int>[];
    for (var i = 0; i < boardSize; i++) {
      if (board[i] == opponent) {
        if (allInMills || !_isInMill(i, opponent)) {
          result.add(i);
        }
      }
    }
    return result;
  }
  
  String exportPGN() {
    return pgnMoves.join(' ');
  }
}
