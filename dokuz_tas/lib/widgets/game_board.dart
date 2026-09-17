import 'package:flutter/material.dart';
import '../models/game_logic.dart';
import '../painters/board_painter.dart';
import '../theme/theme_controller.dart';
import 'stone_widget.dart';

/// Oyun tahtası widget'ı — tahta çizimi + taş yerleşimi.
class GameBoard extends StatefulWidget {
  const GameBoard({
    super.key,
    required this.game,
    required this.onNodeTap,
  });

  final DokuzTasGame game;
  final ValueChanged<int> onNodeTap;

  @override
  State<GameBoard> createState() => _GameBoardState();
}

class _PieceRenderData {
  final String id;
  final Player player;
  int? boardIndex;
  int? lastKnownIndex;
  bool isCaptured = false;

  _PieceRenderData(this.id, this.player);
}

class _GameBoardState extends State<GameBoard> {
  late List<_PieceRenderData> _pieces;

  @override
  void initState() {
    super.initState();
    _initPieces();
    _syncPiecesWithBoard();
  }

  void _initPieces() {
    _pieces = [];
    for (int i = 0; i < 9; i++) {
      _pieces.add(_PieceRenderData('w$i', Player.white));
      _pieces.add(_PieceRenderData('b$i', Player.black));
    }
  }

  @override
  void didUpdateWidget(GameBoard oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Oyun tamamen sıfırlanmışsa taşları da sıfırla
    if (widget.game.turnNumber == 1 && widget.game.phase == GamePhase.placing && widget.game.placed[Player.white] == 0) {
      _initPieces();
    }
    _syncPiecesWithBoard();
  }

