import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../../core/models/journal_models.dart';
import '../../../../core/state/cart_state.dart';
import '../../../checkout/presentation/pages/checkout_page.dart';
import '../widgets/app_footer.dart';
import '../widgets/app_header.dart';
import '../widgets/cart_drawer.dart';
import '../widgets/mobile_drawer.dart';
import '../widgets/brand_refresh_indicator.dart';

class JournalArticlePage extends StatefulWidget {
  final JournalArticle article;
  final ValueChanged<String> onLanguageChanged;

  const JournalArticlePage({
    super.key,
    required this.article,
    required this.onLanguageChanged,
  });

  @override
  State<JournalArticlePage> createState() => _JournalArticlePageState();
}

class _JournalArticlePageState extends State<JournalArticlePage> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context);
    final isDesktop = MediaQuery.sizeOf(context).width >= 900;
    final isTurkish = strings.isTurkish;

    return Scaffold(
      key: _scaffoldKey,
      drawer: MobileDrawer(onLanguageChanged: widget.onLanguageChanged),
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
            child: Column(
              children: [
                // Hero Image Section
                Container(
                  width: double.infinity,
                  height: isDesktop ? 500 : 300,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(widget.article.coverImageUrl),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.black.withOpacity(0.8), Colors.transparent],
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                      ),
                    ),
                  ),
                ),
                
                // Content Section
                Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 800),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 64),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Back Button
                          InkWell(
                            onTap: () => Navigator.of(context).pop(),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.arrow_back, color: AppColors.sage),
                                const SizedBox(width: 8),
                                Text(
                                  isTurkish ? 'Günlüğe Dön' : 'Back to Journal',
                                  style: const TextStyle(
                                    color: AppColors.sage,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 32),
                          
                          // Article Title
                          Text(
                            isTurkish ? widget.article.titleTr : widget.article.titleEn,
                            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                              fontWeight: FontWeight.w900,
                              color: AppColors.forest,
                              height: 1.3,
                            ),
                          ),
                          const SizedBox(height: 24),
                          
                          // Author Info
                          Row(
                            children: [
                              const CircleAvatar(
                                radius: 24,
                                backgroundColor: AppColors.sage,
                                child: Icon(Icons.spa, color: Colors.white, size: 24),
                              ),
                              const SizedBox(width: 16),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    widget.article.author, 
                                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)
                                  ),
                                  Text(
                                    widget.article.date, 
                                    style: const TextStyle(color: Colors.grey, fontSize: 14)
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 48),

                          // Dynamic Content
                          widget.article.contentBuilder(context, isTurkish),

                          const SizedBox(height: 48),
                          
                          // Product Linking Section based on article
                          if (widget.article.id == 'siirt-fistigi-faydalari')
                            Center(
                              child: FilledButton.icon(
                                onPressed: () => Navigator.of(context).pushNamed('/category/siirt-yoresel'),
                                icon: const Icon(Icons.shopping_bag_outlined),
                                label: Text(
                                  isTurkish ? 'Siirt Fıstığı Sipariş Et' : 'Order Siirt Pistachio', 
                                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)
                                ),
                                style: FilledButton.styleFrom(
                                  backgroundColor: AppColors.terracotta,
                                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 20),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                                ),
                              ),
                            )
                          else if (widget.article.id == 'odun-atesinde-salca')
                            Center(
                              child: Column(
                                children: [
                                  Text(
                                    isTurkish ? 'Bu hikâyenin tadına bakmak ister misiniz?' : 'Would you like to taste this story?',
                                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.forest),
                                  ),
                                  const SizedBox(height: 24),
                                  Wrap(
                                    spacing: 16,
                                    runSpacing: 16,
                                    alignment: WrapAlignment.center,
                                    children: [
                                      FilledButton.icon(
                                        onPressed: () => Navigator.of(context).pushNamed('/category/sauces'),
                                        icon: const Icon(Icons.soup_kitchen),
                                        label: Text(
                                          isTurkish ? 'Salçalarımızı İncele' : 'View Our Pastes', 
                                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)
                                        ),
                                        style: FilledButton.styleFrom(
                                          backgroundColor: AppColors.terracotta,
                                          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 20),
                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                                        ),
                                      ),
                                      OutlinedButton.icon(
                                        onPressed: () => Navigator.of(context).pushNamed('/category/sauces'),
                                        icon: const Icon(Icons.local_fire_department, color: AppColors.terracotta),
                                        label: Text(
                                          isTurkish ? 'Acı Soslar' : 'Spicy Sauces', 
                                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.terracotta)
                                        ),
                                        style: OutlinedButton.styleFrom(
                                          side: const BorderSide(color: AppColors.terracotta, width: 2),
                                          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 20),
                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),

                          const SizedBox(height: 64),
                          
                          // Tags Section
                          Text(
                            isTurkish ? 'Etiketler:' : 'Tags:', 
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)
                          ),
                          const SizedBox(height: 12),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: (isTurkish ? widget.article.tagsTr : widget.article.tagsEn)
                                .map((tag) => _buildTag(tag))
                                .toList(),
                          ),
                          
                          const SizedBox(height: 48),
                          const Divider(color: Color(0xFFE7E1D4)),
                          const SizedBox(height: 32),
                          Text(
                            isTurkish 
                                ? 'Afiyet, şifa ve sevgiyle kalın...\nZahide Hanım Çiftliği Ailesi' 
                                : 'Stay healthy, healed, and full of love...\nZahide Hanım Çiftliği Family', 
                            style: const TextStyle(fontSize: 18, fontStyle: FontStyle.italic, color: Colors.grey)
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
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

  Widget _buildTag(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.sage.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.sage.withOpacity(0.5)),
      ),
      child: Text(
        '#$text',
        style: const TextStyle(
          color: AppColors.forest,
          fontWeight: FontWeight.w600,
          fontSize: 14,
        ),
      ),
    );
  }
}
