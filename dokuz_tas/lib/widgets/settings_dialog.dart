import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/game_logic.dart';
import '../models/ai_opponent.dart';
import '../theme/app_theme.dart';
import '../theme/theme_controller.dart';
import '../services/audio_service.dart';

class SettingsDialog extends StatefulWidget {
  final GameMode initialMode;
  final Difficulty initialDifficulty;
  final GameVariant initialVariant;
  final int initialDurationMinutes;
  final bool isStartScreen;

  const SettingsDialog({
    super.key,
    required this.initialMode,
    required this.initialDifficulty,
    required this.initialVariant,
    required this.initialDurationMinutes,
    this.isStartScreen = false,
  });

  @override
  State<SettingsDialog> createState() => _SettingsDialogState();
}

class _SettingsDialogState extends State<SettingsDialog> {
  late GameMode _mode;
  late Difficulty _difficulty;
  late GameVariant _variant;
  late int _duration;
  late BoardTheme _theme;
  late double _sfxVolume;

  @override
  void initState() {
    super.initState();
    _mode = widget.initialMode;
    _difficulty = widget.initialDifficulty;
    _variant = widget.initialVariant;
    _duration = widget.initialDurationMinutes;
    _theme = ThemeController().currentTheme;
    _sfxVolume = AudioService().sfxVolume;
    _checkDailyStatus();
  }

  bool _isDailySolved = false;

