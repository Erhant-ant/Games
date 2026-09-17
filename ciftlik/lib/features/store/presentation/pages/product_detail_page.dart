import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../../core/models/store_models.dart';
import '../widgets/favorite_button.dart';
import '../../../../core/state/cart_state.dart';
import '../../data/store_data.dart';
import '../../../checkout/presentation/pages/checkout_page.dart';
import '../widgets/app_footer.dart';
import '../widgets/app_header.dart';
import '../widgets/cart_drawer.dart';
import '../widgets/mobile_drawer.dart';
import '../widgets/mobile_bottom_nav.dart';
import '../widgets/brand_refresh_indicator.dart';

class ProductDetailPage extends StatefulWidget {
  const ProductDetailPage({
    super.key,
    required this.product,
    required this.onLanguageChanged,
  });

  final StoreProduct product;
  final ValueChanged<String> onLanguageChanged;

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  late StoreProduct _currentProduct;
  int _quantity = 1;
  bool _addedToCart = false;

  @override
  void initState() {
    super.initState();
    _currentProduct = widget.product;
  }

  @override
  void didUpdateWidget(ProductDetailPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.product.id != oldWidget.product.id) {
      _currentProduct = widget.product;
    }
  }

  void _handleAddToCart() {
    CartState.instance.add(_currentProduct, _quantity);
    setState(() => _addedToCart = true);
    Future.delayed(const Duration(milliseconds: 1200), () {
      if (mounted) setState(() => _addedToCart = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context);
    final isDesktop = MediaQuery.sizeOf(context).width >= 900;
    final isCompact = MediaQuery.sizeOf(context).width < 680;
    
    final allProducts = StoreData.products(strings.isTurkish);
    final variantOptions = _currentProduct.optionsGroup != null
        ? allProducts.where((p) => p.optionsGroup == _currentProduct.optionsGroup).toList()
        : <StoreProduct>[];

    return Scaffold(
      key: _scaffoldKey,
      drawer: isDesktop ? null : MobileDrawer(onLanguageChanged: widget.onLanguageChanged),
      bottomNavigationBar: isDesktop ? null : const MobileBottomNav(),
      endDrawer: ValueListenableBuilder(
        valueListenable: CartState.instance,
        builder: (context, cartItems, child) => CartDrawer(
          items: cartItems,
          onQuantityChanged: CartState.instance.changeQuantity,
          onRemove: CartState.instance.remove,
          onCheckout: () {
            Navigator.of(context).pop();
            Navigator.of(context).push(
              MaterialPageRoute<void>(builder: (_) => CheckoutPage(items: List.of(cartItems))),
            );
          },
        ),
      ),
      body: BrandRefreshIndicator(
          onRefresh: () async {
            await Future<void>.delayed(const Duration(milliseconds: 1500));
            if (mounted) setState(() {});
          },
          child: CustomScrollView(
        slivers: [
          ...buildStoreHeaderSlivers(
            isDesktop: isDesktop,
            onLanguageChanged: widget.onLanguageChanged,
            onCartTap: () => _scaffoldKey.currentState?.openEndDrawer(),
            strings: strings,
          ),
          SliverToBoxAdapter(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1000),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 48),
                  child: Flex(
                    direction: isCompact ? Axis.vertical : Axis.horizontal,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: isCompact ? 0 : 1,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: AspectRatio(
                            aspectRatio: 1,
                            child: Image.network(
                              _currentProduct.imageUrl,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => Container(color: AppColors.sand),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: isCompact ? 0 : 48, height: isCompact ? 32 : 0),
                      Expanded(
                        flex: isCompact ? 0 : 1,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(_currentProduct.weight, style: const TextStyle(color: Colors.black54)),
                            const SizedBox(height: 6),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(child: Text(_currentProduct.name, style: Theme.of(context).textTheme.headlineMedium)),
                                const SizedBox(width: 16),
                                FavoriteButton(productId: _currentProduct.id, size: 24, padding: 8),
                              ],
                            ),
                            const SizedBox(height: 16),
                            if (_currentProduct.oldPrice != null)
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.baseline,
                                textBaseline: TextBaseline.alphabetic,
                                children: [
                                  Text(
                                    _currentProduct.oldPrice!,
                                    style: const TextStyle(color: Colors.grey, fontSize: 20, decoration: TextDecoration.lineThrough),
                                  ),
                                  const SizedBox(width: 12),
                                  Text(
                                    _currentProduct.price,
                                    style: const TextStyle(color: AppColors.terracotta, fontSize: 28, fontWeight: FontWeight.bold),
                                  ),
                                ],
                              )
                            else
                              Text(
                                _currentProduct.price,
                                style: const TextStyle(color: AppColors.terracotta, fontSize: 28, fontWeight: FontWeight.bold),
                              ),
                            
                            if (variantOptions.isNotEmpty) ...[
                              const SizedBox(height: 20),
                              const Text('Seçenekler', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87)),
                              const SizedBox(height: 8),
                              Wrap(
                                spacing: 8,
                                runSpacing: 8,
                                children: variantOptions.map((variant) {
                                  final isSelected = variant.id == _currentProduct.id;
                                  return ChoiceChip(
                                    label: Text(variant.weight),
                                    selected: isSelected,
                                    onSelected: (selected) {
                                      if (selected) {
                                        setState(() => _currentProduct = variant);
                                      }
                                    },
                                    selectedColor: AppColors.forest.withOpacity(0.15),
                                    backgroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      side: BorderSide(
                                        color: isSelected ? AppColors.forest : const Color(0xFFE4DED2),
                                        width: isSelected ? 2 : 1,
                                      ),
                                    ),
                                    labelStyle: TextStyle(
                                      color: isSelected ? AppColors.forest : Colors.black87,
                                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                    ),
                                  );
                                }).toList(),
                              ),
                            ],
                            
                            const SizedBox(height: 24),
                            Text(strings.text('productDetailBody'), style: const TextStyle(height: 1.6, fontSize: 16)),
                            const SizedBox(height: 24),
                            _InfoRow(title: strings.text('ingredients'), text: strings.text('productIngredients')),
                            const SizedBox(height: 16),
                            _InfoRow(title: strings.text('deliveryInfo'), text: strings.text('productShipping')),
                            const SizedBox(height: 32),
                            Row(
                              children: [
                                _QuantityControl(quantity: _quantity, onChanged: (value) => setState(() => _quantity = value)),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: AnimatedSwitcher(
                                    duration: const Duration(milliseconds: 250),
                                    child: _addedToCart
                                        ? Container(
                                            key: const ValueKey('added'),
                                            width: double.infinity,
                                            height: 56,
                                            decoration: BoxDecoration(
                                              color: const Color(0xFF6B8E23),
                                              borderRadius: BorderRadius.circular(8),
                                            ),
                                            alignment: Alignment.center,
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                const Icon(Icons.check, color: Colors.white, size: 20),
                                                const SizedBox(width: 8),
                                                Text(
                                                  strings.text('added'),
                                                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                                ),
                                              ],
                                            ),
                                          )
                                        : FilledButton(
                                            key: const ValueKey('add'),
                                            onPressed: _handleAddToCart,
                                            style: FilledButton.styleFrom(
                                              backgroundColor: AppColors.forest,
                                              padding: const EdgeInsets.symmetric(vertical: 16),
                                              minimumSize: const Size.fromHeight(56),
                                            ),
                                            child: Text(strings.text('addToCart')),
                                          ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          const SliverToBoxAdapter(
            child: AppFooter(),
          ),
        ],
      ),
        ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.title, required this.text});
  final String title;
  final String text;

  @override
  Widget build(BuildContext context) => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(title, style: const TextStyle(color: AppColors.forest, fontWeight: FontWeight.bold, fontSize: 16)),
        const SizedBox(height: 6),
        Text(text, style: const TextStyle(height: 1.5)),
      ]);
}

class _QuantityControl extends StatelessWidget {
  const _QuantityControl({required this.quantity, required this.onChanged});
  final int quantity;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) => Container(
        height: 56,
        decoration: BoxDecoration(border: Border.all(color: const Color(0xFFDDD6C9)), borderRadius: BorderRadius.circular(8)),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          IconButton(onPressed: quantity > 1 ? () => onChanged(quantity - 1) : null, icon: const Icon(Icons.remove)),
          SizedBox(width: 24, child: Text('$quantity', textAlign: TextAlign.center, style: const TextStyle(fontWeight: FontWeight.bold))),
          IconButton(onPressed: () => onChanged(quantity + 1), icon: const Icon(Icons.add)),
        ]),
      );
}
