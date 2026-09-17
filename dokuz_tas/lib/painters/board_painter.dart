import 'dart:math';
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../theme/theme_controller.dart';

/// Premium 9 Taş oyun tahtası — ahşap çerçeve, mermer zemin, altın çizgiler.
class BoardPainter extends CustomPainter {
  const BoardPainter({
    this.selectedIndex,
    this.validMoveTargets = const [],
    this.removableIndices = const [],
    this.hintIndices = const [],
    this.lastFormedMill,
    this.lastMovedFrom,
    this.lastMovedTo,
    this.theme = BoardTheme.islamicWood,
  });

  final int? selectedIndex;
  final List<int> validMoveTargets;
  final List<int> removableIndices;
  final List<int> hintIndices;
  final List<int>? lastFormedMill;
  final int? lastMovedFrom;
  final int? lastMovedTo;
  final BoardTheme theme;

  // ── 24 nokta (normalize 0–1) ──
  static const points = <Offset>[
    // Dış kare: 0-7
    Offset(0, 0),       // 0  sol üst
    Offset(0.5, 0),     // 1  üst orta
    Offset(1, 0),       // 2  sağ üst
    Offset(1, 0.5),     // 3  sağ orta
    Offset(1, 1),       // 4  sağ alt
    Offset(0.5, 1),     // 5  alt orta
    Offset(0, 1),       // 6  sol alt
    Offset(0, 0.5),     // 7  sol orta
    // Orta kare: 8-15
    Offset(1 / 6, 1 / 6),       // 8
    Offset(0.5, 1 / 6),         // 9
    Offset(5 / 6, 1 / 6),       // 10
    Offset(5 / 6, 0.5),         // 11
    Offset(5 / 6, 5 / 6),       // 12
    Offset(0.5, 5 / 6),         // 13
    Offset(1 / 6, 5 / 6),       // 14
    Offset(1 / 6, 0.5),         // 15
    // İç kare: 16-23
    Offset(2 / 6, 2 / 6),       // 16
    Offset(0.5, 2 / 6),         // 17
    Offset(4 / 6, 2 / 6),       // 18
    Offset(4 / 6, 0.5),         // 19
    Offset(4 / 6, 4 / 6),       // 20
    Offset(0.5, 4 / 6),         // 21
    Offset(2 / 6, 4 / 6),       // 22
    Offset(2 / 6, 0.5),         // 23
  ];

  // Çizgi segmentleri
  static const _lines = <List<int>>[
    // Dış kare
    [0, 1], [1, 2], [2, 3], [3, 4], [4, 5], [5, 6], [6, 7], [7, 0],
    // Orta kare
    [8, 9], [9, 10], [10, 11], [11, 12], [12, 13], [13, 14], [14, 15], [15, 8],
    // İç kare
    [16, 17], [17, 18], [18, 19], [19, 20], [20, 21], [21, 22], [22, 23], [23, 16],
    // Bağlantılar
    [1, 9], [9, 17],
    [3, 11], [11, 19],
    [5, 13], [13, 21],
    [7, 15], [15, 23],
  ];

  Offset _toCanvas(int index, Size boardArea, Offset origin) {
    final p = points[index];
    return Offset(
      origin.dx + p.dx * boardArea.width,
      origin.dy + p.dy * boardArea.height,
    );
  }