  Future<void> _checkDailyStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final now = DateTime.now();
    final dateKey = 'daily_${now.year}${now.month}${now.day}';
    if (mounted) {
      setState(() {
        _isDailySolved = prefs.getBool(dateKey) ?? false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        width: 340,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: AppTheme.surfaceDark,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppTheme.goldDark, width: 2),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.8),
              blurRadius: 20,
              spreadRadius: 2,
            ),
          ],
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
            Center(
              child: Text(
                widget.isStartScreen ? 'OYUN AYARLARI' : 'AYARLAR',
                style: const TextStyle(
                  color: AppTheme.goldBright,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2,
                ),
              ),
            ),
            const SizedBox(height: 24),
            
            Text(
              'OYUN MODU',
              style: TextStyle(
                color: AppTheme.textMuted,
                fontSize: 12,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.5,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: _OptionButton(
                    label: 'İki Kişi',
                    icon: Icons.people,
                    isSelected: _mode == GameMode.pvp,
                    onTap: () => setState(() => _mode = GameMode.pvp),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _OptionButton(
                    label: 'Yapay Zeka',
                    icon: Icons.computer,
                    isSelected: _mode == GameMode.pve,
                    onTap: () => setState(() => _mode = GameMode.pve),
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 24),
            Text(
              'OYUN MODU (VARYANT)',
              style: TextStyle(
                color: AppTheme.textMuted,
                fontSize: 12,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.5,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: _OptionButton(
                    label: 'Klasik',
                    isSelected: _variant == GameVariant.classic,
                    onTap: () => setState(() => _variant = GameVariant.classic),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _OptionButton(
                    label: '6 Taş',
                    isSelected: _variant == GameVariant.shortMill,
                    onTap: () => setState(() => _variant = GameVariant.shortMill),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _OptionButton(
                    label: '3 Taş',
                    isSelected: _variant == GameVariant.flyingOnly,
                    onTap: () => setState(() => _variant = GameVariant.flyingOnly),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            _OptionButton(
              label: _isDailySolved ? 'Bugün Çözüldü' : 'Günün Bulmacası',
              icon: _isDailySolved ? Icons.check_circle : Icons.today,
              isSelected: _variant == GameVariant.dailyChallenge,
              onTap: () {
                if (_isDailySolved) return; // Disable if solved
                setState(() {
                  _variant = GameVariant.dailyChallenge;
                  _mode = GameMode.pve; // Daily challenge is against AI
                });
              },
            ),
            
            const SizedBox(height: 24),
            Text(
              'MAÇ SÜRESİ',
              style: TextStyle(
                color: AppTheme.textMuted,
                fontSize: 12,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.5,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: _OptionButton(
                    label: '1 Dk',
                    isSelected: _duration == 1,
                    onTap: () => setState(() => _duration = 1),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _OptionButton(
                    label: '5 Dk',
                    isSelected: _duration == 5,
                    onTap: () => setState(() => _duration = 5),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _OptionButton(
                    label: '10 Dk',
                    isSelected: _duration == 10,
                    onTap: () => setState(() => _duration = 10),
                  ),
                ),
              ],
            ),
            
            if (_mode == GameMode.pve) ...[
              const SizedBox(height: 24),
              Text(
                'ZORLUK SEVİYESİ',
                style: TextStyle(
                  color: AppTheme.textMuted,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.5,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: _OptionButton(
                      label: 'Kolay',
                      isSelected: _difficulty == Difficulty.easy,
                      onTap: () => setState(() => _difficulty = Difficulty.easy),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _OptionButton(
                      label: 'Orta',
                      isSelected: _difficulty == Difficulty.medium,
                      onTap: () => setState(() => _difficulty = Difficulty.medium),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _OptionButton(
                      label: 'Zor',
                      isSelected: _difficulty == Difficulty.hard,
                      onTap: () => setState(() => _difficulty = Difficulty.hard),
                    ),
                  ),
                ],
              ),
            ],
            
            const SizedBox(height: 24),
            Text(
              'TEMA VE TAŞ SEÇİMİ',
              style: TextStyle(
                color: AppTheme.textMuted,
                fontSize: 12,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.5,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: _OptionButton(
                    label: 'Ahşap',
                    isSelected: _theme == BoardTheme.islamicWood,
                    onTap: () => setState(() => _theme = BoardTheme.islamicWood),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _OptionButton(
                    label: 'Mermer',
                    isSelected: _theme == BoardTheme.antiqueMarble,
                    onTap: () => setState(() => _theme = BoardTheme.antiqueMarble),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _OptionButton(
                    label: 'Neon',
                    isSelected: _theme == BoardTheme.neonCyberpunk,
                    onTap: () => setState(() => _theme = BoardTheme.neonCyberpunk),
                  ),
                ),
              ],
            ),
            

            Text(
              'SES EFEKTLERİ',
              style: TextStyle(
                color: AppTheme.textMuted,
                fontSize: 12,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.5,
              ),
            ),
            Slider(
              value: _sfxVolume,
              activeColor: AppTheme.goldBright,
              inactiveColor: AppTheme.goldDark.withValues(alpha: 0.3),
              onChanged: (val) {
                setState(() => _sfxVolume = val);
                AudioService().setSfxVolume(val);
              },
            ),

            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.goldDark,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () {
                  HapticFeedback.lightImpact();
                  ThemeController().setTheme(_theme);
                  Navigator.of(context).pop({
                    'mode': _mode,
                    'difficulty': _difficulty,
                    'variant': _variant,
                    'duration': _duration,
                  });
                },
                child: Text(
                  widget.isStartScreen ? 'OYUNA BAŞLA' : 'KAYDET VE YENİDEN BAŞLAT',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
}

class _OptionButton extends StatelessWidget {
  final String label;
  final IconData? icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _OptionButton({
    required this.label,
    this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        HapticFeedback.lightImpact();
        onTap();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.goldDark.withValues(alpha: 0.3) : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? AppTheme.goldBright : AppTheme.boardFrameDark,
            width: 2,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null) ...[
              Icon(icon, size: 16, color: isSelected ? AppTheme.goldBright : AppTheme.textSecondary),
              const SizedBox(width: 6),
            ],
            Text(
              label,
              style: TextStyle(
                color: isSelected ? AppTheme.goldBright : AppTheme.textSecondary,
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
