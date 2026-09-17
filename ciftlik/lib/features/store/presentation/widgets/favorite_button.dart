import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/state/favorite_state.dart';

class FavoriteButton extends StatelessWidget {
  const FavoriteButton({super.key, required this.productId, this.size = 20, this.padding = 6});

  final String productId;
  final double size;
  final double padding;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: FavoriteState.instance,
      builder: (context, favorites, _) {
        final isFavorite = favorites.contains(productId);
        return Material(
          color: Colors.white.withValues(alpha: 0.9),
          shape: const CircleBorder(),
          elevation: 2,
          child: InkWell(
            customBorder: const CircleBorder(),
            onTap: () => FavoriteState.instance.toggleFavorite(productId),
            child: Padding(
              padding: EdgeInsets.all(padding),
              child: Icon(
                isFavorite ? Icons.favorite_rounded : Icons.favorite_outline_rounded,
                color: isFavorite ? AppColors.terracotta : Colors.black45,
                size: size,
              ),
            ),
          ),
        );
      },
    );
  }
}
