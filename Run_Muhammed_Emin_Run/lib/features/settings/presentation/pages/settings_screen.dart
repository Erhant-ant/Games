import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/services/shared_prefs_service.dart';

class SettingsScreen extends StatefulWidget {
  SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late bool _soundEnabled;
  late bool _musicEnabled;
  late bool _vibrationEnabled;
  late bool _notificationsEnabled;

  @override
  void initState() {
    super.initState();
    _soundEnabled = SharedPrefsService.isSoundEnabled;
    _musicEnabled = SharedPrefsService.isMusicEnabled;
    _vibrationEnabled = SharedPrefsService.isVibrationEnabled;
    _notificationsEnabled = SharedPrefsService.areNotificationsEnabled;
  }

  @override
  Widget build(BuildContext context) {
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
          'AYARLAR',
          style: TextStyle(
            color: AppColors.textMain,
            fontWeight: FontWeight.w900,
            letterSpacing: 2,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'SES VE MÜZİK',
              style: TextStyle(
                color: AppColors.textLight,
                fontWeight: FontWeight.w900,
                letterSpacing: 1.5,
              ),
            ).animate().fadeIn(delay: 100.ms).slideY(begin: 0.2, end: 0),
            SizedBox(height: 16),
            _buildSettingsCard([
              _buildSwitchItem(
                title: 'Ses Efektleri',
                subtitle: 'Oyun içi uyarı ve efekt sesleri',
                icon: Icons.volume_up_rounded,
                value: _soundEnabled,
                onChanged: (val) {
                  setState(() => _soundEnabled = val);
                  SharedPrefsService.setSoundEnabled(val);
                },
              ),
              Divider(height: 1, indent: 64),
              _buildSwitchItem(
                title: 'Arka Plan Müziği',
                subtitle: 'Oyunda çalan tema müziği',
                icon: Icons.music_note_rounded,
                value: _musicEnabled,
                onChanged: (val) {
                  setState(() => _musicEnabled = val);
                  SharedPrefsService.setMusicEnabled(val);
                },
              ),
            ]).animate().fadeIn(delay: 200.ms).slideY(begin: 0.2, end: 0),
            
            SizedBox(height: 32),
            
            Text(
              'DİĞER TERCİHLER',
              style: TextStyle(
                color: AppColors.textLight,
                fontWeight: FontWeight.w900,
                letterSpacing: 1.5,
              ),
            ).animate().fadeIn(delay: 300.ms).slideY(begin: 0.2, end: 0),
            SizedBox(height: 16),
            _buildSettingsCard([
              _buildSwitchItem(
                title: 'Titreşim',
                subtitle: 'Geri bildirim titreşimleri',
                icon: Icons.vibration_rounded,
                value: _vibrationEnabled,
                onChanged: (val) {
                  setState(() => _vibrationEnabled = val);
                  SharedPrefsService.setVibrationEnabled(val);
                },
              ),
              Divider(height: 1, indent: 64),
              _buildSwitchItem(
                title: 'Bildirimler',
                subtitle: 'Günlük hediye ve hatırlatıcılar',
                icon: Icons.notifications_active_rounded,
                value: _notificationsEnabled,
                onChanged: (val) {
                  setState(() => _notificationsEnabled = val);
                  SharedPrefsService.setNotificationsEnabled(val);
                },
              ),
            ]).animate().fadeIn(delay: 400.ms).slideY(begin: 0.2, end: 0),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsCard(List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Color(0xFFE5E5E5), width: 2),
        boxShadow: [
          BoxShadow(color: Color(0xFFE5E5E5), offset: Offset(0, 4)),
        ],
      ),
      child: Column(
        children: children,
      ),
    );
  }

  Widget _buildSwitchItem({
    required String title,
    required String subtitle,
    required IconData icon,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: AppColors.primary, size: 24),
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
                    fontWeight: FontWeight.bold,
                    color: AppColors.textMain,
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
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: AppColors.primary,
            activeTrackColor: AppColors.primary.withValues(alpha: 0.3),
          ),
        ],
      ),
    );
  }
}
