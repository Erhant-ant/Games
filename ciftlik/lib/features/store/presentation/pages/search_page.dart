import 'package:flutter/material.dart';
import '../widgets/brand_refresh_indicator.dart';

import '../../../../core/localization/app_localizations.dart';
import '../../../../core/models/store_models.dart';
import '../../../../core/state/cart_state.dart';
import '../../../checkout/presentation/pages/checkout_page.dart';
import '../../data/store_data.dart';
import '../widgets/app_footer.dart';
import '../widgets/app_header.dart';
import '../widgets/cart_drawer.dart';
import '../widgets/product_grid.dart';
import '../widgets/section_heading.dart';
import '../widgets/mobile_drawer.dart';
import '../widgets/mobile_bottom_nav.dart';
import '../widgets/brand_refresh_indicator.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({
    super.key,
    required this.query,
    required this.onLanguageChanged,
  });

  final String query;
  final ValueChanged<String> onLanguageChanged;

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  void _openProduct(StoreProduct product) {
    Navigator.of(context).pushNamed('/product/${product.id}');
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.sizeOf(context).width >= 900;
    final strings = AppLocalizations.of(context);
    
    // Retrieve and filter products based on query
    final allProducts = StoreData.mainProducts(strings.isTurkish);
    final searchLower = widget.query.toSearchable();
    
    final searchResults = allProducts.where((p) {
      final titleMatch = p.name.toSearchable().contains(searchLower);
      final categoryMatch = p.categoryId.toSearchable().contains(searchLower);
      return titleMatch || categoryMatch;
    }).toList();

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
          await Future<void>.delayed(const Duration(seconds: 1));
          if (mounted) setState(() {});
        },
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            ...buildStoreHeaderSlivers(
              isDesktop: isDesktop,
              onLanguageChanged: widget.onLanguageChanged,
              onCartTap: () => _scaffoldKey.currentState?.openEndDrawer(),
              strings: strings,
            ),
            SliverToBoxAdapter(
              child: Column(
                children: [
                  PageSection(
                    eyebrow: 'ARAMA',
                    title: strings.text('searchResultsFor').replaceAll('{query}', widget.query),
                    child: searchResults.isEmpty
                        ? Padding(
                            padding: const EdgeInsets.symmetric(vertical: 80),
                            child: Center(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(Icons.search_off_rounded, size: 64, color: Colors.grey),
                                  const SizedBox(height: 16),
                                  Text(
                                    strings.text('noResults'),
                                    style: const TextStyle(fontSize: 16, color: Colors.black54),
                                    textAlign: TextAlign.center,
                                  ),
                                  const SizedBox(height: 24),
                                  ElevatedButton(
                                    onPressed: () => Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFF2C4C3B), // AppColors.forest
                                      foregroundColor: Colors.white,
                                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                                    ),
                                    child: Text(strings.text('continueShopping')),
                                  ),
                                ],
                              ),
                            ),
                          )
                        : ProductGrid(
                            products: searchResults,
                            isDesktop: isDesktop,
                            onAddToCart: CartState.instance.add,
                            onProductSelected: _openProduct,
                          ),
                  ),
                  const AppFooter(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
