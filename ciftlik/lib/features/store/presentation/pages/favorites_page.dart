import 'package:flutter/material.dart';

import '../../../../core/localization/app_localizations.dart';
import '../../../../core/models/store_models.dart';
import '../../../../core/state/favorite_state.dart';
import '../../../../core/state/cart_state.dart';
import '../../../checkout/presentation/pages/checkout_page.dart';
import '../widgets/app_header.dart';
import '../widgets/app_footer.dart';
import '../widgets/cart_drawer.dart';
import '../widgets/product_grid.dart';
import '../../data/store_data.dart';
import '../widgets/mobile_drawer.dart';
import '../widgets/mobile_bottom_nav.dart';
import '../widgets/brand_refresh_indicator.dart';

class FavoritesPage extends StatefulWidget {
  const FavoritesPage({super.key, required this.onLanguageChanged});

  final ValueChanged<String> onLanguageChanged;

  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  void _openProduct(StoreProduct product) {
    Navigator.of(context).pushNamed('/product/${product.id}');
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.sizeOf(context).width >= 900;
    final strings = AppLocalizations.of(context);
    final allProducts = StoreData.products(strings.isTurkish);

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
            Navigator.of(context).push(MaterialPageRoute<void>(builder: (_) => CheckoutPage(items: List.of(cartItems))));
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
            child: ValueListenableBuilder(
              valueListenable: FavoriteState.instance,
              builder: (context, favorites, _) {
                final favoriteProducts = allProducts.where((p) => favorites.contains(p.id)).toList();
                
                return Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: isDesktop ? 60 : 20, vertical: 40),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            strings.isTurkish ? 'Favorilerim' : 'My Favorites',
                            style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 24),
                          if (favoriteProducts.isEmpty)
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 80),
                              child: Center(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(Icons.favorite_outline_rounded, size: 64, color: Colors.grey),
                                    const SizedBox(height: 16),
                                    Text(
                                      strings.isTurkish ? 'Henüz favori ürününüz yok.' : 'You have no favorite products yet.',
                                      style: const TextStyle(fontSize: 16, color: Colors.black54),
                                      textAlign: TextAlign.center,
                                    ),
                                    const SizedBox(height: 24),
                                    ElevatedButton(
                                      onPressed: () => Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: const Color(0xFF2C4C3B),
                                        foregroundColor: Colors.white,
                                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                                      ),
                                      child: Text(strings.text('continueShopping')),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          else
                            ProductGrid(
                              products: favoriteProducts,
                              isDesktop: isDesktop,
                              onAddToCart: CartState.instance.add,
                              onProductSelected: _openProduct,
                            ),
                        ],
                      ),
                    ),
                    const AppFooter(),
                  ],
                );
              },
            ),
          ),
        ],
      ),
        ),
    );
  }
}
