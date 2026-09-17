import 'dart:math' as math;
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/services/shared_prefs_service.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../data/models/question.dart';
import '../../../../data/repositories/questions_repository.dart';
import '../../providers/game_provider.dart';
import '../../../results/presentation/pages/result_screen.dart';

class GameScreen extends StatefulWidget {
  GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  final TextEditingController _answerController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<GameProvider>().addListener(_onGameStateChanged);
    });
  }

  void _onGameStateChanged() {
    if (!mounted) return;
    if (context.read<GameProvider>().isGameOver) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => ResultScreen()),
      );
    }
  }

  @override
  void dispose() {
    _answerController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _submitAnswer() {
    if (_answerController.text.isEmpty) return;
    context.read<GameProvider>().answerQuestion(_answerController.text);
    _answerController.clear();
    _focusNode.requestFocus();
  }

  void _passQuestion() {
    context.read<GameProvider>().passQuestion();
    _answerController.clear();
    _focusNode.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    child: Consumer<GameProvider>(
                      builder: (context, provider, child) {
                        final question = provider.currentQuestion;
                        if (question == null) return Center(child: CircularProgressIndicator());
                        
                        return SingleChildScrollView(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(height: 80), // To make room for the floating header
                              _buildCircularAlphabet(provider),
                              SizedBox(height: 32),
                              _buildQuestionCard(question),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ),
                _buildInputArea(),
              ],
            ),
            // Floating Header on top
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: _buildHeader(),
            ),
            
            // Pause Overlay
            Consumer<GameProvider>(
              builder: (context, prov, child) {
                if (!prov.isPaused) return SizedBox.shrink();
                
                return Positioned.fill(
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                    child: Container(
                      color: Colors.black.withOpacity(0.5),
                      child: Center(
                        child: Container(
                          padding: EdgeInsets.all(24),
                          margin: EdgeInsets.symmetric(horizontal: 40),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(24),
                            border: Border.all(color: AppColors.primary, width: 4),
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.pause_circle_rounded, size: 64, color: AppColors.primary),
                              SizedBox(height: 16),
                              Text(
                                'OYUN DURDURULDU',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w900,
                                  color: AppColors.textMain,
                                ),
                              ),
                              SizedBox(height: 32),
                              ElevatedButton(
                                onPressed: () {
                                  prov.resumeGame();
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.primary,
                                  foregroundColor: Colors.white,
                                  minimumSize: Size(double.infinity, 50),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                ),
                                child: Text('DEVAM ET', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                              ),
                              SizedBox(height: 12),
                              TextButton(
                                onPressed: () {
                                  prov.quitGame();
                                  Navigator.popUntil(context, (route) => route.isFirst);
                                },
                                style: TextButton.styleFrom(
                                  foregroundColor: AppColors.danger,
                                  minimumSize: Size(double.infinity, 50),
                                ),
                                child: Text('ANA MENÜYE DÖN', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ).animate().fadeIn();
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    final provider = context.read<GameProvider>();
    return Padding(
      padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Sol Kısım: Durdurma ve Yıldız (Puan)
          Consumer<GameProvider>(
            builder: (context, prov, child) {
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () {
                      prov.pauseGame();
                    },
                    child: Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        border: Border.all(color: Color(0xFFE5E5E5), width: 2),
                      ),
                      child: Icon(Icons.pause_rounded, color: AppColors.textLight, size: 24),
                    ),
                  ),
                  SizedBox(width: 8),
                  Container(
                    padding: EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Color(0xFFE5E5E5), width: 2),
                    ),
                    child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: AppColors.secondary,
                    borderRadius: BorderRadius.circular(16),
                    border: Border(bottom: BorderSide(color: AppColors.secondaryShadow, width: 3)),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.star_rounded, color: AppColors.warning, size: 24),
                      SizedBox(width: 8),
                      Text(
                        '${prov.score}',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ).animate(key: ValueKey(prov.score)).scale(duration: 200.ms, curve: Curves.easeOutBack),
                ],
              );
            },
          ),
          
          // Sağ Kısım: Süre ve Jokerler
          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Color(0xFFE5E5E5), width: 2),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: [
                ValueListenableBuilder<int>(
                  valueListenable: provider.timeLeftNotifier,
                  builder: (context, timeLeft, child) {
                    final isUrgent = timeLeft <= 10;
                    final bgColor = isUrgent ? AppColors.danger : Colors.white;
                    final shadowColor = isUrgent ? AppColors.dangerShadow : Color(0xFFE5E5E5);
                    final textColor = isUrgent ? Colors.white : AppColors.textMain;

                    return Container(
                      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: bgColor,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Color(0xFFE5E5E5), width: 2),
                        boxShadow: [
                          BoxShadow(color: shadowColor, offset: Offset(0, 3)),
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.timer_rounded, 
                            color: textColor, 
                            size: 20,
                          ),
                          SizedBox(width: 8),
                          Text(
                            '$timeLeft',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w900,
                              color: textColor,
                            ),
                          ),
                        ],
                      ),
                    ).animate(target: isUrgent ? 1 : 0).shake(hz: 4);
                  },
                ),
                SizedBox(height: 8),
                Consumer<GameProvider>(
                  builder: (context, prov, child) => _buildCornerJokers(prov),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCircularAlphabet(GameProvider provider) {
    final letters = QuestionsRepository.alphabet;
    double size = math.min(MediaQuery.of(context).size.width * 0.85, MediaQuery.of(context).size.height * 0.4);
    if (size > 360) size = 360;
    
    final radius = size / 2;

    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Center highlighted letter
          Container(
            width: size * 0.6,
            height: size * 0.6,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.warning.withOpacity(0.1),
            ),
            child: Center(
              child: Text(
                provider.currentQuestion?.startingLetter ?? '',
                style: TextStyle(
                  fontSize: 100,
                  fontWeight: FontWeight.w900,
                  color: AppColors.warning,
                ),
              ).animate(key: ValueKey(provider.currentQuestion?.startingLetter)).scale(curve: Curves.elasticOut, duration: 800.ms),
            ),
          ),
          ...List.generate(letters.length, (index) {
            String letter = letters[index];
            LetterState state = provider.letterStates[letter] ?? LetterState.unanswered;
            
            double angle = -math.pi / 2 + (2 * math.pi * index) / letters.length;
            double x = radius + (radius * 0.85) * math.cos(angle) - 18; 
            double y = radius + (radius * 0.85) * math.sin(angle) - 18;

            Color bgColor;
            Color borderColor;
            Color textColor = Colors.white;
            
            switch (state) {
              case LetterState.unanswered:
                bgColor = AppColors.letterUnanswered;
                borderColor = Color(0xFFAFAFAF);
                break;
              case LetterState.current:
                bgColor = AppColors.warning;
                borderColor = AppColors.warningShadow;
                break;
              case LetterState.correct:
                bgColor = AppColors.primary;
                borderColor = AppColors.primaryShadow;
                break;
              case LetterState.wrong:
                bgColor = AppColors.danger;
                borderColor = AppColors.dangerShadow;
                break;
            }

            final isCurrent = state == LetterState.current;

            Widget letterWidget = AnimatedContainer(
              duration: Duration(milliseconds: 200),
              width: isCurrent ? 44 : 36,
              height: isCurrent ? 44 : 36,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: bgColor,
                border: Border(bottom: BorderSide(color: borderColor, width: isCurrent ? 4 : 3)),
              ),
              child: Center(
                child: Text(
                  letter,
                  style: TextStyle(
                    color: textColor,
                    fontWeight: FontWeight.w900,
                    fontSize: isCurrent ? 20 : 16,
                  ),
                ),
              ),
            );
            
            if (state == LetterState.correct) {
              letterWidget = letterWidget.animate(key: ValueKey(state)).scale(duration: 400.ms, curve: Curves.elasticOut);
            } else if (state == LetterState.wrong) {
              letterWidget = letterWidget.animate(key: ValueKey(state)).shake(duration: 400.ms);
            }

            return Positioned(left: x, top: y, child: letterWidget);
          }),
        ],
      ),
    );
  }

  Widget _buildQuestionCard(Question question) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Color(0xFFE5E5E5), width: 2),
        boxShadow: [
          BoxShadow(
            color: Color(0xFFE5E5E5),
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(
              question.category.name.toUpperCase(),
              style: TextStyle(
                color: AppColors.secondary,
                fontWeight: FontWeight.w900,
                letterSpacing: 1.5,
                fontSize: 14,
              ),
            ),
          ),
          SizedBox(height: 16),
          Text(
            question.text,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColors.textMain,
              fontSize: 20,
              fontWeight: FontWeight.bold,
              height: 1.4,
            ),
          ),
        ],
      ),
    ).animate(key: ValueKey(question.id)).fadeIn().slideX(begin: 0.1, end: 0, duration: 400.ms);
  }

  Widget _buildCornerJokers(GameProvider provider) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildSmallJokerButton(
          icon: Icons.lightbulb_outline,
          label: 'Harf Al',
          color: AppColors.secondary,
          shadowColor: AppColors.secondaryShadow,
          isDisabled: !provider.canUseHint,
          stock: SharedPrefsService.hintCount,
          onPressed: () {
            final hint = provider.useHintJoker();
            if (hint != null) {
              _answerController.text = hint;
              _answerController.selection = TextSelection.fromPosition(TextPosition(offset: hint.length));
            }
          },
        ),
        SizedBox(width: 8),
        _buildSmallJokerButton(
          icon: Icons.more_time,
          label: '+10 Sn',
          color: AppColors.primary,
          shadowColor: AppColors.primaryShadow,
          isDisabled: !provider.canUseTime,
          stock: SharedPrefsService.timeCount,
          onPressed: () => provider.useTimeJoker(),
        ),
        SizedBox(width: 8),
        _buildSmallJokerButton(
          icon: Icons.swap_horiz,
          label: 'Değiştir',
          color: AppColors.warning,
          shadowColor: AppColors.warningShadow,
          isDisabled: !provider.canUseChange,
          stock: SharedPrefsService.changeCount,
          onPressed: () {
            provider.useChangeQuestionJoker();
            _answerController.clear();
          },
        ),
      ],
    );
  }

  Widget _buildSmallJokerButton({
    required IconData icon,
    required String label,
    required Color color,
    required Color shadowColor,
    required bool isDisabled,
    required int stock,
    required VoidCallback onPressed,
  }) {
    return GestureDetector(
      onTap: isDisabled ? null : onPressed,
      child: Opacity(
        opacity: isDisabled ? 0.4 : 1.0,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: isDisabled ? Color(0xFFE5E5E5) : color,
                    shape: BoxShape.circle,
                    border: Border(bottom: BorderSide(color: isDisabled ? Color(0xFFCCCCCC) : shadowColor, width: 3)),
                  ),
                  child: Icon(icon, color: Colors.white, size: 20),
                ),
                Positioned(
                  top: -4,
                  right: -4,
                  child: Container(
                    padding: EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: AppColors.danger,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      '$stock',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: AppColors.textLight,
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputArea() {
    return Consumer<GameProvider>(
      builder: (context, provider, child) {
        return Container(
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
            border: Border(top: BorderSide(color: Color(0xFFE5E5E5), width: 2)),
          ),
          child: SafeArea(
            top: false,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: _answerController,
                  focusNode: _focusNode,
                  onSubmitted: (_) => _submitAnswer(),
                  textInputAction: TextInputAction.done,
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(
                    hintText: 'Cevabını Yaz...',
                    hintStyle: TextStyle(color: AppColors.textLight, fontWeight: FontWeight.bold),
                    filled: true,
                    fillColor: AppColors.background,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide(color: Color(0xFFE5E5E5), width: 2),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide(color: Color(0xFFE5E5E5), width: 2),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide(color: AppColors.secondary, width: 2),
                    ),
                    contentPadding: EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                  ),
                  style: TextStyle(color: AppColors.textMain, fontSize: 22, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: FlatThickButton(
                        text: 'PAS',
                        color: Colors.white,
                        textColor: AppColors.textLight,
                        shadowColor: Color(0xFFE5E5E5),
                        onPressed: _passQuestion,
                      ),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      flex: 2,
                      child: FlatThickButton(
                        text: 'KONTROL ET',
                        color: AppColors.primary,
                        shadowColor: AppColors.primaryShadow,
                        onPressed: _submitAnswer,
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
