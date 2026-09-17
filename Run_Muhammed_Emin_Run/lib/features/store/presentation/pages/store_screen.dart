import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/services/shared_prefs_service.dart';
import '../../../../core/theme/theme_provider.dart';

class StoreScreen extends StatefulWidget {
  StoreScreen({super.key});

  @override
  State<StoreScreen> createState() => _StoreScreenState();
}

class _StoreScreenState extends State<StoreScreen> {
  int _coins = SharedPrefsService.coins;

  void _buyItem(String key, int price, VoidCallback onBought) {
    if (_coins >= price) {
      SharedPrefsService.setCoins(_coins - price).then((_) {
        setState(() {
          _coins -= price;
          onBought();
          if (SharedPrefsService.isVibrationEnabled) HapticFeedback.mediumImpact();
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Satın alma başarılı!'),
            backgroundColor: AppColors.primary,
          ),
        );
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Yeterli altınınız yok!'),
          backgroundColor: AppColors.danger,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.textMain),
            onPressed: () => Navigator.pop(context),
          ),
          title: Text(
            'MARKET',
            style: TextStyle(
              color: AppColors.textMain,
              fontWeight: FontWeight.w900,
              letterSpacing: 2,
            ),
          ),
          centerTitle: true,
          actions: [
            Container(
              margin: EdgeInsets.only(right: 16),
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Color(0xFFFFD700),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  Icon(Icons.monetization_on_rounded, color: Colors.white, size: 20),
                  SizedBox(width: 4),
                  Text(
                    '$_coins',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ).animate(key: ValueKey(_coins)).scale(curve: Curves.elasticOut, duration: 400.ms),
          ],
          bottom: TabBar(
            indicatorColor: AppColors.primary,
            indicatorWeight: 4,
            labelColor: AppColors.textMain,
            unselectedLabelColor: AppColors.textLight,
            labelStyle: TextStyle(fontWeight: FontWeight.w900, fontSize: 16),
            tabs: [
              Tab(text: 'JOKERLER', icon: Icon(Icons.stars_rounded)),
              Tab(text: 'TEMALAR', icon: Icon(Icons.palette_rounded)),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildJokersTab(),
            _buildThemesTab(),
          ],
        ),
      ),
    );
  }

  Widget _buildJokersTab() {
    return ListView(
      padding: EdgeInsets.all(24.0),
      children: [
        _buildStoreItem(
          title: 'Harf Al',
          description: 'Cevabın ilk harflerini gösterir.',
          icon: Icons.lightbulb_outline,
          color: AppColors.secondary,
          shadowColor: AppColors.secondaryShadow,
          price: 50,
          stock: SharedPrefsService.hintCount,
          onBuy: () {
            _buyItem('hint', 50, () {
              SharedPrefsService.setHintCount(SharedPrefsService.hintCount + 1);
            });
          },
        ),
        SizedBox(height: 16),
        _buildStoreItem(
          title: '+10 Saniye',
          description: 'Kalan süreye 10 saniye ekler.',
          icon: Icons.more_time,
          color: AppColors.primary,
          shadowColor: AppColors.primaryShadow,
          price: 50,
          stock: SharedPrefsService.timeCount,
          onBuy: () {
            _buyItem('time', 50, () {
              SharedPrefsService.setTimeCount(SharedPrefsService.timeCount + 1);
            });
          },
        ),
        SizedBox(height: 16),
        _buildStoreItem(
          title: 'Soru Değiştir',
          description: 'Soruyu aynı harfli başka bir soruyla değiştirir.',
          icon: Icons.swap_horiz,
          color: AppColors.warning,
          shadowColor: AppColors.warningShadow,
          price: 100,
          stock: SharedPrefsService.changeCount,
          onBuy: () {
            _buyItem('change', 100, () {
              SharedPrefsService.setChangeCount(SharedPrefsService.changeCount + 1);
            });
          },
        ),
      ],
    );
  }