  void _syncPiecesWithBoard() {
    final board = widget.game.board;
    
    // 1. Tahtadan kaldırılan (kırılan) taşları tespit et ve isCaptured yap
    for (var piece in _pieces) {
      if (piece.boardIndex != null && !piece.isCaptured) {
        if (board[piece.boardIndex!] != piece.player) {
          // Ya kırıldı, ya da hareket etti.
          // Eğer board[piece.boardIndex] boşsa ve bu taş başka bir yere hareket etmemişse,
          // hareket mi etti kırıldı mı anlamak için genel board sayımına bakılır, 
          // ama daha kolayı: board üzerinden gidip eşleştirmektir.
        }
      }
    }

    // Tahtadaki mevcut durumu parçalarla eşleştirelim.
    // Çoklu hareketleri önlemek için tahtadaki her dolu index için bir taş bulmalıyız.
    Set<int> occupiedIndices = {};
    for (int i = 0; i < board.length; i++) {
      if (board[i] != null) occupiedIndices.add(i);
    }

    // Önce zaten doğru yerde olan taşları işaretle
    List<_PieceRenderData> correctlyPlaced = [];
    for (var piece in _pieces) {
      if (piece.boardIndex != null && occupiedIndices.contains(piece.boardIndex) && board[piece.boardIndex!] == piece.player) {
        correctlyPlaced.add(piece);
        occupiedIndices.remove(piece.boardIndex);
      }
    }

    // Geriye kalan occupiedIndices (yeni hedefler) için taş bul
    for (int targetIndex in occupiedIndices) {
      Player targetPlayer = board[targetIndex]!;
      
      // 1. Öncelik: Hatalı yerde (eski pozisyonda) kalmış ama tahtada olan bir taş var mı? (Hareket etmiş taş)
      _PieceRenderData? movingPiece;
      for (var p in _pieces) {
        if (p.player == targetPlayer && p.boardIndex != null && !correctlyPlaced.contains(p) && !p.isCaptured) {
          movingPiece = p;
          break;
        }
      }

      if (movingPiece != null) {
        movingPiece.boardIndex = targetIndex;
        movingPiece.lastKnownIndex = targetIndex;
        correctlyPlaced.add(movingPiece);
      } else {
        // 2. Tahtada değilse, demek ki yeni yerleştiriliyor (Placing fazı)
        _PieceRenderData? unplacedPiece;
        for (var p in _pieces) {
          if (p.player == targetPlayer && p.boardIndex == null && !p.isCaptured) {
            unplacedPiece = p;
            break;
          }
        }
        if (unplacedPiece != null) {
          unplacedPiece.boardIndex = targetIndex;
          unplacedPiece.lastKnownIndex = targetIndex;
          correctlyPlaced.add(unplacedPiece);
        }
      }
    }

    // Artık correctlyPlaced içinde olmayan ve boardIndex'i null olmayan taşlar kırılmıştır
    for (var piece in _pieces) {
      if (piece.boardIndex != null && !correctlyPlaced.contains(piece)) {
        piece.isCaptured = true;
        piece.boardIndex = null;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final game = widget.game;
    return AspectRatio(
      aspectRatio: 1,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final size = constraints.biggest;
          final frameThickness = size.width * 0.07;
          final marbleArea = Size(
            size.width - frameThickness * 2,
            size.height - frameThickness * 2,
          );
          final boardArea = Size(
            marbleArea.width * 0.82,
            marbleArea.height * 0.82,
          );
          final boardOrigin = Offset(
            frameThickness + (marbleArea.width - boardArea.width) / 2,
            frameThickness + (marbleArea.height - boardArea.height) / 2,
          );

          // Olası hedef noktaları hesapla
          List<int> validMoves = [];
          if (game.phase == GamePhase.moving && game.selectedIndex != null) {
            validMoves = game.getValidMoves(game.selectedIndex!);
          }

          List<int> removable = [];
          if (game.phase == GamePhase.removing) {
            removable = game.getRemovablePieces();
          }

          return Stack(
            children: [
              // Tahta çizimi
              Positioned.fill(
                child: ListenableBuilder(
                  listenable: ThemeController(),
                  builder: (context, _) {
                    return CustomPaint(
                      painter: BoardPainter(
                        selectedIndex: game.selectedIndex,
                        validMoveTargets: validMoves,
                        removableIndices: removable,
                        hintIndices: game.currentHint ?? [],
                        lastFormedMill: game.lastFormedMill,
                        lastMovedFrom: game.lastMovedPieceFrom,
                        lastMovedTo: game.lastMovedPieceTo,
                        theme: ThemeController().currentTheme,
                      ),
                    );
                  }
                ),
              ),
              // Boş Noktalar (Tıklama alanları)
              for (var i = 0; i < DokuzTasGame.boardSize; i++)
                _buildEmptyNode(
                  index: i,
                  boardArea: boardArea,
                  boardOrigin: boardOrigin,
                  validMoves: validMoves,
                  totalSize: size,
                ),
              // Taşlar (AnimatedPositioned ile)
              for (var piece in _pieces)
                ListenableBuilder(
                  listenable: ThemeController(),
                  builder: (context, _) {
                    return _buildAnimatedPiece(
                      piece: piece,
                      boardArea: boardArea,
                      boardOrigin: boardOrigin,
                      removable: removable,
                      totalSize: size,
                    );
                  }
                ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildEmptyNode({
    required int index,
    required Size boardArea,
    required Offset boardOrigin,
    required List<int> validMoves,
    required Size totalSize,
  }) {
    final point = BoardPainter.points[index];
    final nodeSize = totalSize.width * 0.10;
    final centerX = boardOrigin.dx + point.dx * boardArea.width;
    final centerY = boardOrigin.dy + point.dy * boardArea.height;
    
    final isValidTarget = validMoves.contains(index);

    return Positioned(
      left: centerX - nodeSize / 2,
      top: centerY - nodeSize / 2,
      width: nodeSize,
      height: nodeSize,
      child: EmptyNodeWidget(
        size: nodeSize,
        isValidTarget: isValidTarget || (widget.game.phase == GamePhase.placing),
        onTap: () { widget.onNodeTap(index); },
      ),
    );
  }

  Widget _buildAnimatedPiece({
    required _PieceRenderData piece,
    required Size boardArea,
    required Offset boardOrigin,
    required List<int> removable,
    required Size totalSize,
  }) {
    if (piece.lastKnownIndex == null) {
      // Taş henüz hiç oyuna girmedi
      return const SizedBox();
    }

    final point = BoardPainter.points[piece.lastKnownIndex!];
    final nodeSize = totalSize.width * 0.10;
    final stoneSize = totalSize.width * 0.078;
    final centerX = boardOrigin.dx + point.dx * boardArea.width;
    final centerY = boardOrigin.dy + point.dy * boardArea.height;

    final isSelected = widget.game.selectedIndex == piece.boardIndex;
    final isRemovable = piece.boardIndex != null && removable.contains(piece.boardIndex);
    
    final bool isVisible = piece.boardIndex != null;

    return AnimatedPositioned(
      key: ValueKey(piece.id),
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeOutCubic,
      left: centerX - nodeSize / 2,
      top: centerY - nodeSize / 2,
      width: nodeSize,
      height: nodeSize,
      child: Center(
        child: AnimatedOpacity(
          duration: const Duration(milliseconds: 300),
          opacity: isVisible ? 1.0 : 0.0,
          child: AnimatedScale(
            duration: const Duration(milliseconds: 400),
            scale: isVisible ? 1.0 : 0.1,
            curve: Curves.easeOutBack,
            child: StoneWidget(
              player: piece.player == Player.white ? 'white' : 'black',
              size: stoneSize,
              selected: isSelected,
              removable: isRemovable,
              onTap: () {
                if (isVisible) widget.onNodeTap(piece.boardIndex!);
              },
            ),
          ),
        ),
      ),
    );
  }
}
