import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../../core/state/cart_state.dart';
import '../../../../core/state/favorite_state.dart';
import '../../../../core/state/auth_state.dart';
import '../../../../core/models/store_models.dart';
import '../../data/store_data.dart';

class AppHeader extends StatelessWidget {
  const AppHeader({
    super.key,
    required this.isDesktop,
    required this.cartCount,
    required this.onLanguageChanged,
    required this.onCartTap,
  });

  final bool isDesktop;
  final int cartCount;
  final ValueChanged<String> onLanguageChanged;
  final VoidCallback onCartTap;

  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context);

    return Column(
      children: [
        _PromoBar(text: strings.text('freeShipping')),
        if (isDesktop) _UtilityBar(strings: strings),
      ],
    );
  }
}

class _PromoBar extends StatelessWidget {
  const _PromoBar({required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: AppColors.terracotta,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 9),
      child: Text(text.toUpperCase(), textAlign: TextAlign.center, style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 0.3)),
    );
  }
}

class _UtilityBar extends StatelessWidget {
  const _UtilityBar({required this.strings});
  final AppLocalizations strings;

  @override
  Widget build(BuildContext context) {
    const style = TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600);
    return Container(
      width: double.infinity,
      color: AppColors.forest,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 13),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1240),
        child: Row(
          children: [
            _TopBarHoverLink(
              icon: Icons.menu_book_outlined,
              label: strings.text('blog'),
              onTap: () => Navigator.of(context).pushNamed('/journal'),
            ),
            const SizedBox(width: 24),
            const Icon(Icons.chat_outlined, color: Colors.white, size: 18),
            const SizedBox(width: 6),
            Text(strings.text('whatsappOrder'), style: style),
            const Spacer(),
            Text(strings.text('headerPromise').toUpperCase(), style: style),
            const Spacer(),
            Text(strings.text('aboutUs').toUpperCase(), style: style),
            const SizedBox(width: 22),
            const Icon(Icons.local_shipping_outlined, color: Colors.white, size: 17),
            const SizedBox(width: 6),
            Text(strings.text('orderTracking').toUpperCase(), style: style),
          ],
        ),
      ),
    );
  }
}

class MainHeader extends StatelessWidget {
  const MainHeader({
    super.key,
    required this.strings,
    required this.isDesktop,
    required this.cartCount,
    required this.onLanguageChanged,
    required this.onCartTap,
  });

