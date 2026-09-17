import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../game/providers/game_provider.dart';
import '../../../home/presentation/pages/home_screen.dart';
import '../../../game/presentation/pages/game_screen.dart';
import '../../../../core/services/shared_prefs_service.dart';

import 'package:confetti/confetti.dart';

class ResultScreen extends StatefulWidget {
  ResultScreen({super.key});

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  late ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(duration: Duration(seconds: 3));
    
    // Play confetti if it's a new high score or score > 200
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = context.read<GameProvider>();
      if (provider.isNewHighScore || provider.correctCount >= 20) {
        _confettiController.play();
      }
    });
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Consumer<GameProvider>(
          builder: (context, provider, child) {
            return Stack(
              children: [
                Column(
                  children: [
                SizedBox(height: 30),
                Text(
                  'OYUN BİTTİ!',
                  style: TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.w900,
                    color: AppColors.secondary,
                    letterSpacing: 2,
                  ),
                ).animate().scale(curve: Curves.elasticOut, duration: 1.seconds),
                
                SizedBox(height: 30),
                
                // Score Overview
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 24),
                  padding: EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: Color(0xFFE5E5E5), width: 2),
                    boxShadow: [
                      BoxShadow(color: Color(0xFFE5E5E5), offset: Offset(0, 6)),
                    ],
                  ),
                  child: Column(
                    children: [
                      if (provider.isNewHighScore)
                        Container(
                          margin: EdgeInsets.only(bottom: 24),
                          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: AppColors.warning,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(color: AppColors.warningShadow, offset: Offset(0, 4)),
                            ],
                          ),
                          child: Text(
                            '🎉 YENİ REKOR! 🎉',
                            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 16),
                          ),
                        ).animate(onPlay: (controller) => controller.repeat(reverse: true)).scale(begin: Offset(1,1), end: Offset(1.1,1.1)),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _buildStat('DOĞRU', provider.correctCount.toString(), AppColors.primary),
                          _buildStat('PUAN', provider.score.toString(), AppColors.warning, isLarge: true),
                          _buildStat('YANLIŞ', provider.wrongCount.toString(), AppColors.danger),
                        ],
                      ),
                      if (!provider.isNewHighScore) ...[
                        SizedBox(height: 16),
                        Divider(color: Color(0xFFE5E5E5), thickness: 2),
                        SizedBox(height: 8),
                        Text(
                          'EN YÜKSEK SKOR: ${SharedPrefsService.highScore}',
                          style: TextStyle(
                            color: AppColors.textLight,
                            fontWeight: FontWeight.w900,
                            fontSize: 14,
                          ),
                        ),
                      ],
                      SizedBox(height: 16),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: Color(0xFFFFD700),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.monetization_on_rounded, color: Colors.white, size: 24),
                            SizedBox(width: 8),
                            Text(
                              '+${provider.earnedCoins} ALTIN',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w900,
                                fontSize: 18,
                              ),
                            ),
                          ],
                        ),
                      ).animate().fadeIn(delay: 800.ms).scale(curve: Curves.elasticOut),
                    ],
                  ),
                ).animate().fadeIn(delay: 500.ms).slideY(begin: 0.2, end: 0),
                
                SizedBox(height: 30),
                Text(
                  'ÖZET',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w900,
                    color: AppColors.textMain,
                    letterSpacing: 1.5,
                  ),
                ).animate().fadeIn(delay: 800.ms),
                
                SizedBox(height: 16),
                
                // Answers List
                Expanded(
                  child: ListView.builder(
                    padding: EdgeInsets.symmetric(horizontal: 24),
                    itemCount: provider.gameQuestions.length,
                    itemBuilder: (context, index) {
                      final q = provider.gameQuestions[index];
                      final state = provider.letterStates[q.startingLetter] ?? LetterState.unanswered;
                      
                      Color itemColor;
                      IconData icon;
                      
                      switch (state) {
                        case LetterState.correct:
                          itemColor = AppColors.primary;
                          icon = Icons.check_circle_rounded;
                          break;
                        case LetterState.wrong:
                          itemColor = AppColors.danger;
                          icon = Icons.cancel_rounded;
                          break;
                        default:
                          itemColor = AppColors.textLight;
                          icon = Icons.help_rounded;
                      }

                      return Padding(
                        padding: EdgeInsets.only(bottom: 12),
                        child: Container(
                          padding: EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: Color(0xFFE5E5E5), width: 2),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 44,
                                height: 44,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: itemColor.withOpacity(0.1),
                                  border: Border.all(color: itemColor, width: 2),
                                ),
                                child: Center(
                                  child: Text(
                                    q.startingLetter,
                                    style: TextStyle(
                                      color: itemColor,
                                      fontWeight: FontWeight.w900,
                                      fontSize: 20,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      q.text,
                                      style: TextStyle(color: AppColors.textMain, fontSize: 14, fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(height: 4),
                                    Text(
                                      q.answer,
                                      style: TextStyle(
                                        color: itemColor,
                                        fontWeight: FontWeight.w900,
                                        fontSize: 18,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Icon(icon, color: itemColor, size: 32),
                            ],
                          ),
                        ),
                      ).animate().fadeIn(delay: Duration(milliseconds: 800 + (index * 50))).slideX(begin: 0.1, end: 0);
                    },
                  ),
                ),
                
                // Bottom Actions
                Container(
                  padding: EdgeInsets.all(24.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border(top: BorderSide(color: Color(0xFFE5E5E5), width: 2)),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: FlatThickButton(
                          text: 'MENÜ',
                          color: Colors.white,
                          textColor: AppColors.textLight,
                          shadowColor: Color(0xFFE5E5E5),
                          onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (context) => HomeScreen()),
                            );
                          },
                        ),
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        flex: 2,
                        child: FlatThickButton(
                          text: 'TEKRAR OYNA',
                          color: AppColors.secondary,
                          shadowColor: AppColors.secondaryShadow,
                          onPressed: () {
                            provider.startGame();
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (context) => GameScreen()),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ).animate().fadeIn(delay: 1.5.seconds).slideY(begin: 0.5, end: 0),
              ],
            ),
            
            // Confetti Overlay
            Align(
              alignment: Alignment.topCenter,
              child: ConfettiWidget(
                confettiController: _confettiController,
                blastDirectionality: BlastDirectionality.explosive,
                shouldLoop: false,
                colors: [
                  Colors.green,
                  Colors.blue,
                  Colors.pink,
                  Colors.orange,
                  Colors.purple,
                  Color(0xFFFFD700),
                ],
              ),
            ),
          ],
        );
          },
        ),
      ),
    );
  }

  Widget _buildStat(String label, String value, Color color, {bool isLarge = false}) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: isLarge ? 48 : 32,
            fontWeight: FontWeight.w900,
            color: color,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w900,
            letterSpacing: 1.5,
            color: AppColors.textLight,
          ),
        ),
      ],
    );
  }
}
