import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/localization/app_localizations.dart';

class MobileDrawer extends StatelessWidget {
  const MobileDrawer({super.key, required this.onLanguageChanged});
  
  final ValueChanged<String> onLanguageChanged;

  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context);
    final isTurkish = strings.isTurkish;

    return Drawer(
      backgroundColor: Colors.white,
      child: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                border: Border(bottom: BorderSide(color: Color(0xFFE4DED2))),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.menu_book, color: AppColors.forest, size: 24),
                      const SizedBox(width: 12),
                      Text(
                        strings.text('navHome').toUpperCase(),
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.forest),
                      ),
                    ],
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: AppColors.ink),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
            ),
            
            // Menu Items
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  _DrawerItem(
                    title: isTurkish ? 'PEKMEZ VE REÇEL ÇEŞİTLERİ' : 'JAMS & MOLASSES',
                    children: [
                      _DrawerSubItem(title: strings.text('navJam'), route: '/category/jams'),
                      _DrawerSubItem(title: strings.text('navMolasses'), route: '/category/molasses'),
                    ],
                  ),
                  _DrawerItem(
                    title: strings.text('navSauces'),
                    children: [
                      _DrawerSubItem(title: 'BİBER SALÇASI', route: '/category/sauces-pepper'),
                      _DrawerSubItem(title: 'DOMATES SALÇASI', route: '/category/sauces-tomato'),
                      _DrawerSubItem(title: 'BİBER&DOMATES KARIŞIK SALÇA', route: '/category/sauces-mixed'),
                      _DrawerSubItem(title: 'SOS ÇEŞİTLERİ', route: '/category/sauces-other'),
                    ],
                  ),
                  _DrawerItem(
                    title: isTurkish ? 'KURUTULMUŞ ÜRÜNLER' : 'DRIED PRODUCTS',
                    children: [
                      _DrawerSubItem(title: 'KURUTULMUŞ MEYVELER', route: '/category/dried-fruits'),
                      _DrawerSubItem(title: 'KURUTULMUŞ SEBZELER', route: '/category/dried-vegetables'),
                      _DrawerSubItem(title: 'DİĞERLERİ', route: '/category/dried-other'),
                    ],
                  ),
                  ListTile(
                    title: Text(strings.text('navSiirtYoresel').toUpperCase(), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 14, color: AppColors.forest),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.pushNamed(context, '/category/siirt-yoresel');
                    },
                  ),
                  const Divider(color: Color(0xFFE4DED2)),
                  ListTile(
                    title: Text(strings.text('navCampaigns').toUpperCase(), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: AppColors.terracotta)),
                    leading: const Icon(Icons.discount_outlined, color: AppColors.terracotta, size: 20),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 14, color: AppColors.terracotta),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.pushNamed(context, '/category/campaigns');
                    },
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 8),
                    child: Divider(color: Color(0xFFE4DED2)),
                  ),
                  
                  // Hesabım & Siparişler
                  _DrawerIconItem(
                    title: isTurkish ? 'Hesabım' : 'My Account',
                    icon: Icons.person_outline,
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.pushNamed(context, '/account');
                    },
                  ),
                  _DrawerIconItem(
                    title: isTurkish ? 'Sipariş Takibi' : 'Order Tracking',
                    icon: Icons.local_shipping_outlined,
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.pushNamed(context, '/account');
                    },
                  ),
                  _DrawerIconItem(
                    title: isTurkish ? 'Şifremi Unuttum' : 'Forgot Password',
                    icon: Icons.lock_outline,
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.pushNamed(context, '/login');
                    },
                  ),
                  
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 8),
                    child: Divider(color: Color(0xFFE4DED2)),
                  ),
                  
                  // Çiftlik & İletişim
                  _DrawerIconItem(
                    title: isTurkish ? 'Hikayemizi Keşfedin' : 'Discover Our Story',
                    icon: Icons.auto_awesome_outlined,
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                  _DrawerIconItem(
                    title: isTurkish ? 'Çiftlik Günlüğü' : 'Farm Journal',
                    icon: Icons.menu_book_outlined,
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.pushNamed(context, '/journal');
                    },
                  ),
                  _DrawerIconItem(
                    title: isTurkish ? 'Bize Ulaşın' : 'Contact Us',
                    icon: Icons.support_agent_outlined,
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.pushNamed(context, '/contact');
                    },
                  ),
                  _DrawerIconItem(
                    title: strings.text('whatsappOrder'),
                    icon: Icons.chat_outlined,
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                  const SizedBox(height: 24),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
                    color: const Color(0xFFF9F8F6),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(strings.isTurkish ? 'Dil Seçimi' : 'Language', style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.forest)),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            _LanguageBtn(
                              label: 'TR',
                              isActive: isTurkish,
                              onTap: () {
                                onLanguageChanged('tr');
                                Navigator.pop(context);
                              },
                            ),
                            const SizedBox(width: 12),
                            _LanguageBtn(
                              label: 'EN',
                              isActive: !isTurkish,
                              onTap: () {
                                onLanguageChanged('en');
                                Navigator.pop(context);
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LanguageBtn extends StatelessWidget {
  const _LanguageBtn({required this.label, required this.isActive, required this.onTap});
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(4),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isActive ? AppColors.forest : Colors.transparent,
          border: Border.all(color: isActive ? AppColors.forest : const Color(0xFFDCD6C9)),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isActive ? Colors.white : AppColors.ink,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

class _DrawerItem extends StatelessWidget {
  const _DrawerItem({required this.title, required this.children});
  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: Text(title.toUpperCase(), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
      iconColor: AppColors.forest,
      collapsedIconColor: AppColors.forest,
      shape: const Border(),
      children: children,
    );
  }
}

class _DrawerSubItem extends StatelessWidget {
  const _DrawerSubItem({required this.title, required this.route});
  final String title;
  final String route;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.only(left: 32, right: 16),
      title: Text(title, style: const TextStyle(fontSize: 13, color: AppColors.ink)),
      onTap: () {
        Navigator.pop(context); // Close drawer
        Navigator.pushNamed(context, route);
      },
    );
  }
}

class _DrawerIconItem extends StatelessWidget {
  const _DrawerIconItem({required this.title, required this.icon, required this.onTap});
  
  final String title;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: AppColors.forest, size: 22),
      title: Text(
        title, 
        style: const TextStyle(
          fontWeight: FontWeight.w600, 
          fontSize: 13, // 1 point smaller than the product headers (which are 14)
          color: AppColors.ink,
        ),
      ),
      trailing: const Icon(Icons.arrow_forward_ios, size: 12, color: Colors.grey),
      onTap: onTap,
    );
  }
}
