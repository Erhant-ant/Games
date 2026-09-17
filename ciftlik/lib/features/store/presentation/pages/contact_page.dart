import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/localization/app_localizations.dart';
import '../widgets/app_header.dart';
import '../widgets/app_footer.dart';
import '../widgets/mobile_drawer.dart';
import '../widgets/mobile_bottom_nav.dart';
import '../widgets/brand_refresh_indicator.dart';

class ContactPage extends StatelessWidget {
  const ContactPage({super.key, required this.onLanguageChanged});
  final ValueChanged<String> onLanguageChanged;

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.sizeOf(context).width >= 900;
    final strings = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: const Color(0xFFFAF9F6),
      drawer: isDesktop ? null : MobileDrawer(onLanguageChanged: onLanguageChanged),
      bottomNavigationBar: isDesktop ? null : const MobileBottomNav(),
      body: BrandRefreshIndicator(
          onRefresh: () async {
            await Future<void>.delayed(const Duration(milliseconds: 1500));
          },
          child: CustomScrollView(
        slivers: [
          ...buildStoreHeaderSlivers(
            isDesktop: isDesktop,
            onLanguageChanged: onLanguageChanged,
            onCartTap: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Cart opened'))),
            strings: strings,
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 64),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 800),
                  child: Column(
                    children: [
                      Text(strings.text('navContact').toUpperCase(), style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.terracotta, letterSpacing: 1.5)),
                      const SizedBox(height: 16),
                      Text(strings.text('contactInfo'), style: const TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: AppColors.forest, height: 1.1)),
                      const SizedBox(height: 48),
                      Container(
                        padding: const EdgeInsets.all(40),
                        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 20, offset: const Offset(0, 10))]),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Row(
                              children: [
                                Icon(Icons.location_on_outlined, color: AppColors.terracotta, size: 28),
                                SizedBox(width: 16),
                                Text('Adres', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.forest)),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Padding(
                              padding: const EdgeInsets.only(left: 44),
                              child: Text(strings.text('footerAddress'), style: const TextStyle(fontSize: 15, color: AppColors.ink, height: 1.5)),
                            ),
                            const Padding(
                              padding: EdgeInsets.symmetric(vertical: 24),
                              child: Divider(color: Color(0xFFE4DED2)),
                            ),
                            const Row(
                              children: [
                                Icon(Icons.phone_outlined, color: AppColors.terracotta, size: 28),
                                SizedBox(width: 16),
                                Text('Telefon', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.forest)),
                              ],
                            ),
                            const SizedBox(height: 12),
                            const Padding(
                              padding: EdgeInsets.only(left: 44),
                              child: Text('0532 123 45 67', style: TextStyle(fontSize: 15, color: AppColors.ink)),
                            ),
                            const Padding(
                              padding: EdgeInsets.symmetric(vertical: 24),
                              child: Divider(color: Color(0xFFE4DED2)),
                            ),
                            const Row(
                              children: [
                                Icon(Icons.email_outlined, color: AppColors.terracotta, size: 28),
                                SizedBox(width: 16),
                                Text('E-posta', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.forest)),
                              ],
                            ),
                            const SizedBox(height: 12),
                            const Padding(
                              padding: EdgeInsets.only(left: 44),
                              child: Text('info@zahidehanim.com', style: TextStyle(fontSize: 15, color: AppColors.ink)),
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
          const SliverToBoxAdapter(child: AppFooter()),
        ],
      ),
        ),
    );
  }
}
