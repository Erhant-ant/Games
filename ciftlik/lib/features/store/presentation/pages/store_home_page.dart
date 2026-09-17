import 'package:flutter/material.dart';
import '../widgets/brand_refresh_indicator.dart';

import '../../../../core/localization/app_localizations.dart';
import '../../../../core/models/store_models.dart';
import '../../../checkout/presentation/pages/checkout_page.dart';
import '../../data/store_data.dart';
import '../widgets/app_footer.dart';
import '../widgets/app_header.dart';
import '../widgets/benefits_section.dart';
import '../widgets/cart_drawer.dart';
import '../widgets/catalog_filter_bar.dart';
import '../widgets/category_grid.dart';
import '../widgets/hero_banner.dart';
import '../widgets/newsletter_section.dart';
import '../../../../core/state/cart_state.dart';
import '../widgets/product_grid.dart';
import '../widgets/scroll_animate_wrapper.dart';
import '../widgets/section_heading.dart';
import '../widgets/story_section.dart';
import '../widgets/trust_strip.dart';
import '../widgets/store_filter_bar.dart';
import '../widgets/filter_drawer.dart';
import '../widgets/mobile_drawer.dart';
import '../widgets/mobile_bottom_nav.dart';
import '../widgets/brand_refresh_indicator.dart';

class StoreHomePage extends StatefulWidget {
  const StoreHomePage({super.key, required this.onLanguageChanged});

  final ValueChanged<String> onLanguageChanged;

  @override
  State<StoreHomePage> createState() => _StoreHomePageState();
}

class _StoreHomePageState extends State<StoreHomePage> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  String? _selectedCategoryId;
  ProductSortOption _currentSortOption = ProductSortOption.featured;
  ProductFilterModel _currentFilter = const ProductFilterModel();

  void _openProduct(StoreProduct product) {
    Navigator.of(context).pushNamed('/product/${product.id}');
  }

  double _parsePrice(String price) {
    return double.tryParse(price.replaceAll(RegExp(r'[^0-9.]'), '')) ?? 0;
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.sizeOf(context).width >= 900;
    final strings = AppLocalizations.of(context);
    final categories = StoreData.categories(strings.isTurkish);
    final allProducts = StoreData.mainProducts(strings.isTurkish);
    
    var visibleProducts = allProducts.where((p) {
      if (_selectedCategoryId == null) return true;
      if (_selectedCategoryId == 'jams-and-molasses') return p.categoryId == 'jams' || p.categoryId == 'molasses';
      if (_selectedCategoryId == 'dried') return p.categoryId.startsWith('dried');
      if (_selectedCategoryId == 'siirt-yoresel') return p.categoryId == 'siirt-yoresel';
      if (_selectedCategoryId == 'sauces') return p.categoryId.startsWith('sauces');
      return p.categoryId == _selectedCategoryId;
    }).toList();

    // Apply Filter
    if (_currentFilter.isActive) {
      visibleProducts = visibleProducts.where((p) {
        final price = _parsePrice(p.price);
        if (_currentFilter.minPrice != null && price < _currentFilter.minPrice!) return false;
        if (_currentFilter.maxPrice != null && price > _currentFilter.maxPrice!) return false;
        if (_currentFilter.selectedCategoryIds.isNotEmpty && !_currentFilter.selectedCategoryIds.contains(p.categoryId)) return false;
        // if (_currentFilter.inStockOnly) ... (dummy check for stock)
        return true;
      }).toList();
    }

    // Apply Sort
    if (_currentSortOption == ProductSortOption.priceAsc) {
      visibleProducts.sort((a, b) => _parsePrice(a.price).compareTo(_parsePrice(b.price)));
    } else if (_currentSortOption == ProductSortOption.priceDesc) {
      visibleProducts.sort((a, b) => _parsePrice(b.price).compareTo(_parsePrice(a.price)));
    } else if (_currentSortOption == ProductSortOption.newest) {
      visibleProducts = visibleProducts.reversed.toList(); // Dummy logic for newest
    } else if (_currentSortOption == ProductSortOption.bestSellers) {
      // Dummy logic for best sellers (just sort by id or name randomly for now, or just leave as is)
    }

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
                  HeroBanner(isDesktop: isDesktop),
                  ScrollAnimateWrapper(
                    delay: const Duration(milliseconds: 300),
                    child: const TrustStrip(),
                  ),
                  ScrollAnimateWrapper(
                    delay: const Duration(milliseconds: 100),
                    child: PageSection(
                      eyebrow: strings.text('categoryEyebrow'),
                      title: strings.text('categoryTitle'),
                      child: CategoryGrid(
                        categories: categories,
                        isDesktop: isDesktop,
                        onSelected: (category) => setState(() => _selectedCategoryId = category.id),
                      ),
                    ),
                  ),
                  ScrollAnimateWrapper(
                    child: PageSection(
                      eyebrow: strings.text('productEyebrow'),
                      title: strings.text('productTitle'),
                      action: TextButton(onPressed: () => setState(() => _selectedCategoryId = null), child: Text(strings.text('allProducts'))),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          StoreFilterBar(
                            currentSort: _currentSortOption,
                            activeFilterCount: _currentFilter.activeFilterCount,
                            onSortChanged: (val) => setState(() => _currentSortOption = val),
                            onFilterTap: () {
                              showModalBottomSheet(
                                context: context,
                                isScrollControlled: true,
                                builder: (_) => SizedBox(
                                  height: MediaQuery.sizeOf(context).height * 0.85,
                                  child: FilterDrawer(
                                    initialFilter: _currentFilter,
                                    onApply: (filter) => setState(() => _currentFilter = filter),
                                    showCategoryFilter: _selectedCategoryId == null,
                                  ),
                                ),
                              );
                            },
                          ),
                          const SizedBox(height: 16),
                          CatalogFilterBar(
                            categories: categories,
                            selectedCategoryId: _selectedCategoryId,
                            onSelected: (value) => setState(() => _selectedCategoryId = value),
                            currentSortOption: _currentSortOption,
                            onSortChanged: (value) => setState(() => _currentSortOption = value),
                          ),
                          const SizedBox(height: 22),
                          AnimatedSwitcher(
                            duration: const Duration(milliseconds: 350),
                            switchInCurve: Curves.easeOut,
                            switchOutCurve: Curves.easeIn,
                            child: ProductGrid(
                              key: ValueKey(_selectedCategoryId),
                              products: visibleProducts,
                              isDesktop: isDesktop,
                              onAddToCart: CartState.instance.add,
                              onProductSelected: _openProduct,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  ScrollAnimateWrapper(
                    child: const StorySection(),
                  ),
                  ScrollAnimateWrapper(
                    child: PageSection(
                      eyebrow: strings.text('benefitEyebrow'),
                      title: strings.text('benefitTitle'),
                      child: BenefitsSection(isDesktop: isDesktop),
                    ),
                  ),
                  ScrollAnimateWrapper(
                    child: const NewsletterSection(),
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
