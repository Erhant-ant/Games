import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' as flutter;
import '../models/game_logic.dart';
import '../models/ai_opponent.dart';
import '../models/tournament_level.dart';
import '../services/tournament_service.dart';
import '../services/multiplayer_service.dart';
import '../theme/app_theme.dart';
import '../widgets/game_board.dart';
import '../widgets/game_status_bar.dart';
import '../widgets/settings_dialog.dart';
import '../widgets/profile_dialog.dart';
import '../widgets/tray_widget.dart';
import '../theme/theme_controller.dart';
import '../services/audio_service.dart';
import '../services/stats_service.dart';
import 'home_screen.dart';
import 'package:confetti/confetti.dart';

class GameScreen extends StatefulWidget {
  final bool isMultiplayer;
  final bool isTournament;
  final TournamentLevel? tournamentLevel;
  final GameMode? initialMode;
  final Difficulty? initialDifficulty;
  final GameVariant? initialVariant;
  final int? initialDurationMinutes;

  const GameScreen({
    super.key, 
    this.isMultiplayer = false,
    this.isTournament = false,
    this.tournamentLevel,
    this.initialMode,
    this.initialDifficulty,
    this.initialVariant,
    this.initialDurationMinutes,
  });

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  late DokuzTasGame game;
  AIOpponent? aiOpponent;
  Difficulty currentDifficulty = Difficulty.medium;
  final MultiplayerService _mpService = MultiplayerService();
  StreamSubscription? _mpDataSubscription;
  Timer? _gameTimer;
  bool _isAiThinking = false;
  bool _isGameOverDialogShown = false;

  @override
  void initState() {
    super.initState();
    GameMode initialMode = widget.initialMode ?? (widget.isMultiplayer ? GameMode.multiplayer : GameMode.pvp);
    if (widget.initialDifficulty != null) {
      currentDifficulty = widget.initialDifficulty!;
    }
    
    if (widget.isTournament) {
      initialMode = GameMode.pve;
      currentDifficulty = widget.tournamentLevel!.aiDifficulty;
    }
    
    game = DokuzTasGame(
      mode: initialMode,
      variant: widget.initialVariant ?? GameVariant.classic,
      initialTimeSeconds: (widget.initialDurationMinutes ?? 10) * 60,
    );
    
    if (widget.isTournament) {
      game.whiteTime = widget.tournamentLevel!.playerTimeLimitSeconds;
      game.blackTime = widget.tournamentLevel!.aiTimeLimitSeconds;
    }
    
    if (widget.isMultiplayer) {
      _setupMultiplayerListener();
    }
    _startGameTimer();
  }

  void _startGameTimer() {
    _gameTimer?.cancel();
    _gameTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) return;
      if (game.phase == GamePhase.gameOver) return;
      
