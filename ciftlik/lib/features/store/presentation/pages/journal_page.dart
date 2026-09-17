import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../../core/state/cart_state.dart';
import '../../../checkout/presentation/pages/checkout_page.dart';
import '../../data/journal_data.dart';
import '../widgets/app_footer.dart';
import '../widgets/app_header.dart';
import '../widgets/cart_drawer.dart';
import '../widgets/mobile_drawer.dart';
import 'journal_article_page.dart';
import '../widgets/brand_refresh_indicator.dart';

class JournalPage extends StatefulWidget {
  const JournalPage({
    super.key,
    required this.onLanguageChanged,
  });

  final ValueChanged<String> onLanguageChanged;

  @override
  State<JournalPage> createState() => _JournalPageState();
}

class _JournalPageState extends State<JournalPage> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context);
    final isDesktop = MediaQuery.sizeOf(context).width >= 900;
    final isCompact = MediaQuery.sizeOf(context).width < 680;

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
                  height: isDesktop ? 400 : 250,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage('https://images.unsplash.com/photo-1502086223501-7ea6ecd79368?auto=format&fit=crop&w=1600&q=80'),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.black.withOpacity(0.6), Colors.transparent],
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                      ),
                    ),
                    alignment: Alignment.bottomCenter,
                    padding: const EdgeInsets.all(40),
                    child: Text(
                      strings.text('blog'),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2,
                      ),
                    ),
                  ),
                ),
                
                // Article List Section
                Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 1000),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 64),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: JournalData.articles.map((article) {
                          return Container(
                            margin: const EdgeInsets.only(bottom: 48),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.05),
                                  blurRadius: 20,
                                  offset: const Offset(0, 10),
                                ),
                              ],
                            ),
                            child: InkWell(
                              borderRadius: BorderRadius.circular(16),
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (_) => AppLocalizations(
                                      locale: strings.locale,
                                      child: JournalArticlePage(
                                        article: article,
                                        onLanguageChanged: widget.onLanguageChanged,
                                      ),
                                    ),
                                  ),
                                );
                              },
                              child: isCompact 
                                ? Column(
                                    crossAxisAlignment: CrossAxisAlignment.stretch,
                                    children: [
                                      ClipRRect(
                                        borderRadius: const BorderRadius.only(topLeft: Radius.circular(16), topRight: Radius.circular(16)),
                                        child: AspectRatio(
                                          aspectRatio: 16 / 9,
                                          child: Image.network(
                                            article.coverImageUrl,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(24),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              article.date,
                                              style: const TextStyle(color: AppColors.sage, fontWeight: FontWeight.bold, fontSize: 14, letterSpacing: 1),
                                            ),
                                            const SizedBox(height: 12),
                                            Text(
                                              strings.isTurkish ? article.titleTr : article.titleEn,
                                              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: AppColors.forest, height: 1.3),
                                            ),
                                            const SizedBox(height: 16),
                                            Text(
                                              strings.isTurkish ? article.summaryTr : article.summaryEn,
                                              style: const TextStyle(fontSize: 16, color: Colors.black54, height: 1.6),
                                              maxLines: 3,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            const SizedBox(height: 24),
                                            Row(
                                              children: [
                                                const CircleAvatar(
                                                  radius: 16,
                                                  backgroundColor: AppColors.sage,
                                                  child: Icon(Icons.spa, color: Colors.white, size: 16),
                                                ),
                                                const SizedBox(width: 12),
                                                Text(article.author, style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.ink)),
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                    ],
                                  )
                                : IntrinsicHeight(
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.stretch,
                                      children: [
                                        Expanded(
                                          flex: 2,
                                          child: ClipRRect(
                                            borderRadius: const BorderRadius.only(topLeft: Radius.circular(16), bottomLeft: Radius.circular(16)),
                                            child: Image.network(
                                              article.coverImageUrl,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 3,
                                          child: Padding(
                                            padding: const EdgeInsets.all(32),
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  article.date,
                                                  style: const TextStyle(color: AppColors.sage, fontWeight: FontWeight.bold, fontSize: 14, letterSpacing: 1),
                                                ),
                                                const SizedBox(height: 12),
                                                Text(
                                                  strings.isTurkish ? article.titleTr : article.titleEn,
                                                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: AppColors.forest, height: 1.3),
                                                ),
                                                const SizedBox(height: 16),
                                                Text(
                                                  strings.isTurkish ? article.summaryTr : article.summaryEn,
                                                  style: const TextStyle(fontSize: 16, color: Colors.black54, height: 1.6),
                                                  maxLines: 3,
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                                const SizedBox(height: 24),
                                                Row(
                                                  children: [
                                                    const CircleAvatar(
                                                      radius: 16,
                                                      backgroundColor: AppColors.sage,
                                                      child: Icon(Icons.spa, color: Colors.white, size: 16),
                                                    ),
                                                    const SizedBox(width: 12),
                                                    Text(article.author, style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.ink)),
                                                  ],
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                            ),
                          );
                        }).toList(),
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
}