  @override
  void paint(Canvas canvas, Size size) {
    // Biraz daha kalın çerçeve
    final frameThickness = size.width * 0.085;
    final cornerRadius = frameThickness * 0.25;

    // ── 1. Dış gölge (3D masa üstü derinliği) ──
    final shadowPaint = Paint()
      ..color = Colors.black.withValues(alpha: 0.75)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 20);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(8, 12, size.width, size.height),
        Radius.circular(cornerRadius),
      ),
      shadowPaint,
    );

    // ── 2. Ahşap çerçeve ──
    final frameRect = RRect.fromRectAndRadius(
      Offset.zero & size,
      Radius.circular(cornerRadius),
    );

    // Daha koyu, odunsu derinlik (Neon temasında metalik gri/siyah)
    List<Color> frameColors;
    if (theme == BoardTheme.neonCyberpunk) {
      frameColors = [const Color(0xFF202225), const Color(0xFF141517), const Color(0xFF090A0C), Colors.black];
    } else if (theme == BoardTheme.antiqueMarble) {
      frameColors = [const Color(0xFFB0B0B0), const Color(0xFF8A8A8A), const Color(0xFF5A5A5A), const Color(0xFF333333)];
    } else {
      frameColors = [
        AppTheme.boardFrameLight,
        AppTheme.boardFrame,
        AppTheme.boardFrameDark,
        AppTheme.boardFrameDark.withValues(alpha: 0.8),
      ];
    }

    final framePaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: frameColors,
        stops: const [0.0, 0.4, 0.8, 1.0],
      ).createShader(Offset.zero & size);

    canvas.drawRRect(frameRect, framePaint);

    // Dış parlama (Işık yansıması efekti)
    canvas.drawRRect(
      frameRect,
      Paint()
        ..style = PaintingStyle.stroke
        ..color = Colors.white.withValues(alpha: 0.1)
        ..strokeWidth = 2,
    );

    // Çerçeve kenar çizgisi
    canvas.drawRRect(
      frameRect,
      Paint()
        ..style = PaintingStyle.stroke
        ..color = AppTheme.goldDark.withValues(alpha: 0.4)
        ..strokeWidth = 1.5,
    );

    // ── 3. İç altın kenarlık ──
    final innerBorderRect = RRect.fromRectAndRadius(
      Rect.fromLTRB(
        frameThickness - 2,
        frameThickness - 2,
        size.width - frameThickness + 2,
        size.height - frameThickness + 2,
      ),
      Radius.circular(cornerRadius * 0.3),
    );
    canvas.drawRRect(
      innerBorderRect,
      Paint()
        ..style = PaintingStyle.stroke
        ..color = AppTheme.gold.withValues(alpha: 0.6)
        ..strokeWidth = 2.5,
    );

    // ── 4. Zemin ──
    final marbleRect = Rect.fromLTRB(
      frameThickness,
      frameThickness,
      size.width - frameThickness,
      size.height - frameThickness,
    );

    List<Color> bgColors;
    if (theme == BoardTheme.neonCyberpunk) {
      bgColors = [const Color(0xFF0B0F19), const Color(0xFF05080F), const Color(0xFF030509), const Color(0xFF010204), Colors.black];
    } else if (theme == BoardTheme.antiqueMarble) {
      bgColors = [const Color(0xFFF7F7F7), const Color(0xFFEDEDED), const Color(0xFFD6D6D6), const Color(0xFFEDEDED), const Color(0xFFF7F7F7)];
    } else {
      bgColors = [
        AppTheme.boardMarbleLight,
        AppTheme.boardMarble,
        AppTheme.boardMarbleDark,
        AppTheme.boardMarble,
        AppTheme.boardMarbleLight,
      ];
    }

    final marblePaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: bgColors,
        stops: const [0.0, 0.25, 0.5, 0.75, 1.0],
      ).createShader(marbleRect);

    canvas.drawRect(marbleRect, marblePaint);

    // Zemin doku efekti — ince damarlar veya gridler
    if (theme == BoardTheme.neonCyberpunk) {
      final gridPaint = Paint()
        ..color = Colors.cyan.withValues(alpha: 0.05)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.0;
      
      // Çizgili grid çiz (basit)
      for (double x = marbleRect.left; x < marbleRect.right; x += 30) {
        canvas.drawLine(Offset(x, marbleRect.top), Offset(x, marbleRect.bottom), gridPaint);
      }
      for (double y = marbleRect.top; y < marbleRect.bottom; y += 30) {
        canvas.drawLine(Offset(marbleRect.left, y), Offset(marbleRect.right, y), gridPaint);
      }
    } else {
      final veinPaint = Paint()
        ..color = theme == BoardTheme.antiqueMarble ? Colors.black.withValues(alpha: 0.05) : AppTheme.boardMarbleDark.withValues(alpha: 0.12)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 0.8;

      final rng = Random(42); // Deterministik damarlar
      for (var i = 0; i < 8; i++) {
        final path = Path();
        var x = marbleRect.left + rng.nextDouble() * marbleRect.width;
        var y = marbleRect.top + rng.nextDouble() * marbleRect.height;
        path.moveTo(x, y);
        for (var j = 0; j < 5; j++) {
          x += (rng.nextDouble() - 0.5) * marbleRect.width * 0.3;
          y += (rng.nextDouble() - 0.3) * marbleRect.height * 0.2;
          path.lineTo(x.clamp(marbleRect.left, marbleRect.right),
              y.clamp(marbleRect.top, marbleRect.bottom));
        }
        canvas.drawPath(path, veinPaint);
      }
    }

    // ── 5. Köşe aksesuarları (pirinç çıkıntılar) ──
    _drawCornerStuds(canvas, size, frameThickness, cornerRadius);

    // ── 6. Oyun çizgileri ──
    final boardArea = Size(marbleRect.width * 0.82, marbleRect.height * 0.82);
    final boardOrigin = Offset(
      marbleRect.left + (marbleRect.width - boardArea.width) / 2,
      marbleRect.top + (marbleRect.height - boardArea.height) / 2,
    );

    // Altın çizgi gölgesi
    final lineShadow = Paint()
      ..color = Colors.black.withValues(alpha: 0.2)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4.5
      ..strokeCap = StrokeCap.round;

    for (final seg in _lines) {
      final a = _toCanvas(seg[0], boardArea, boardOrigin) + const Offset(1, 1.5);
      final b = _toCanvas(seg[1], boardArea, boardOrigin) + const Offset(1, 1.5);
      canvas.drawLine(a, b, lineShadow);
    }

    // Altın / Neon çizgiler
    List<Color> lineColors;
    if (theme == BoardTheme.neonCyberpunk) {
      lineColors = [Colors.cyan, Colors.cyanAccent, Colors.cyan, Colors.cyanAccent];
    } else if (theme == BoardTheme.antiqueMarble) {
      lineColors = [const Color(0xFF6E6E6E), const Color(0xFF8C8C8C), const Color(0xFF6E6E6E), const Color(0xFF8C8C8C)];
    } else {
      lineColors = [AppTheme.goldDark, AppTheme.goldBright, AppTheme.gold, AppTheme.goldBright];
    }

    final linePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0
      ..strokeCap = StrokeCap.round
      ..shader = LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: lineColors,
      ).createShader(marbleRect);

    if (theme == BoardTheme.neonCyberpunk) {
      linePaint.maskFilter = const MaskFilter.blur(BlurStyle.solid, 4); // Neon glow for lines
    }

    for (final seg in _lines) {
      final a = _toCanvas(seg[0], boardArea, boardOrigin);
      final b = _toCanvas(seg[1], boardArea, boardOrigin);
      canvas.drawLine(a, b, linePaint);
    }

    // ── 6.5. Mill Parlaması (lastFormedMill) ──
    if (lastFormedMill != null && lastFormedMill!.length == 3) {
      final p1 = _toCanvas(lastFormedMill![0], boardArea, boardOrigin);
      final p2 = _toCanvas(lastFormedMill![1], boardArea, boardOrigin);
      final p3 = _toCanvas(lastFormedMill![2], boardArea, boardOrigin);

      final glowPaint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 8.0
        ..strokeCap = StrokeCap.round
        ..color = AppTheme.goldBright.withValues(alpha: 0.8)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);

      final corePaint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3.0
        ..strokeCap = StrokeCap.round
        ..color = Colors.white;

      // Draw glow
      canvas.drawLine(p1, p2, glowPaint);
      canvas.drawLine(p2, p3, glowPaint);
      
      // Draw core
      canvas.drawLine(p1, p2, corePaint);
      canvas.drawLine(p2, p3, corePaint);
    }

    // ── 6.6. Son Hamle İzi (Move Trail) ──
    if (lastMovedFrom != null && lastMovedTo != null) {
      final pFrom = _toCanvas(lastMovedFrom!, boardArea, boardOrigin);
      final pTo = _toCanvas(lastMovedTo!, boardArea, boardOrigin);

      // Dash/Dot effect for trail
      final trailPaint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.0
        ..strokeCap = StrokeCap.round
        ..color = AppTheme.goldBright.withValues(alpha: 0.6);

      // Draw dashed line or a simple semi-transparent thick line
      final thickTrailPaint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 6.0
        ..strokeCap = StrokeCap.round
        ..color = AppTheme.gold.withValues(alpha: 0.3)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);

      canvas.drawLine(pFrom, pTo, thickTrailPaint);
      
      // Arrow head or just dots on from/to
      canvas.drawCircle(pFrom, 4, Paint()..color = AppTheme.gold.withValues(alpha: 0.5));
    }

    // ── 7. Kesişim noktaları ──
    for (var i = 0; i < points.length; i++) {
      final center = _toCanvas(i, boardArea, boardOrigin);
      final isSelected = selectedIndex == i;
      final isValidTarget = validMoveTargets.contains(i);
      final isRemovable = removableIndices.contains(i);
      final isHint = hintIndices.contains(i);

      // Altın nokta gölge
      if (theme != BoardTheme.neonCyberpunk) {
        canvas.drawCircle(
          center + const Offset(0.8, 1.2),
          isSelected ? 7 : 5,
          Paint()..color = Colors.black.withValues(alpha: 0.3),
        );
      }

      // Altın / Neon nokta
      List<Color> dotColors;
      if (theme == BoardTheme.neonCyberpunk) {
        dotColors = [Colors.cyanAccent, Colors.cyan, Colors.blue];
      } else if (theme == BoardTheme.antiqueMarble) {
        dotColors = [const Color(0xFFAAAAAA), const Color(0xFF888888), const Color(0xFF555555)];
      } else {
        dotColors = [AppTheme.goldBright, AppTheme.gold, AppTheme.goldDark];
      }

      final dotPaint = Paint()
        ..shader = RadialGradient(
          colors: dotColors,
        ).createShader(Rect.fromCircle(center: center, radius: 6));

      canvas.drawCircle(center, isSelected ? 7 : 5, dotPaint);

      // Seçili nokta parlama efekti
      if (isSelected) {
        canvas.drawCircle(
          center,
          12,
          Paint()
            ..color = AppTheme.goldBright.withValues(alpha: 0.25)
            ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6),
        );
      }

      // Geçerli hedef göstergesi
      if (isValidTarget) {
        canvas.drawCircle(
          center,
          9,
          Paint()
            ..color = AppTheme.success.withValues(alpha: 0.4)
            ..style = PaintingStyle.stroke
            ..strokeWidth = 2.5,
        );
        canvas.drawCircle(
          center,
          4,
          Paint()..color = AppTheme.success.withValues(alpha: 0.5),
        );
      }

      // Kaldırılabilir taş göstergesi
      if (isRemovable) {
        canvas.drawCircle(
          center,
          14,
          Paint()
            ..color = AppTheme.danger.withValues(alpha: 0.35)
            ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4),
        );
      }

      // İpucu (Hint) göstergesi
      if (isHint) {
        canvas.drawCircle(
          center,
          16,
          Paint()
            ..color = Colors.blueAccent.withValues(alpha: 0.6)
            ..style = PaintingStyle.stroke
            ..strokeWidth = 3.0
            ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3),
        );
      }
    }
  }

  void _drawCornerStuds(
      Canvas canvas, Size size, double frameThickness, double cornerRadius) {
    final studSize = frameThickness * 0.42;
    final inset = frameThickness * 0.32;

    final corners = [
      Offset(inset, inset),
      Offset(size.width - inset, inset),
      Offset(size.width - inset, size.height - inset),
      Offset(inset, size.height - inset),
    ];

    for (final center in corners) {
      // Gölge
      canvas.drawCircle(
        center + const Offset(1, 1.5),
        studSize * 0.6,
        Paint()..color = Colors.black.withValues(alpha: 0.4),
      );

      // Ana gövde
      final studPaint = Paint()
        ..shader = RadialGradient(
          center: const Alignment(-0.3, -0.3),
          colors: [
            AppTheme.cornerStudHighlight,
            AppTheme.cornerStud,
            AppTheme.goldDark,
          ],
          stops: const [0.0, 0.5, 1.0],
        ).createShader(
            Rect.fromCircle(center: center, radius: studSize * 0.6));

      // Piramit şekli (döndürülmüş kare)
      final path = Path();
      path.moveTo(center.dx, center.dy - studSize * 0.5);
      path.lineTo(center.dx + studSize * 0.5, center.dy);
      path.lineTo(center.dx, center.dy + studSize * 0.5);
      path.lineTo(center.dx - studSize * 0.5, center.dy);
      path.close();

      canvas.drawPath(path, studPaint);

      // Piramit kenarlık
      canvas.drawPath(
        path,
        Paint()
          ..style = PaintingStyle.stroke
          ..color = AppTheme.goldDark.withValues(alpha: 0.5)
          ..strokeWidth = 0.8,
      );

      // Parlama noktası
      canvas.drawCircle(
        center + Offset(-studSize * 0.12, -studSize * 0.12),
        studSize * 0.12,
        Paint()..color = Colors.white.withValues(alpha: 0.4),
      );
    }
  }

  @override
  bool shouldRepaint(covariant BoardPainter old) =>
      old.selectedIndex != selectedIndex ||
      old.validMoveTargets != validMoveTargets ||
      old.removableIndices != removableIndices ||
      old.hintIndices != hintIndices ||
      old.lastFormedMill != lastFormedMill ||
      old.lastMovedFrom != lastMovedFrom ||
      old.lastMovedTo != lastMovedTo ||
      old.theme != theme;
}
