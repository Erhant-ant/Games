import 'package:flutter/material.dart';

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
import '../widgets/store_filter_bar.dart';
import '../widgets/filter_drawer.dart';
import '../widgets/mobile_drawer.dart';
import '../widgets/mobile_bottom_nav.dart';
import '../widgets/brand_refresh_indicator.dart';

class CategoryPage extends StatefulWidget {
  const CategoryPage({
    super.key,
    required this.categoryId,
    required this.onLanguageChanged,
  });

  final String categoryId;
  final ValueChanged<String> onLanguageChanged;

  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

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
    
    final allCategories = StoreData.categories(strings.isTurkish);
    final isJamsAndMolasses = widget.categoryId == 'jams-and-molasses';
    final isDried = widget.categoryId == 'dried';
    final isSiirtYoresel = widget.categoryId == 'siirt-yoresel';
    final isCombinedCategory = isJamsAndMolasses || isDried || isSiirtYoresel;
    
    final category = allCategories.firstWhere(
      (c) => c.id == widget.categoryId,
      orElse: () {
        String titleTr = '';
        String titleEn = '';
        switch (widget.categoryId) {
          case 'jams-and-molasses':
            titleTr = 'Pekmez ve Reçel Çeşitleri';
            titleEn = 'Jams & Molasses';
            break;
          case 'dried':
            titleTr = 'Kurutulmuş Ürünler';
            titleEn = 'Dried Products';
            break;
          case 'siirt-yoresel':
            titleTr = 'Siirt Yöresel';
            titleEn = 'Siirt Regional';
            break;
          case 'dried-fruits':
            titleTr = 'Kurutulmuş Meyveler';
            titleEn = 'Dried Fruits';
            break;
          case 'dried-vegetables':
            titleTr = 'Kurutulmuş Sebzeler';
            titleEn = 'Dried Vegetables';
            break;
          case 'dried-other':
            titleTr = 'Diğer Kurutulmuş Ürünler';
            titleEn = 'Other Dried Products';
            break;
          case 'sauces-pepper':
            titleTr = 'Biber Salçası';
            titleEn = 'Pepper Paste';
            break;
          case 'sauces-tomato':
            titleTr = 'Domates Salçası';
            titleEn = 'Tomato Paste';
            break;
          case 'sauces-mixed':
            titleTr = 'Biber & Domates Karışık Salça';
            titleEn = 'Mixed Paste';
            break;
          case 'sauces-other':
            titleTr = 'Sos Çeşitleri';
            titleEn = 'Other Sauces';
            break;
          default:
            titleTr = 'Tüm Ürünler';
            titleEn = 'All Products';
        }
        return StoreCategory(
          id: widget.categoryId,
          title: strings.isTurkish ? titleTr : titleEn,
          imageUrl: '',
        );
      },
    );

    final allProducts = StoreData.mainProducts(strings.isTurkish);
    var categoryProducts = allProducts.where((p) {
      if (isJamsAndMolasses) return p.categoryId == 'jams' || p.categoryId == 'molasses';
      if (isDried) return p.categoryId.startsWith('dried');
      if (isSiirtYoresel) return p.categoryId == 'siirt-yoresel';
      if (widget.categoryId == 'sauces') return p.categoryId.startsWith('sauces');
      return p.categoryId == widget.categoryId;
    }).toList();

    // Default to alphabetical sort for combined categories if sort option is featured
    if (isCombinedCategory && _currentSortOption == ProductSortOption.featured) {
      categoryProducts.sort((a, b) => a.name.compareTo(b.name));
    }

    // Apply Filter
    if (_currentFilter.isActive) {
      categoryProducts = categoryProducts.where((p) {
        final price = _parsePrice(p.price);
        if (_currentFilter.minPrice != null && price < _currentFilter.minPrice!) return false;
        if (_currentFilter.maxPrice != null && price > _currentFilter.maxPrice!) return false;
        // if (_currentFilter.inStockOnly) ... (dummy check for stock)
        return true;
      }).toList();
    }

    if (_currentSortOption == ProductSortOption.priceAsc) {
      categoryProducts.sort((a, b) => _parsePrice(a.price).compareTo(_parsePrice(b.price)));
    } else if (_currentSortOption == ProductSortOption.priceDesc) {
      categoryProducts.sort((a, b) => _parsePrice(b.price).compareTo(_parsePrice(a.price)));
    } else if (_currentSortOption == ProductSortOption.newest) {
      categoryProducts = categoryProducts.reversed.toList(); // Dummy logic for newest
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
          if (category.imageUrl.isNotEmpty)
            SliverToBoxAdapter(
              child: SizedBox(
                height: 200,
                width: double.infinity,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.network(category.imageUrl, fit: BoxFit.cover),
                    Container(color: Colors.black.withValues(alpha: 0.4)),
                    Center(
                      child: Text(
                        category.title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          SliverToBoxAdapter(
            child: Column(
              children: [
                PageSection(
                  eyebrow: strings.text('categoryEyebrow'),
                  title: category.title,
                  child: categoryProducts.isEmpty
                      ? Padding(
                          padding: const EdgeInsets.symmetric(vertical: 80),
                          child: Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.inventory_2_outlined, size: 64, color: Colors.grey),
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
                      : Column(
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
                                      showCategoryFilter: false,
                                    ),
                                  ),
                                );
                              },
                            ),
                            const SizedBox(height: 16),
                            ProductGrid(
                              products: categoryProducts,
                              isDesktop: isDesktop,
                              onAddToCart: CartState.instance.add,
                              onProductSelected: _openProduct,
                            ),
                          ],
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