  Widget _buildThemesTab() {
    final themeProvider = context.watch<ThemeProvider>();
    final unlockedThemes = SharedPrefsService.unlockedThemes;

    return ListView(
      padding: EdgeInsets.all(24.0),
      children: [
        _buildThemeItem(
          themeId: 'classic',
          title: 'Klasik Mod',
          description: 'Orijinal yeşil ve mavi tonları.',
          previewColor: Color(0xFF58CC02),
          price: 0,
          isUnlocked: unlockedThemes.contains('classic'),
          isCurrent: themeProvider.currentTheme == 'classic',
          onTap: () => _handleThemeTap('classic', 0, unlockedThemes, themeProvider),
        ),
        SizedBox(height: 16),
        _buildThemeItem(
          themeId: 'dark',
          title: 'Gece Modu',
          description: 'Göz yormayan koyu tonlar ve altın sarısı detaylar.',
          previewColor: Color(0xFF2B2B36),
          price: 1000,
          isUnlocked: unlockedThemes.contains('dark'),
          isCurrent: themeProvider.currentTheme == 'dark',
          onTap: () => _handleThemeTap('dark', 1000, unlockedThemes, themeProvider),
        ),
        SizedBox(height: 16),
        _buildThemeItem(
          themeId: 'neon',
          title: 'Neon Mod',
          description: 'Cyberpunk tarzı fosforlu renkler.',
          previewColor: Color(0xFF00FFCC),
          price: 1500,
          isUnlocked: unlockedThemes.contains('neon'),
          isCurrent: themeProvider.currentTheme == 'neon',
          onTap: () => _handleThemeTap('neon', 1500, unlockedThemes, themeProvider),
        ),
        SizedBox(height: 16),
        _buildThemeItem(
          themeId: 'retro',
          title: 'Retro Kırmızı',
          description: 'Klasik atari salonlarını andıran krem ve kırmızı.',
          previewColor: Color(0xFFD93829),
          price: 2000,
          isUnlocked: unlockedThemes.contains('retro'),
          isCurrent: themeProvider.currentTheme == 'retro',
          onTap: () => _handleThemeTap('retro', 2000, unlockedThemes, themeProvider),
        ),
      ],
    );
  }

  void _handleThemeTap(String themeId, int price, List<String> unlocked, ThemeProvider provider) {
    if (unlocked.contains(themeId)) {
      provider.setTheme(themeId);
    } else {
      _buyItem(themeId, price, () {
        SharedPrefsService.unlockTheme(themeId);
      });
    }
  }

  Widget _buildThemeItem({
    required String themeId,
    required String title,
    required String description,
    required Color previewColor,
    required int price,
    required bool isUnlocked,
    required bool isCurrent,
    required VoidCallback onTap,
  }) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isCurrent ? AppColors.primary : Color(0xFFE5E5E5),
          width: isCurrent ? 3 : 2,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: previewColor,
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.textMain.withValues(alpha: 0.1), width: 2),
            ),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                    color: AppColors.textMain,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.textLight,
                  ),
                ),
                SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: onTap,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isCurrent
                          ? AppColors.textLight
                          : (isUnlocked ? AppColors.primary : Color(0xFFFFD700)),
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (!isUnlocked) ...[
                          Icon(Icons.monetization_on_rounded, size: 16),
                          SizedBox(width: 4),
                          Text('$price', style: TextStyle(fontWeight: FontWeight.w900)),
                        ] else if (isCurrent) ...[
                          Icon(Icons.check_circle_rounded, size: 16),
                          SizedBox(width: 4),
                          Text('KULLANILIYOR', style: TextStyle(fontWeight: FontWeight.w900)),
                        ] else ...[
                          Text('KULLAN', style: TextStyle(fontWeight: FontWeight.w900)),
                        ],
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ).animate().fadeIn().slideY(begin: 0.2, end: 0);
  }

  Widget _buildStoreItem({
    required String title,
    required String description,
    required IconData icon,
    required Color color,
    required Color shadowColor,
    required int price,
    required int stock,
    required VoidCallback onBuy,
  }) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Color(0xFFE5E5E5), width: 2),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
              border: Border(bottom: BorderSide(color: shadowColor, width: 4)),
            ),
            child: Icon(icon, color: Colors.white, size: 28),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                        color: AppColors.textMain,
                      ),
                    ),
                    Text(
                      'Stok: $stock',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textLight,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.textLight,
                  ),
                ),
                SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: onBuy,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFFFFD700),
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'SATIN AL',
                          style: TextStyle(
                            fontWeight: FontWeight.w900,
                            letterSpacing: 1,
                          ),
                        ),
                        SizedBox(width: 8),
                        Icon(Icons.monetization_on_rounded, size: 16),
                        SizedBox(width: 4),
                        Text(
                          '$price',
                          style: TextStyle(
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ).animate().fadeIn().slideY(begin: 0.2, end: 0);
  }
}