      setState(() {
        game.tickTimer(() {
          _showGameOverDialog();
        });
        
        // Hint Logic: Show hint after 20 seconds of thinking
        if (game.currentMoveThinkingTime >= 20 && game.currentHint == null) {
          bool isHumanTurn = true;
          if (game.mode == GameMode.pve && game.currentPlayer == Player.black) {
            isHumanTurn = false;
          } else if (game.mode == GameMode.multiplayer) {
            bool isMyTurn = (_mpService.deviceType == DeviceType.host && game.currentPlayer == Player.white) || 
                            (_mpService.deviceType == DeviceType.client && game.currentPlayer == Player.black);
            isHumanTurn = isMyTurn;
          }
          
          if (isHumanTurn) {
            aiOpponent ??= AIOpponent(game, currentDifficulty);
            game.currentHint = aiOpponent!.getHintMove();
          }
        }
      });
    });
  }

  void _setupMultiplayerListener() {
    _mpDataSubscription = _mpService.dataStream.listen((data) {
      if (data['action'] == 'tap') {
        int index = data['index'];
        if (mounted) {
          setState(() {
            game.tap(index);
          });
          _checkGameState(isRemoteMove: true);
        }
      } else if (data['action'] == 'restart') {
        if (mounted) {
          // Rakip oyunu yeniden başlattı
          Navigator.of(context, rootNavigator: true).pop(); // Varsa diyaloğu kapat
          _resetGameLocal();
        }
      }
    });
  }

  @override
  void dispose() {
    _mpDataSubscription?.cancel();
    _gameTimer?.cancel();
    super.dispose();
  }

  void _onNodeTap(int index) async {
    if (game.mode == GameMode.pve && game.currentPlayer == Player.black) {
      return; // AI'nın sırasındayken oyuncu tıklayamaz
    }
    
    if (game.mode == GameMode.multiplayer) {
      // Host = White, Client = Black
      bool isMyTurn = (_mpService.deviceType == DeviceType.host && game.currentPlayer == Player.white) || 
                      (_mpService.deviceType == DeviceType.client && game.currentPlayer == Player.black);
      if (!isMyTurn) return; // Karşı tarafın sırası
    }

    bool success = false;
    setState(() {
      success = game.tap(index);
      if (!success) {
        AudioService().playErrorSound();
      }
    });

    if (success && game.mode == GameMode.multiplayer) {
      _mpService.sendMove(index);
    }

    _checkGameState();
  }

  void _checkGameState({bool isRemoteMove = false}) async {
    if (game.phase == GamePhase.gameOver) {
      if (!_isGameOverDialogShown) {
        _isGameOverDialogShown = true;
        Future.delayed(const Duration(milliseconds: 500), _showGameOverDialog);
      }
      return;
    }

    // AI hamlesi (eğer multiplayer değilse ve pve ise)
    if (game.mode == GameMode.pve && game.currentPlayer == Player.black && !isRemoteMove) {
      if (mounted) {
        setState(() {
          _isAiThinking = true;
        });
      }
      
      aiOpponent ??= AIOpponent(game, currentDifficulty);
      await aiOpponent!.makeMove();
      
      if (mounted) {
        setState(() {
          _isAiThinking = false;
        }); // AI hamlesi sonrası ekranı güncelle
        _checkGameState(); // AI hamlesi oyunu bitirmiş olabilir
      }
    }
  }

  void _resetGameLocal() {
    setState(() {
      game.reset();
      _isGameOverDialogShown = false;
      if (widget.isTournament) {
        game.whiteTime = widget.tournamentLevel!.playerTimeLimitSeconds;
        game.blackTime = widget.tournamentLevel!.aiTimeLimitSeconds;
      }
      aiOpponent = null;
    });
    _checkGameState();
  }

  void _resetGame() {
    if (game.mode == GameMode.multiplayer) {
      _mpService.sendRestart();
    }
    _resetGameLocal();
  }

  void _openSettings() async {
    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (context) => SettingsDialog(
        initialMode: game.mode,
        initialDifficulty: currentDifficulty,
        initialVariant: game.variant,
        initialDurationMinutes: game.initialTimeSeconds ~/ 60,
      ),
    );

    if (result != null) {
      setState(() {
        game.mode = result['mode'];
        currentDifficulty = result['difficulty'];
        game.variant = result['variant'];
        game.initialTimeSeconds = result['duration'] * 60;
        _resetGame();
      });
    }
  }

  void _showGameOverDialog() {
    if (!mounted) return;
    
    int earnedStars = 0;
    if (widget.isTournament && game.winner == Player.white) {
      int whitePiecesLeft = game.board.where((p) => p == Player.white).length;
      if (!game.allPiecesPlaced) {
        whitePiecesLeft = 9;
      } else {
        whitePiecesLeft += game.piecesToPlace(Player.white);
      }
      
      earnedStars = 1;
      if (whitePiecesLeft >= 6) earnedStars = 2;
      if (whitePiecesLeft >= 8) earnedStars = 3;

      TournamentService().saveStars(widget.tournamentLevel!.level, earnedStars);
    }
    
    // Günlük görevi kaydet
    if (game.variant == GameVariant.dailyChallenge && game.winner == Player.white) {
      final now = DateTime.now();
      final dateKey = 'daily_${now.year}${now.month}${now.day}';
      SharedPreferences.getInstance().then((prefs) {
        prefs.setBool(dateKey, true);
      });
    }

    // İstatistikleri kaydet
    if (game.mode == GameMode.pve || widget.isTournament) {
      if (game.winner == Player.white) {
        int duration = game.initialTimeSeconds - game.whiteTime;
        StatsService().recordWin(durationSeconds: duration);
        
        bool pacifist = !game.pgnMoves.any((m) => m.startsWith('W') && m.contains('x'));
        if (pacifist) StatsService().unlockAchievement('pacifist_win');
        
        // Check if fast capture happened (first capture by white within 10s of white's time)
        // Hard to track precise time of first capture without timestamps, 
        // but we can just check if total duration <= 10 and they captured.
        // Actually, let's just award it if they win in under 30s as a proxy, or just give it if they win fast.
      } else if (game.winner == Player.black) {
        StatsService().recordLoss();
      }
    }
    
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => _GameOverDialog(
        winner: game.winner,
        winnerName: game.winner != null ? game.playerName(game.winner!) : null,
        isTournament: widget.isTournament,
        earnedStars: earnedStars,
        pgnString: game.exportPGN(),
        onNewGame: () {
          Navigator.of(ctx).pop();
          if (widget.isTournament && game.winner == Player.white) {
            // Next Level
            final currentLvl = widget.tournamentLevel!.level;
            final nextLvlIndex = TournamentLevel.levels.indexWhere((l) => l.level == currentLvl + 1);
            if (nextLvlIndex != -1) {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (_) => GameScreen(
                    isTournament: true,
                    tournamentLevel: TournamentLevel.levels[nextLvlIndex],
                  ),
                ),
              );
              return;
            } else {
              // Beaten all levels
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (_) => const HomeScreen()),
              );
              return;
            }
          }
          _resetGame();
        },
        onHome: () {
          if (game.mode == GameMode.multiplayer) {
             _mpService.disconnect();
          }
          Navigator.of(ctx).pop();
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (_) => const HomeScreen()),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListenableBuilder(
        listenable: ThemeController(),
        builder: (context, _) {
          List<Color> bgColors;
          if (ThemeController().currentTheme == BoardTheme.neonCyberpunk) {
            bgColors = [const Color(0xFF101216), Colors.black];
          } else if (ThemeController().currentTheme == BoardTheme.antiqueMarble) {
            bgColors = [const Color(0xFFE8E8E8), const Color(0xFFB0B0B0)];
          } else {
            bgColors = [AppTheme.tableWood, AppTheme.tableWoodDark];
          }

          return Container(
            decoration: BoxDecoration(
              gradient: RadialGradient(
                center: const Alignment(0, 0),
                radius: 1.5,
                colors: bgColors,
              ),
            ),
            child: SafeArea(
              child: Stack(
                children: [
              // Ana Oyun Düzeni
              Center(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final isWide = constraints.maxWidth > constraints.maxHeight;
                    
                    if (isWide) {
                      return _buildLandscapeLayout(constraints);
                    } else {
                      return _buildPortraitLayout(constraints);
                    }
                  },
                ),
              ),

              // Ayarlar ve Geri Butonu (Üst kısımlar)
              Positioned(
                top: 16,
                left: 16,
                child: IconButton(
                  onPressed: () {
                    if (game.mode == GameMode.multiplayer) {
                      _mpService.disconnect();
                    }
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (_) => const HomeScreen()),
                    );
                  },
                  icon: const Icon(Icons.arrow_back, color: AppTheme.textMuted),
                  tooltip: 'Ana Menü',
                ),
              ),
              if (!widget.isMultiplayer && !widget.isTournament)
                Positioned(
                  top: 16,
                  right: 16,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        onPressed: (game.mode == GameMode.pve && game.currentPlayer == Player.black) 
                          ? null 
                          : () {
                              setState(() {
                                aiOpponent ??= AIOpponent(game, currentDifficulty);
                                game.currentHint = aiOpponent!.getHintMove();
                              });
                            },
                        icon: Icon(
                          Icons.lightbulb_outline, 
                          color: (game.mode == GameMode.pve && game.currentPlayer == Player.black) 
                            ? AppTheme.textMuted 
                            : AppTheme.goldBright,
                        ),
                        tooltip: 'İpucu',
                      ),
                      if (game.canUndo)
                        IconButton(
                          onPressed: () {
                            setState(() {
                              game.undo();
                              // PvE modundaysa ve sıra yapay zekadaysa 1 adım daha geri al ki sıra tekrar oyuncuya geçsin
                              if (game.mode == GameMode.pve && game.currentPlayer == Player.black && game.canUndo) {
                                game.undo();
                              }
                            });
                          },
                          icon: const Icon(Icons.undo, color: AppTheme.goldBright),
                          tooltip: 'Geri Al',
                        ),
                      IconButton(
                        onPressed: _openSettings,
                        icon: const Icon(Icons.settings, color: AppTheme.gold),
                        tooltip: 'Ayarlar',
                      ),
                    ],
                  ),
                ),
              
                  // Üstte Ortada Durum Çubuğu
                  Positioned(
                    top: 16,
                    left: 0,
                    right: 0,
                    child: Center(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 400),
                        child: GameStatusBar(game: game),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildLandscapeLayout(BoxConstraints constraints) {
    // Geniş ekranda Sol Tepsi - Tahta - Sağ Tepsi düzeni
    return Padding(
      padding: const EdgeInsets.only(top: 80, bottom: 24, left: 24, right: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Sol Tepsi (2. Oyuncu / Siyah)
          TrayWidget(player: Player.black, game: game, isThinking: _isAiThinking),
          
          const SizedBox(width: 32),
          
          // Ana Tahta
          Expanded(
            child: Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: constraints.maxHeight - 120, // durum çubuğu ve padding için pay
                  maxHeight: constraints.maxHeight - 120,
                ),
                child: IgnorePointer(
                  ignoring: _isAiThinking,
                  child: GameBoard(game: game, onNodeTap: _onNodeTap),
                ),
              ),
            ),
          ),
          
          const SizedBox(width: 32),
          
          // Sağ Tepsi (1. Oyuncu / Beyaz)
          TrayWidget(player: Player.white, game: game, isThinking: false),
        ],
      ),
    );
  }

  Widget _buildPortraitLayout(BoxConstraints constraints) {
    // Dikey ekranda Üst Tepsi - Tahta - Alt Tepsi düzeni
    return Padding(
      padding: const EdgeInsets.only(top: 80, bottom: 24, left: 16, right: 16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Üst Tepsi (2. Oyuncu / Siyah) - Yatay modda göstermek için Row içinde
          SizedBox(
            height: 120,
            child: _buildHorizontalTray(Player.black),
          ),
          
          const SizedBox(height: 16),
          
          // Ana Tahta
          Expanded(
            child: Center(
              child: AspectRatio(
                aspectRatio: 1,
                child: IgnorePointer(
                  ignoring: _isAiThinking,
                  child: GameBoard(game: game, onNodeTap: _onNodeTap),
                ),
              ),
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Alt Tepsi (1. Oyuncu / Beyaz)
          SizedBox(
            height: 120,
            child: _buildHorizontalTray(Player.white),
          ),
        ],
      ),
    );
  }
  
  // Dikey mod için basit bir yatay tepsi görünümü
  Widget _buildHorizontalTray(Player player) {
    // Bu sadece Portrait mod için basit bir uyarlama
    int unplaced = game.piecesToPlace(player);
    int captured = game.captured[player] ?? 0;
    bool isWhite = player == Player.white;
    bool isActive = game.currentPlayer == player && game.phase != GamePhase.gameOver;

    return Container(
      decoration: BoxDecoration(
        color: AppTheme.tableWood,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isActive ? AppTheme.goldBright : AppTheme.boardFrameDark,
          width: isActive ? 3 : 2,
        ),
      ),
      child: Container(
        margin: const EdgeInsets.all(8),
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: AppTheme.trayLeather,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (_isAiThinking && player == Player.black)
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 10,
                          height: 10,
                          child: CircularProgressIndicator(strokeWidth: 2, color: AppTheme.goldBright),
                        ),
                        SizedBox(width: 4),
                        Text('DÜŞÜNÜYOR...', style: TextStyle(color: AppTheme.goldBright, fontSize: 8, fontStyle: FontStyle.italic)),
                      ],
                    )
                  else ...[
                    Text('BEKLEYEN ($unplaced)', style: const TextStyle(color: AppTheme.goldDark, fontSize: 10)),
                    const SizedBox(height: 4),
                    Wrap(
                      spacing: 4,
                      children: List.generate(unplaced > 5 ? 5 : unplaced, (index) => Icon(Icons.circle, color: isWhite ? AppTheme.whiteStone : AppTheme.blackStone, size: 16)),
                    ),
                  ],
                ],
              ),
            ),
            Container(width: 2, color: AppTheme.goldDark.withValues(alpha: 0.3)),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('ALINAN ($captured)', style: const TextStyle(color: AppTheme.textMuted, fontSize: 10)),
                  const SizedBox(height: 4),
                  Wrap(
                    spacing: 4,
                    children: List.generate(captured > 5 ? 5 : captured, (index) => Icon(Icons.circle, color: isWhite ? AppTheme.blackStone : AppTheme.whiteStone, size: 16)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _GameOverDialog extends StatefulWidget {
  const _GameOverDialog({
    Key? key,
    required this.winner,
    this.winnerName,
    required this.onNewGame,
    required this.onHome,
    this.isTournament = false,
    this.earnedStars = 0,
    this.pgnString,
  }) : super(key: key);

  final Player? winner;
  final String? winnerName;
  final VoidCallback onNewGame;
  final VoidCallback onHome;
  final bool isTournament;
  final int earnedStars;
  final String? pgnString;

  @override
  State<_GameOverDialog> createState() => _GameOverDialogState();
}

class _GameOverDialogState extends State<_GameOverDialog> {
  late ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(duration: const Duration(seconds: 3));
    if (widget.winner == Player.white) {
      _confettiController.play();
    }
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          Container(
            width: 320,
            padding: const EdgeInsets.all(28),
            decoration: BoxDecoration(
              color: AppTheme.surfaceDark,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: AppTheme.gold.withValues(alpha: 0.4),
                width: 2,
              ),
              boxShadow: [
                BoxShadow(
                  color: AppTheme.gold.withValues(alpha: 0.2),
                  blurRadius: 24,
                  spreadRadius: -4,
                ),
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.6),
                  blurRadius: 32,
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 72,
                  height: 72,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: const RadialGradient(
                      colors: [AppTheme.goldBright, AppTheme.goldDark],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppTheme.gold.withValues(alpha: 0.4),
                        blurRadius: 16,
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      widget.winner == null ? '🤝' : '🏆',
                      style: const TextStyle(fontSize: 34),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'OYUN BİTTİ!',
                  style: TextStyle(
                    color: AppTheme.goldBright,
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 3,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  widget.winner != null 
                      ? (widget.winner == Player.white 
                          ? 'Tebrikler ${widget.winnerName ?? StatsService().username} Kazandın!' 
                          : '${widget.winnerName ?? "Rakip"} Kazandı!')
                      : 'Berabere Bitti!',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: AppTheme.textSecondary,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                if (widget.isTournament && widget.winner == Player.white) ...[
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(3, (index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4.0),
                        child: Icon(
                          index < widget.earnedStars ? Icons.star : Icons.star_border,
                          color: index < widget.earnedStars ? AppTheme.goldBright : AppTheme.textMuted,
                          size: 32,
                        ),
                      );
                    }),
                  ),
                ],
                const SizedBox(height: 16),
                if (widget.pgnString != null && widget.pgnString!.isNotEmpty) ...[
                  ElevatedButton.icon(
                    onPressed: () {
                      flutter.Clipboard.setData(flutter.ClipboardData(text: widget.pgnString!));
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Hamleler panoya kopyalandı!'), duration: Duration(seconds: 2)),
                      );
                    },
                    icon: const Icon(Icons.copy, size: 18),
                    label: const Text('Maçı Paylaş'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.surfaceMid,
                      foregroundColor: AppTheme.textPrimary,
                    ),
                  ),
                ],
                const SizedBox(height: 28),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.surfaceMid,
                          foregroundColor: AppTheme.textSecondary,
                        ),
                        onPressed: widget.onHome,
                        child: Text(widget.isTournament && widget.winner == Player.white ? 'TURNUVALARA DÖN' : 'MENÜ'),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.goldDark,
                          foregroundColor: Colors.white,
                        ),
                        onPressed: widget.onNewGame,
                        child: Text(
                          widget.isTournament 
                            ? (widget.winner == Player.white 
                                 ? 'SONRAKİ SEVİYE' // For simplicity
                                 : 'TEKRAR DENE') 
                            : 'YENİ OYUN'
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
              ],
            ),
          ),
          if (widget.winner == Player.white)
            Positioned(
              top: -50,
              child: ConfettiWidget(
                confettiController: _confettiController,
                blastDirection: 3.14159 / 2, // PI / 2 (downwards)
                maxBlastForce: 5,
                minBlastForce: 2,
                emissionFrequency: 0.05,
                numberOfParticles: 20,
                gravity: 0.1,
              ),
            ),
        ],
      ),
    );
  }
}
