import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../../core/models/store_models.dart';
import '../../../../core/state/product_stats_state.dart';
import 'favorite_button.dart';

class ProductGrid extends StatelessWidget {
  const ProductGrid({super.key, required this.products, required this.isDesktop, required this.onAddToCart, required this.onProductSelected});

  final List<StoreProduct> products;
  final bool isDesktop;
  final ValueChanged<StoreProduct> onAddToCart;
  final ValueChanged<StoreProduct> onProductSelected;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: products.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: isDesktop ? 4 : 2,
        mainAxisSpacing: 18,
        crossAxisSpacing: 16,
        childAspectRatio: isDesktop ? 0.58 : 0.53, // Adjusted to fit stats
      ),
      itemBuilder: (_, index) => _ProductCard(product: products[index], onAdd: () => onAddToCart(products[index]), onTap: () => onProductSelected(products[index])),
    );
  }
}

class _ProductCard extends StatefulWidget {
  const _ProductCard({required this.product, required this.onAdd, required this.onTap});

  final StoreProduct product;
  final VoidCallback onAdd;
  final VoidCallback onTap;

  @override
  State<_ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<_ProductCard> {
  bool _hovered = false;
  bool _addedFeedback = false;

  void _handleAdd() {
    widget.onAdd();
    setState(() => _addedFeedback = true);
    Future.delayed(const Duration(milliseconds: 1200), () {
      if (mounted) setState(() => _addedFeedback = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context);
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedScale(
        scale: _hovered ? 1.03 : 1.0,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(17),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: _hovered ? 0.15 : 0.06),
                blurRadius: _hovered ? 22 : 14,
                offset: Offset(0, _hovered ? 10 : 5),
              ),
            ],
          ),
          child: InkWell(
            onTap: widget.onTap,
            borderRadius: BorderRadius.circular(17),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Stack(
                    children: [
                      ClipRRect(
                        borderRadius: const BorderRadius.vertical(top: Radius.circular(17)),
                        child: SizedBox(
                          width: double.infinity,
                          child: Image.network(
                            widget.product.imageUrl,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => Container(color: const Color(0xFFE9E3D7)),
                          ),
                        ),
                      ),
                      Positioned(
                        top: 11,
                        left: 11,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
                          decoration: BoxDecoration(color: AppColors.cream, borderRadius: BorderRadius.circular(10)),
                          child: Text(strings.text('handmade'), style: const TextStyle(color: AppColors.terracotta, fontSize: 10, fontWeight: FontWeight.bold)),
                        ),
                      ),
                      Positioned(
                        top: 11,
                        right: 11,
                        child: FavoriteButton(productId: widget.product.id),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(13, 13, 13, 14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(widget.product.weight, style: const TextStyle(color: Colors.black45, fontSize: 12)),
                      const SizedBox(height: 4),
                      Text(widget.product.name, maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(color: AppColors.ink, fontSize: 16, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 11),
                      if (widget.product.oldPrice != null)
                        Row(
                          children: [
                            Text(widget.product.oldPrice!, style: const TextStyle(color: Colors.grey, fontSize: 13, decoration: TextDecoration.lineThrough)),
                            const SizedBox(width: 6),
                            Text(widget.product.price, style: const TextStyle(color: AppColors.terracotta, fontWeight: FontWeight.bold, fontSize: 16)),
                          ],
                        )
                      else
                        Text(widget.product.price, style: const TextStyle(color: AppColors.forest, fontWeight: FontWeight.bold, fontSize: 16)),
                      const SizedBox(height: 10),
                      
                      // Synchronized Product Stats
                      ValueListenableBuilder<bool>(
                        valueListenable: ProductStatsState.instance,
                        builder: (context, toggleValue, child) {
                          final cartCount = ProductStatsState.instance.getCartCount(widget.product.id);
                          final viewCount = ProductStatsState.instance.getViewCount(widget.product.id);
                          
                          return SizedBox(
                            height: 20,
                            child: AnimatedSwitcher(
                              duration: const Duration(milliseconds: 500),
                              transitionBuilder: (child, animation) {
                                return SlideTransition(
                                  position: Tween<Offset>(
                                    begin: const Offset(0, 0.5),
                                    end: Offset.zero,
                                  ).animate(animation),
                                  child: FadeTransition(opacity: animation, child: child),
                                );
                              },
                              child: toggleValue
                                  ? Row(
                                      key: const ValueKey('cart_stats'),
                                      children: [
                                        const Text('🔥 ', style: TextStyle(fontSize: 12)),
                                        Expanded(child: Text(strings.isTurkish ? 'Son 7 günde $cartCount kişi sepete ekledi' : '$cartCount added to cart recently', style: const TextStyle(fontSize: 10, color: AppColors.terracotta, fontWeight: FontWeight.w600), maxLines: 1, overflow: TextOverflow.ellipsis)),
                                      ],
                                    )
                                  : Row(
                                      key: const ValueKey('view_stats'),
                                      children: [
                                        const Text('👁️ ', style: TextStyle(fontSize: 12)),
                                        Expanded(child: Text(strings.isTurkish ? 'Son 7 günde $viewCount kişi inceledi' : '$viewCount viewed recently', style: const TextStyle(fontSize: 10, color: Colors.blueGrey, fontWeight: FontWeight.w600), maxLines: 1, overflow: TextOverflow.ellipsis)),
                                      ],
                                    ),
                            ),
                          );
                        },
                      ),
                      
                      const SizedBox(height: 10),
                      SizedBox(
                        width: double.infinity,
                        child: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 250),
                          child: _addedFeedback
                              ? FilledButton.icon(
                                  key: const ValueKey('added'),
                                  onPressed: null,
                                  icon: const Icon(Icons.check_rounded, size: 16),
                                  label: Text(strings.text('added')),
                                  style: FilledButton.styleFrom(
                                    backgroundColor: AppColors.olive,
                                    disabledBackgroundColor: AppColors.olive,
                                    disabledForegroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(vertical: 10),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(9)),
                                    textStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                                  ),
                                )
                              : FilledButton.icon(
                                  key: const ValueKey('add'),
                                  onPressed: _handleAdd,
                                  icon: const Icon(Icons.shopping_cart_outlined, size: 16),
                                  label: Text(strings.text('addToCart')),
                                  style: FilledButton.styleFrom(
                                    backgroundColor: AppColors.forest,
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(vertical: 10),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(9)),
                                    textStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                                  ),
                                ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
