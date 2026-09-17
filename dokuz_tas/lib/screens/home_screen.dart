import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/app_theme.dart';
import '../models/game_logic.dart';
import '../models/ai_opponent.dart';
import '../widgets/settings_dialog.dart';
import 'game_screen.dart';
import 'multiplayer_setup_screen.dart';
import 'tournament_screen.dart';
import 'records_screen.dart';
import '../widgets/tutorial_overlay.dart';
import '../theme/theme_controller.dart';
import '../widgets/profile_dialog.dart';

/// Ana menü ekranı — premium tasarım, animasyonlu başlangıç.
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeIn;
  late Animation<Offset> _slideUp;
  bool _showTutorial = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _fadeIn = CurvedAnimation(parent: _controller, curve: Curves.easeOut);
    _slideUp = Tween<Offset>(
      begin: const Offset(0, 0.15),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListenableBuilder(
        listenable: ThemeController(),
        builder: (context, _) {
          List<Color> bgColors;
          if (ThemeController().currentTheme == BoardTheme.neonCyberpunk) {
            bgColors = [const Color(0xFF1A1025), const Color(0xFF0A0510)];
          } else if (ThemeController().currentTheme == BoardTheme.antiqueMarble) {
            bgColors = [const Color(0xFFF5F5F5), const Color(0xFFDCDCDC)];
          } else {
            bgColors = [const Color(0xFF2A2218), AppTheme.scaffoldBg, const Color(0xFF0E0A06)];
          }

          return Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  gradient: RadialGradient(
                    center: const Alignment(0, -0.3),
                    radius: 1.2,
                    colors: bgColors,
                  ),
                ),
                child: SafeArea(
                  child: Stack(
                    children: [
                      Center(
                        child: SingleChildScrollView(
                          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
                          child: FadeTransition(
                            opacity: _fadeIn,
                        child: SlideTransition(
                          position: _slideUp,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // Logo / Başlık
                              _buildLogo(),
                              const SizedBox(height: 48),
                              // Alt başlık
                              const Text(
                                'KLASİK STRATEJİ OYUNU',
                                style: TextStyle(
                                  color: AppTheme.textMuted,
                                  fontSize: 12,
                                  letterSpacing: 4,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 48),
                              // Oyun başlat butonu
                              _buildPlayButton(context),
                              const SizedBox(height: 16),
                              // Turnuva butonu
                              _buildTournamentButton(context),
                              const SizedBox(height: 16),
                              // Bluetooth ile oyna butonu
                              _buildMultiplayerButton(context),
                              const SizedBox(height: 16),
                              // Rekorlar butonu
                              _buildRecordsButton(context),
                              const SizedBox(height: 16),
                              // Kurallar
                              _buildTutorialButton(context),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                      Positioned(
                        top: 16,
                        right: 16,
                        child: IconButton(
                          icon: const Icon(Icons.person, color: AppTheme.goldBright, size: 28),
                          tooltip: 'Profil Ayarları',
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) => const ProfileDialog(),
                            ).then((_) {
                              setState(() {});
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              if (_showTutorial)
                TutorialOverlay(
                  onClose: () {
                    setState(() {
                      _showTutorial = false;
                    });
                  },
                ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildLogo() {
    return Column(
      children: [
        // Dekoratif ikon
        Container(
          width: 90,
          height: 90,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: const RadialGradient(
              colors: [
                Color(0xFF3D2216),
                Color(0xFF2A1508),
              ],
            ),
            border: Border.all(
              color: AppTheme.gold.withValues(alpha: 0.5),
              width: 2,
            ),
            boxShadow: [
              BoxShadow(
                color: AppTheme.goldGlow,
                blurRadius: 20,
                spreadRadius: -4,
              ),
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.5),
                blurRadius: 16,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: const Center(
            child: Text(
              '9',
              style: TextStyle(
                fontSize: 42,
                fontWeight: FontWeight.w900,
                color: AppTheme.goldBright,
                shadows: [
                  Shadow(
                    color: Color(0x80000000),
                    blurRadius: 4,
                    offset: Offset(1, 2),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 20),
        // Başlık
        ShaderMask(
          shaderCallback: (bounds) => const LinearGradient(
            colors: [
              AppTheme.goldBright,
              AppTheme.gold,
              AppTheme.goldBright,
            ],
          ).createShader(bounds),
          child: const Text(
            'DOKUZ TAŞ',
            style: TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.w900,
              letterSpacing: 6,
              color: Colors.white,
            ),
          ),
        ),
        const SizedBox(height: 6),
        // Dekoratif çizgi
        Container(
          width: 120,
          height: 2,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.transparent,
                AppTheme.gold.withValues(alpha: 0.6),
                Colors.transparent,
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPlayButton(BuildContext context) {
    return SizedBox(
      width: 280,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () async {
            HapticFeedback.lightImpact();
            final result = await showDialog<Map<String, dynamic>>(
              context: context,
              builder: (context) => const SettingsDialog(
                initialMode: GameMode.pvp,
                initialDifficulty: Difficulty.medium,
                initialVariant: GameVariant.classic,
                initialDurationMinutes: 10,
                isStartScreen: true,
              ),
            );

            if (result != null && context.mounted) {
              Navigator.of(context).pushReplacement(
                PageRouteBuilder(
                  pageBuilder: (context, animation1, animation2) => GameScreen(
                    initialMode: result['mode'],
                    initialDifficulty: result['difficulty'],
                    initialVariant: result['variant'],
                    initialDurationMinutes: result['duration'],
                  ),
                  transitionsBuilder: (context, animation, secondaryAnimation, child) {
                    return FadeTransition(
                      opacity: animation,
                      child: child,
                    );
                  },
                  transitionDuration: const Duration(milliseconds: 500),
                ),
              );
            }
          },
          borderRadius: BorderRadius.circular(16),
          child: Ink(
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [
                  AppTheme.goldDark,
                  AppTheme.gold,
                  AppTheme.goldBright,
                  AppTheme.gold,
                ],
                stops: [0.0, 0.3, 0.6, 1.0],
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: AppTheme.gold.withValues(alpha: 0.35),
                  blurRadius: 16,
                  offset: const Offset(0, 4),
                ),
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 18),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.play_arrow_rounded,
                    color: Color(0xFF1A1410),
                    size: 28,
                  ),
                  SizedBox(width: 8),
                  Text(
                    'OYUNA BAŞLA',
                    style: TextStyle(
                      color: Color(0xFF1A1410),
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 2,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTournamentButton(BuildContext context) {
    return SizedBox(
      width: 280,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            HapticFeedback.lightImpact();
            Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const TournamentScreen()),
            );
          },
          borderRadius: BorderRadius.circular(16),
          child: Ink(
            decoration: BoxDecoration(
              color: AppTheme.surfaceMid,
              border: Border.all(color: AppTheme.goldBright.withValues(alpha: 0.6), width: 2),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.emoji_events,
                    color: AppTheme.goldBright,
                    size: 24,
                  ),
                  SizedBox(width: 8),
                  Text(
                    'TURNUVA MODU',
                    style: TextStyle(
                      color: AppTheme.goldBright,
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.5,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMultiplayerButton(BuildContext context) {
    return SizedBox(
      width: 280,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            HapticFeedback.lightImpact();
            Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const MultiplayerSetupScreen()),
            );
          },
          borderRadius: BorderRadius.circular(16),
          child: Ink(
            decoration: BoxDecoration(
              color: AppTheme.surfaceMid,
              border: Border.all(color: AppTheme.gold.withValues(alpha: 0.3)),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.bluetooth,
                    color: AppTheme.goldBright,
                    size: 24,
                  ),
                  SizedBox(width: 8),
                  Text(
                    'BLUETOOTH İLE OYNA',
                    style: TextStyle(
                      color: AppTheme.textSecondary,
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.5,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTutorialButton(BuildContext context) {
    return SizedBox(
      width: 280,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            HapticFeedback.lightImpact();
            setState(() {
              _showTutorial = true;
            });
          },
          borderRadius: BorderRadius.circular(16),
          child: Ink(
            decoration: BoxDecoration(
              color: AppTheme.surfaceDark.withValues(alpha: 0.8),
              border: Border.all(color: AppTheme.goldDark.withValues(alpha: 0.5)),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 14),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.help_outline,
                    color: AppTheme.goldBright,
                    size: 24,
                  ),
                  SizedBox(width: 8),
                  Text(
                    'NASIL OYNANIR?',
                    style: TextStyle(
                      color: AppTheme.textPrimary,
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.5,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRecordsButton(BuildContext context) {
    return SizedBox(
      width: 280,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            HapticFeedback.lightImpact();
            Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const RecordsScreen()),
            );
          },
          borderRadius: BorderRadius.circular(16),
          child: Ink(
            decoration: BoxDecoration(
              color: AppTheme.surfaceDark.withValues(alpha: 0.8),
              border: Border.all(color: AppTheme.goldDark.withValues(alpha: 0.5)),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 14),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.emoji_events,
                    color: AppTheme.goldBright,
                    size: 24,
                  ),
                  SizedBox(width: 8),
                  Text(
                    'REKORLAR',
                    style: TextStyle(
                      color: AppTheme.textPrimary,
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.5,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
