import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../game/presentation/pages/game_screen.dart';
import '../../../game/providers/game_provider.dart';
import '../../../../core/services/shared_prefs_service.dart';
import '../../../store/presentation/pages/store_screen.dart';
import '../../../settings/presentation/pages/settings_screen.dart';
import '../../../profile/presentation/pages/profile_screen.dart';
import '../../../leaderboard/presentation/pages/leaderboard_screen.dart';
import '../../../../data/models/question.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  QuestionCategory? _selectedCategory;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    setState(() {}); 
  }

  void _checkAndShowLeaderboard(BuildContext context) {
    if (SharedPrefsService.nickname == null || SharedPrefsService.nickname!.isEmpty) {
      _showNicknameDialog(context);
    } else {
      Navigator.push(context, MaterialPageRoute(builder: (context) => LeaderboardScreen()));
    }
  }

  void _showNicknameDialog(BuildContext context) {
    final TextEditingController controller = TextEditingController();
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text('Kullanıcı Adı Belirle', style: TextStyle(fontWeight: FontWeight.bold)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Liderlik tablosunda görünmek için bir isim belirlemelisin.'),
            SizedBox(height: 16),
            TextField(
              controller: controller,
              decoration: InputDecoration(
                hintText: 'Örn: SoruCanavarı',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
              maxLength: 15,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('İptal', style: TextStyle(color: AppColors.textLight)),
          ),
          ElevatedButton(
            onPressed: () async {
              if (controller.text.trim().isNotEmpty) {
                await SharedPrefsService.setNickname(controller.text.trim());
                if (context.mounted) {
                  Navigator.pop(context);
                  Navigator.push(context, MaterialPageRoute(builder: (context) => LeaderboardScreen()));
                }
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: Text('Kaydet', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Top Bar with Settings, Profile, Coins and Market
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => SettingsScreen()));
                        },
                        child: Container(
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            border: Border.all(color: Color(0xFFE5E5E5), width: 2),
                          ),
                          child: Icon(Icons.settings_rounded, color: AppColors.textLight, size: 24),
                        ),
                      ),
                      SizedBox(width: 8),
                      GestureDetector(
                        onTap: () => _checkAndShowLeaderboard(context),
                        child: Container(
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: AppColors.warning,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 2),
                            boxShadow: [
                              BoxShadow(color: Color(0xFFCD7F32), offset: Offset(0, 2)),
                            ],
                          ),
                          child: Icon(Icons.emoji_events_rounded, color: Colors.white, size: 24),
                        ),
                      ),
                      SizedBox(width: 8),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => ProfileScreen())).then((_) => setState(() {}));
                        },
                        child: Container(
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: AppColors.secondary,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 2),
                            boxShadow: [
                              BoxShadow(color: AppColors.secondaryShadow, offset: Offset(0, 2)),
                            ],
                          ),
                          child: Icon(Icons.person_rounded, color: Colors.white, size: 24),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Container(
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
                              '${SharedPrefsService.coins}',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 8),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => StoreScreen())).then((_) => setState(() {}));
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: Color(0xFFE5E5E5), width: 2),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.storefront_rounded, color: AppColors.primary, size: 20),
                              SizedBox(width: 4),
                              Text(
                                'MARKET',
                                style: TextStyle(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ).animate().fadeIn().slideY(begin: -0.5, end: 0),
              
              Spacer(),
              
              // Animated Flat Logo
              Container(
                width: 150,
                height: 150,
                decoration: BoxDecoration(
                  color: AppColors.secondary,
                  borderRadius: BorderRadius.circular(40),
                  border: Border(
                    bottom: BorderSide(color: AppColors.secondaryShadow, width: 10),
                  ),
                ),
                child: Center(
                  child: Text(
                    'P',
                    style: TextStyle(
                      fontSize: 80,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                    ),
                  ),
                ),
              )
              .animate(onPlay: (controller) => controller.repeat(reverse: true))
              .moveY(begin: -10, end: 10, duration: 2.seconds, curve: Curves.easeInOut),

              SizedBox(height: 40),
              
              // Title
              Text(
                'PASAPOLA',
                style: Theme.of(context).textTheme.displayLarge?.copyWith(
                  fontSize: 48,
                  letterSpacing: 4,
                  color: AppColors.primary,
                ),
              ).animate().fadeIn(duration: 500.ms).scale(curve: Curves.elasticOut),
              
              SizedBox(height: 16),
              
              Text(
                'EĞLENCELİ BİLGİ YARIŞMASI',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: AppColors.textLight,
                ),
              ).animate().fadeIn(delay: 500.ms),

              Spacer(),
              
              // High Score
              if (SharedPrefsService.highScore > 0)
                Container(
                  margin: EdgeInsets.only(bottom: 30),
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Color(0xFFE5E5E5), width: 2),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.emoji_events_rounded, color: AppColors.warning, size: 32),
                      SizedBox(width: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'EN YÜKSEK SKOR',
                            style: TextStyle(
                              color: AppColors.textLight,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            '${SharedPrefsService.highScore}',
                            style: TextStyle(
                              color: AppColors.warning,
                              fontSize: 28,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ).animate().fadeIn(delay: 700.ms).slideY(begin: 0.5, end: 0),

              // Category Selection
              Container(
                margin: EdgeInsets.only(bottom: 16),
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Color(0xFFE5E5E5), width: 2),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<QuestionCategory?>(
                    value: _selectedCategory,
                    hint: Text('Kategori Seç (İsteğe Bağlı)', style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.textLight)),
                    isExpanded: true,
                    icon: Icon(Icons.keyboard_arrow_down_rounded, color: AppColors.primary),
                    items: [
                      DropdownMenuItem(
                        value: null,
                        child: Text('Tümü (Karışık)', style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.textMain)),
                      ),
                      ...QuestionCategory.values.map((cat) {
                        return DropdownMenuItem(
                          value: cat,
                          child: Text(cat.name.toUpperCase(), style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.textMain)),
                        );
                      }).toList(),
                    ],
                    onChanged: (val) {
                      setState(() {
                        _selectedCategory = val;
                      });
                    },
                  ),
                ),
              ).animate().fadeIn(delay: 750.ms).slideY(begin: 0.5, end: 0),

              // Play Button
              FlatThickButton(
                text: 'OYUNA BAŞLA',
                color: AppColors.primary,
                shadowColor: AppColors.primaryShadow,
                onPressed: () {
                  context.read<GameProvider>().startGame(_selectedCategory);
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => GameScreen()),
                  );
                },
              ).animate().scale(delay: 800.ms, curve: Curves.elasticOut),
              
              SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