  final AppLocalizations strings;
  final bool isDesktop;
  final int cartCount;
  final ValueChanged<String> onLanguageChanged;
  final VoidCallback onCartTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: AppColors.cream,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1240),
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Left and Right aligned content
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Left side: Menu / Search
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (!isDesktop) ...[
                      IconButton(
                        icon: const Icon(Icons.menu_rounded, color: AppColors.forest, size: 28),
                        onPressed: () => Scaffold.of(context).openDrawer(),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                      const SizedBox(width: 16),
                      IconButton(
                        icon: const Icon(Icons.search_rounded, color: AppColors.forest, size: 26),
                        onPressed: () {
                          showSearch(
                            context: context,
                            delegate: _StoreSearchDelegate(
                              strings: strings,
                              allProducts: StoreData.mainProducts(strings.isTurkish),
                            ),
                          );
                        },
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                    ],
                    if (isDesktop)
                      SizedBox(
                        width: 260,
                        child: Autocomplete<StoreProduct>(
                          optionsBuilder: (TextEditingValue textEditingValue) {
                            if (textEditingValue.text.isEmpty) {
                              return const Iterable<StoreProduct>.empty();
                            }
                            final query = textEditingValue.text.toLowerCase();
                            final allProducts = StoreData.mainProducts(strings.isTurkish);
                            return allProducts.where((p) => 
                              p.name.toLowerCase().contains(query) || 
                              p.categoryId.toLowerCase().contains(query)
                            );
                          },
                          displayStringForOption: (StoreProduct option) => option.name,
                          onSelected: (StoreProduct selection) {
                            Navigator.of(context).pushNamed('/product/${selection.id}');
                          },
                          fieldViewBuilder: (BuildContext context, TextEditingController textEditingController, FocusNode focusNode, VoidCallback onFieldSubmitted) {
                            return TextField(
                              controller: textEditingController,
                              focusNode: focusNode,
                              textInputAction: TextInputAction.search,
                              onSubmitted: (value) {
                                if (value.trim().isNotEmpty) {
                                  Navigator.of(context).pushNamed('/search?q=${Uri.encodeComponent(value)}');
                                }
                              },
                              decoration: InputDecoration(
                                hintText: strings.text('searchHint'),
                                prefixIcon: const Icon(Icons.search_rounded),
                                filled: true,
                                fillColor: Colors.white,
                                contentPadding: const EdgeInsets.symmetric(vertical: 13),
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(2), borderSide: const BorderSide(color: Color(0xFFDCD6C9))),
                              ),
                            );
                          },
                          optionsViewBuilder: (context, onSelected, options) {
                            return Align(
                              alignment: Alignment.topLeft,
                              child: Material(
                                elevation: 4.0,
                                borderRadius: BorderRadius.circular(4),
                                child: ConstrainedBox(
                                  constraints: const BoxConstraints(maxHeight: 250, maxWidth: 260),
                                  child: ListView.builder(
                                    padding: EdgeInsets.zero,
                                    shrinkWrap: true,
                                    itemCount: options.length,
                                    itemBuilder: (BuildContext context, int index) {
                                      final option = options.elementAt(index);
                                      return ListTile(
                                        leading: ClipRRect(
                                          borderRadius: BorderRadius.circular(4),
                                          child: Image.network(option.imageUrl, width: 40, height: 40, fit: BoxFit.cover, errorBuilder: (_, __, ___) => const Icon(Icons.image, size: 40)),
                                        ),
                                        title: Text(option.name, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                                        subtitle: Text(option.price, style: const TextStyle(fontSize: 12, color: AppColors.forest)),
                                        onTap: () => onSelected(option),
                                      );
                                    },
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                  ],
                ),
                // Right side: Icons
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (isDesktop)
                      PopupMenuButton<String>(
                        onSelected: onLanguageChanged,
                        tooltip: 'Language',
                        itemBuilder: (_) => const [PopupMenuItem(value: 'tr', child: Text('Türkçe')), PopupMenuItem(value: 'en', child: Text('English'))],
                        child: Row(mainAxisSize: MainAxisSize.min, children: [const Icon(Icons.language_rounded, color: AppColors.forest, size: 21), const SizedBox(width: 4), Text(strings.isTurkish ? 'TR' : 'EN', style: const TextStyle(color: AppColors.forest, fontWeight: FontWeight.bold, fontSize: 12))]),
                      ),
                    if (isDesktop) SizedBox(width: isDesktop ? 18 : 8),
                    if (isDesktop) ...[
                      ValueListenableBuilder(
                        valueListenable: AuthState.instance,
                        builder: (context, user, _) {
                          final isLoggedIn = user != null;
                          return InkWell(
                            onTap: () {
                              if (isLoggedIn) {
                                Navigator.of(context).pushNamed('/account');
                              } else {
                                Navigator.of(context).pushNamed('/login');
                              }
                            },
                            child: Row(
                              children: [
                                const Icon(Icons.person_outline_rounded, color: AppColors.forest),
                                const SizedBox(width: 6),
                                Text(
                                  isLoggedIn ? strings.text('account').toUpperCase() : (strings.isTurkish ? 'GİRİŞ YAP' : 'LOG IN'),
                                  style: const TextStyle(color: AppColors.ink, fontSize: 13, fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                      const SizedBox(width: 18),
                      Container(width: 1, height: 28, color: const Color(0xFFE4DED2)),
                      const SizedBox(width: 18),
                    ],
                    ValueListenableBuilder(
                      valueListenable: FavoriteState.instance,
                      builder: (context, favorites, _) {
                        return InkWell(
                          onTap: () => Navigator.of(context).pushNamed('/favorites'),
                          borderRadius: BorderRadius.circular(20),
                          child: Stack(
                            clipBehavior: Clip.none,
                            children: [
                              const Padding(
                                padding: EdgeInsets.all(2),
                                child: Icon(Icons.favorite_outline_rounded, color: AppColors.ink, size: 26),
                              ),
                              if (favorites.isNotEmpty)
                                Positioned(
                                  right: -6,
                                  top: -6,
                                  child: CircleAvatar(
                                    radius: 9,
                                    backgroundColor: AppColors.terracotta,
                                    child: Text(
                                      '${favorites.length}',
                                      style: const TextStyle(color: Colors.white, fontSize: 10),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        );
                      },
                    ),
                    SizedBox(width: isDesktop ? 18 : 8),
                    InkWell(
                      onTap: onCartTap,
                      borderRadius: BorderRadius.circular(20),
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          const Padding(padding: EdgeInsets.all(2), child: Icon(Icons.shopping_cart_outlined, color: AppColors.ink, size: 26)),
                          if (cartCount > 0) Positioned(right: -6, top: -6, child: CircleAvatar(radius: 9, backgroundColor: AppColors.terracotta, child: Text('$cartCount', style: const TextStyle(color: Colors.white, fontSize: 10)))),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
            // Perfectly Centered Logo
            InkWell(
              onTap: () => Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false),
              borderRadius: BorderRadius.circular(8),
              child: const BrandMark(),
            ),
          ],
        ),
      ),
    );
  }
}

class CategoryNavigation extends StatelessWidget {
  const CategoryNavigation({super.key, required this.strings});
  final AppLocalizations strings;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(color: Color(0xFFE7E1D4)),
          bottom: BorderSide(color: Color(0xFFE7E1D4)),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 15),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1400),
          child: Wrap(
            alignment: WrapAlignment.center,
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 28,
            runSpacing: 12,
            children: [
              _NavLink(label: strings.text('navHome'), onTap: () => Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false)),
              _HoverDropdownLink(
                label: strings.isTurkish ? 'PEKMEZ VE REÇEL ÇEŞİTLERİ' : 'JAMS & MOLASSES',
                onTap: () => Navigator.of(context).pushNamed('/category/jams-and-molasses'),
                items: {
                  strings.text('navJam'): () => Navigator.of(context).pushNamed('/category/jams'),
                  strings.text('navMolasses'): () => Navigator.of(context).pushNamed('/category/molasses'),
                },
              ),
              _HoverDropdownLink(
                label: strings.text('navSauces'),
                onTap: () => Navigator.of(context).pushNamed('/category/sauces'),
                items: {
                  'BİBER SALÇASI': () => Navigator.of(context).pushNamed('/category/sauces-pepper'),
                  'DOMATES SALÇASI': () => Navigator.of(context).pushNamed('/category/sauces-tomato'),
                  'BİBER&DOMATES KARIŞIK SALÇA': () => Navigator.of(context).pushNamed('/category/sauces-mixed'),
                  'SOS ÇEŞİTLERİ': () => Navigator.of(context).pushNamed('/category/sauces-other'),
                },
              ),
              _HoverDropdownLink(
                label: strings.isTurkish ? 'KURUTULMUŞ ÜRÜNLER' : 'DRIED PRODUCTS',
                onTap: () => Navigator.of(context).pushNamed('/category/dried'),
                items: {
                  'KURUTULMUŞ MEYVELER': () => Navigator.of(context).pushNamed('/category/dried-fruits'),
                  'KURUTULMUŞ SEBZELER': () => Navigator.of(context).pushNamed('/category/dried-vegetables'),
                  'DİĞERLERİ': () => Navigator.of(context).pushNamed('/category/dried-other'),
                },
              ),
              _NavLink(label: strings.text('navSiirtYoresel'), onTap: () => Navigator.of(context).pushNamed('/category/siirt-yoresel'), highlight: true),
              _NavLink(label: strings.text('navCampaigns'), onTap: () => Navigator.of(context).pushNamed('/category/campaigns'), isPromo: true),
              _NavLink(label: strings.text('navStory'), onTap: () {}),
              _NavLink(label: strings.text('navContact'), onTap: () => Navigator.of(context).pushNamed('/contact')),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavLink extends StatefulWidget {
  const _NavLink({required this.label, required this.onTap, this.highlight = false, this.isPromo = false});
  final String label;
  final VoidCallback onTap;
  final bool highlight;
  final bool isPromo;

  @override
  State<_NavLink> createState() => _NavLinkState();
}

class _NavLinkState extends State<_NavLink> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: InkWell(
        onTap: widget.onTap,
        borderRadius: widget.isPromo ? BorderRadius.circular(24) : null,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: widget.isPromo ? const EdgeInsets.symmetric(horizontal: 14, vertical: 8) : EdgeInsets.zero,
          decoration: widget.isPromo
              ? BoxDecoration(
                  color: _hovered ? const Color(0xFFC62828) : const Color(0xFFFFEBEE),
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: _hovered ? const Color(0xFFC62828).withOpacity(0.3) : Colors.black.withOpacity(0.05),
                      blurRadius: _hovered ? 8 : 4,
                      offset: Offset(0, _hovered ? 4 : 2),
                    )
                  ],
                )
              : null,
          child: AnimatedDefaultTextStyle(
            duration: const Duration(milliseconds: 150),
            style: TextStyle(
              color: widget.isPromo
                  ? (_hovered ? Colors.white : const Color(0xFFC62828))
                  : widget.highlight
                      ? (_hovered ? AppColors.forest : AppColors.terracotta)
                      : (_hovered ? AppColors.terracotta : AppColors.forest),
              fontSize: widget.isPromo ? 13 : 12,
              fontWeight: widget.isPromo ? FontWeight.w900 : FontWeight.bold,
              letterSpacing: 0.3,
            ),
            child: Text(widget.label.toUpperCase()),
          ),
        ),
      ),
    );
  }
}

class _HoverDropdownLink extends StatefulWidget {
  const _HoverDropdownLink({
    required this.label,
    required this.onTap,
    required this.items,
  });

  final String label;
  final VoidCallback onTap;
  final Map<String, VoidCallback> items;

  @override
  State<_HoverDropdownLink> createState() => _HoverDropdownLinkState();
}

class _HoverDropdownLinkState extends State<_HoverDropdownLink> {
  bool _hovered = false;
  bool _menuHovered = false;
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;

  void _showOverlay() {
    if (_overlayEntry != null) return;
    _overlayEntry = _createOverlayEntry();
    Overlay.of(context).insert(_overlayEntry!);
  }

  void _hideOverlay() {
    if (_hovered || _menuHovered) return;
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  OverlayEntry _createOverlayEntry() {
    return OverlayEntry(
      builder: (context) => Positioned(
        width: 200,
        child: CompositedTransformFollower(
          link: _layerLink,
          showWhenUnlinked: false,
          offset: const Offset(0, 25), // Adjust offset to bridge the gap
          child: MouseRegion(
            onEnter: (_) {
              _menuHovered = true;
            },
            onExit: (_) {
              _menuHovered = false;
              Future.delayed(const Duration(milliseconds: 50), _hideOverlay);
            },
            child: Material(
              elevation: 4,
              color: Colors.white,
              borderRadius: BorderRadius.circular(4),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: widget.items.entries.map((entry) {
                  return InkWell(
                    onTap: () {
                      _menuHovered = false;
                      _hovered = false;
                      _hideOverlay();
                      entry.value();
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      child: Text(
                        entry.key.toUpperCase(),
                        style: const TextStyle(
                          color: AppColors.forest,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _overlayEntry?.remove();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: MouseRegion(
        onEnter: (_) {
          setState(() => _hovered = true);
          _showOverlay();
        },
        onExit: (_) {
          setState(() => _hovered = false);
          Future.delayed(const Duration(milliseconds: 100), _hideOverlay);
        },
        child: InkWell(
          onTap: widget.onTap,
          child: AnimatedDefaultTextStyle(
            duration: const Duration(milliseconds: 150),
            style: TextStyle(
              color: _hovered ? AppColors.terracotta : AppColors.forest,
              fontSize: 12,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.3,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(widget.label.toUpperCase()),
                const SizedBox(width: 2),
                Icon(Icons.keyboard_arrow_down, size: 14, color: _hovered ? AppColors.terracotta : AppColors.forest),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class BrandMark extends StatelessWidget {
  const BrandMark({super.key});

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/images/logo.png',
      height: 60, // Increased height since it's a wide logo now
      fit: BoxFit.contain,
      filterQuality: FilterQuality.high,
    );
  }
}

List<Widget> buildStoreHeaderSlivers({
  required bool isDesktop,
  required ValueChanged<String> onLanguageChanged,
  required VoidCallback onCartTap,
  required AppLocalizations strings,
}) {
  return [
    SliverToBoxAdapter(
      child: ValueListenableBuilder(
        valueListenable: CartState.instance,
        builder: (context, cartItems, child) {
          final cartCount = cartItems.fold(0, (sum, item) => sum + item.quantity);
          return AppHeader(
            isDesktop: isDesktop,
            cartCount: cartCount,
            onLanguageChanged: onLanguageChanged,
            onCartTap: onCartTap,
          );
        },
      ),
    ),
    SliverPersistentHeader(
      pinned: true,
      delegate: StickyHeaderDelegate(
        height: isDesktop ? 148.0 : 70.0,
        child: ValueListenableBuilder(
          valueListenable: CartState.instance,
          builder: (context, cartItems, child) {
            final cartCount = cartItems.fold(0, (sum, item) => sum + item.quantity);
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                MainHeader(
                  strings: strings,
                  isDesktop: isDesktop,
                  cartCount: cartCount,
                  onLanguageChanged: onLanguageChanged,
                  onCartTap: onCartTap,
                ),
                if (isDesktop) CategoryNavigation(strings: strings),
              ],
            );
          },
        ),
      ),
    ),
  ];
}

class StickyHeaderDelegate extends SliverPersistentHeaderDelegate {
  StickyHeaderDelegate({required this.child, required this.height});
  final Widget child;
  final double height;

  @override
  double get minExtent => height;
  @override
  double get maxExtent => height;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return SizedBox(
      height: height,
      width: double.infinity,
      child: Material(
        elevation: overlapsContent ? 4 : 0,
        color: Colors.white,
        child: Align(
          alignment: Alignment.topCenter,
          child: child,
        ),
      ),
    );
  }

  @override
  bool shouldRebuild(covariant StickyHeaderDelegate oldDelegate) {
    return oldDelegate.height != height || oldDelegate.child != child;
  }
}

class _TopBarHoverLink extends StatefulWidget {
  const _TopBarHoverLink({required this.icon, required this.label, required this.onTap});
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  State<_TopBarHoverLink> createState() => _TopBarHoverLinkState();
}

class _TopBarHoverLinkState extends State<_TopBarHoverLink> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: InkWell(
        onTap: widget.onTap,
        borderRadius: BorderRadius.circular(6),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: _hovered ? Colors.white.withOpacity(0.15) : Colors.transparent,
            borderRadius: BorderRadius.circular(6),
            boxShadow: _hovered
                ? [BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 4, offset: const Offset(0, 2))]
                : [],
          ),
          child: Row(
            children: [
              Icon(widget.icon, color: Colors.white, size: 18),
              const SizedBox(width: 6),
              Text(
                widget.label,
                style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StoreSearchDelegate extends SearchDelegate<StoreProduct?> {
  _StoreSearchDelegate({required this.strings, required this.allProducts}) : super(searchFieldLabel: strings.text('searchHint'));

  final dynamic strings;
  final List<StoreProduct> allProducts;

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      if (query.isNotEmpty)
        IconButton(icon: const Icon(Icons.clear), onPressed: () => query = ''),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () => close(context, null),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    if (query.trim().isNotEmpty) {
      Future.microtask(() {
        Navigator.of(context).pushReplacementNamed('/search?q=${Uri.encodeComponent(query)}');
      });
    }
    return const SizedBox();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    if (query.isEmpty) return const SizedBox();

    final searchLower = query.toSearchable();
    final suggestions = allProducts.where((p) => 
      p.name.toSearchable().contains(searchLower) || 
      p.categoryId.toSearchable().contains(searchLower)
    ).toList();

    return ListView.builder(
      itemCount: suggestions.length,
      itemBuilder: (context, index) {
        final product = suggestions[index];
        return ListTile(
          leading: ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: Image.network(product.imageUrl, width: 40, height: 40, fit: BoxFit.cover, errorBuilder: (_, __, ___) => const Icon(Icons.image, size: 40)),
          ),
          title: Text(product.name, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
          subtitle: Text(product.price, style: const TextStyle(fontSize: 12, color: AppColors.forest)),
          onTap: () {
            close(context, null);
            Navigator.of(context).pushNamed('/product/${product.id}');
          },
        );
      },
    );
  }
}
