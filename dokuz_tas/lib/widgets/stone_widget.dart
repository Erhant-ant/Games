import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../theme/theme_controller.dart';

/// Animasyonlu premium taş widget'ı — AI görseli + glow efekti.
class StoneWidget extends StatelessWidget {
  const StoneWidget({
    super.key,
    required this.player,
    this.size = 36,
    this.selected = false,
    this.removable = false,
    this.isValidTarget = false,
    this.onTap,
    this.animate = true,
  });

  final String player; // 'white' veya 'black'
  final double size;
  final bool selected;
  final bool removable;
  final bool isValidTarget;
  final VoidCallback? onTap;
  final bool animate;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedScale(
        scale: selected ? 1.15 : 1.0,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOutBack,
        child: ListenableBuilder(
          listenable: ThemeController(),
          builder: (context, _) {
            final theme = ThemeController();
            return AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: size,
              height: size,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  if (selected)
                    BoxShadow(
                      color: AppTheme.goldBright.withValues(alpha: 0.5),
                      blurRadius: 14,
                      spreadRadius: 2,
                    ),
                  if (removable)
                    BoxShadow(
                      color: AppTheme.danger.withValues(alpha: 0.5),
                      blurRadius: 12,
                      spreadRadius: 1,
                    ),
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.5),
                    blurRadius: 6,
                    offset: const Offset(2, 3),
                  ),
                ],
              ),
              child: Container(
                width: size,
                height: size,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: player == 'white' 
                      ? Colors.white.withValues(alpha: 0.9) 
                      : AppTheme.blackStoneBorder.withValues(alpha: 0.7),
                    width: 1.5,
                  ),
                  image: DecorationImage(
                    image: AssetImage(
                      player == 'white'
                          ? theme.whiteStoneImage
                          : theme.blackStoneImage,
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
                // Inner shadow / Parlama efekti ekleyerek 3D hissini pekiştirelim
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      center: const Alignment(-0.3, -0.3),
                      radius: 0.8,
                      colors: [
                        Colors.white.withValues(alpha: player == 'white' ? 0.3 : 0.1),
                        Colors.transparent,
                        Colors.black.withValues(alpha: 0.4),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

/// Boş nokta göstergesi — dokunulabilir alan.
class EmptyNodeWidget extends StatelessWidget {
  const EmptyNodeWidget({
    super.key,
    this.size = 44,
    this.isValidTarget = false,
    this.onTap,
  });

  final double size;
  final bool isValidTarget;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: size,
        height: size,
        child: isValidTarget
            ? Center(
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  width: size * 0.45,
                  height: size * 0.45,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppTheme.success.withValues(alpha: 0.35),
                    border: Border.all(
                      color: AppTheme.success.withValues(alpha: 0.6),
                      width: 2,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppTheme.success.withValues(alpha: 0.3),
                        blurRadius: 8,
                      ),
                    ],
                  ),
                ),
              )
            : null,
      ),
    );
  }
}
