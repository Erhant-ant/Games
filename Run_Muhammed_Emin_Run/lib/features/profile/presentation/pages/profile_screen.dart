import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/services/shared_prefs_service.dart';

class ProfileScreen extends StatelessWidget {
  ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    int totalGames = SharedPrefsService.totalGamesPlayed;
    int correctAnswers = SharedPrefsService.totalCorrectAnswers;
    int wrongAnswers = SharedPrefsService.totalWrongAnswers;
    int totalQuestions = correctAnswers + wrongAnswers;
    
    double successRate = totalQuestions == 0 ? 0 : (correctAnswers / totalQuestions) * 100;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.textMain),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'PROFİL VE İSTATİSTİKLER',
          style: TextStyle(
            color: AppColors.textMain,
            fontWeight: FontWeight.w900,
            letterSpacing: 1.5,
            fontSize: 16,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(24.0),
        child: Column(
          children: [
            // Profile Avatar
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: AppColors.secondary,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 4),
                boxShadow: [
                  BoxShadow(color: AppColors.secondaryShadow, offset: Offset(0, 6)),
                ],
              ),
              child: Icon(Icons.person_rounded, size: 60, color: Colors.white),
            ).animate().scale(curve: Curves.elasticOut, duration: 800.ms),
            
            SizedBox(height: 16),
            Text(
              'OYUNCU',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w900,
                color: AppColors.textMain,
              ),
            ).animate().fadeIn(delay: 200.ms),
            
            SizedBox(height: 32),
            
            // Stats Grid
            Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    title: 'OYNANAN\nOYUN',
                    value: '$totalGames',
                    icon: Icons.sports_esports_rounded,
                    color: AppColors.primary,
                  ).animate().slideX(begin: -0.5, end: 0, delay: 300.ms),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: _buildStatCard(
                    title: 'BAŞARI\nORANI',
                    value: '%${successRate.toStringAsFixed(1)}',
                    icon: Icons.pie_chart_rounded,
                    color: AppColors.warning,
                  ).animate().slideX(begin: 0.5, end: 0, delay: 300.ms),
                ),
              ],
            ),
            SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    title: 'TOPLAM\nDOĞRU',
                    value: '$correctAnswers',
                    icon: Icons.check_circle_rounded,
                    color: Colors.green,
                  ).animate().slideX(begin: -0.5, end: 0, delay: 400.ms),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: _buildStatCard(
                    title: 'TOPLAM\nYANLIŞ',
                    value: '$wrongAnswers',
                    icon: Icons.cancel_rounded,
                    color: AppColors.danger,
                  ).animate().slideX(begin: 0.5, end: 0, delay: 400.ms),
                ),
              ],
            ),
            
            SizedBox(height: 40),
            
            // Achievements (Rozetler)
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'BAŞARIMLAR (ROZETLER)',
                style: TextStyle(
                  color: AppColors.textLight,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.5,
                ),
              ),
            ).animate().fadeIn(delay: 500.ms),
            SizedBox(height: 16),
            
            _buildAchievement(
              title: 'İlk Adım',
              subtitle: 'İlk oyununu tamamla',
              icon: Icons.play_arrow_rounded,
              isUnlocked: totalGames >= 1,
            ).animate().fadeIn(delay: 600.ms),
            SizedBox(height: 12),
            _buildAchievement(
              title: 'Amatör',
              subtitle: '10 oyun tamamla',
              icon: Icons.military_tech_rounded,
              isUnlocked: totalGames >= 10,
            ).animate().fadeIn(delay: 700.ms),
            SizedBox(height: 12),
            _buildAchievement(
              title: 'Bilgin',
              subtitle: '100 doğru cevaba ulaş',
              icon: Icons.lightbulb_rounded,
              isUnlocked: correctAnswers >= 100,
            ).animate().fadeIn(delay: 800.ms),
            SizedBox(height: 12),
            _buildAchievement(
              title: 'Zengin',
              subtitle: '1000 altına ulaş',
              icon: Icons.monetization_on_rounded,
              isUnlocked: SharedPrefsService.coins >= 1000,
            ).animate().fadeIn(delay: 900.ms),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Color(0xFFE5E5E5), width: 2),
        boxShadow: [
          BoxShadow(color: Color(0xFFE5E5E5), offset: Offset(0, 4)),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 32),
          SizedBox(height: 12),
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w900,
              color: color,
            ),
          ),
          SizedBox(height: 4),
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w900,
              color: AppColors.textLight,
              letterSpacing: 1,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAchievement({
    required String title,
    required String subtitle,
    required IconData icon,
    required bool isUnlocked,
  }) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isUnlocked ? Colors.white : Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: isUnlocked ? AppColors.warning : Color(0xFFE5E5E5), width: 2),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isUnlocked ? AppColors.warning : Color(0xFFE5E5E5),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: isUnlocked ? Colors.white : AppColors.textLight, size: 24),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                    color: isUnlocked ? AppColors.textMain : AppColors.textLight,
                  ),
                ),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.textLight,
                  ),
                ),
              ],
            ),
          ),
          if (isUnlocked)
            Icon(Icons.check_circle_rounded, color: AppColors.warning)
          else
            Icon(Icons.lock_rounded, color: AppColors.textLight),
        ],
      ),
    );
  }
}
