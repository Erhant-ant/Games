import 'package:flutter/material.dart';
import '../services/stats_service.dart';
import '../theme/app_theme.dart';

class ProfileDialog extends StatefulWidget {
  const ProfileDialog({Key? key}) : super(key: key);

  @override
  State<ProfileDialog> createState() => _ProfileDialogState();
}

class _ProfileDialogState extends State<ProfileDialog> {
  late TextEditingController _nameController;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: StatsService().username);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _saveName() async {
    final newName = _nameController.text.trim();
    if (newName.isNotEmpty) {
      await StatsService().setUsername(newName);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Kullanıcı adı kaydedildi!'), duration: Duration(seconds: 2)),
        );
      }
    }
  }

  Widget _buildSocialButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          color: AppTheme.surfaceMid,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withValues(alpha: 0.5), width: 1),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(width: 12),
            Text(
              label,
              style: const TextStyle(
                color: AppTheme.textPrimary,
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showNotImplemented(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        width: 360,
        height: 600,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: AppTheme.surfaceDark,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: AppTheme.goldDark, width: 2),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'PROFİL AYARLARI',
                style: TextStyle(
                  color: AppTheme.goldBright,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2,
                ),
              ),
              const SizedBox(height: 24),
              
              // Username Field
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Kullanıcı Adı',
                  style: TextStyle(color: AppTheme.textSecondary, fontSize: 14),
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _nameController,
                      style: const TextStyle(color: AppTheme.textPrimary),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: AppTheme.surfaceMid,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: AppTheme.goldBright, width: 1),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    onPressed: () {
                      FocusScope.of(context).unfocus();
                      _saveName();
                    },
                    icon: const Icon(Icons.check_circle, color: AppTheme.goldBright, size: 28),
                    tooltip: 'Kaydet',
                  ),
                ],
              ),
              
              const SizedBox(height: 24),
              const Divider(color: AppTheme.boardFrameDark),
              const SizedBox(height: 16),
              
              // Email / Password Section
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'E-Posta ile Giriş / Kayıt',
                  style: TextStyle(color: AppTheme.textSecondary, fontSize: 14),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _emailController,
                style: const TextStyle(color: AppTheme.textPrimary),
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  hintText: 'E-Posta Adresi',
                  hintStyle: const TextStyle(color: AppTheme.textMuted),
                  filled: true,
                  fillColor: AppTheme.surfaceMid,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _passwordController,
                obscureText: true,
                style: const TextStyle(color: AppTheme.textPrimary),
                decoration: InputDecoration(
                  hintText: 'Şifre',
                  hintStyle: const TextStyle(color: AppTheme.textMuted),
                  filled: true,
                  fillColor: AppTheme.surfaceMid,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.goldBright,
                        foregroundColor: AppTheme.surfaceDark,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      onPressed: () {
                        _showNotImplemented('Giriş işlemi yakında eklenecektir.');
                      },
                      child: const Text('Giriş Yap', style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.surfaceMid,
                        foregroundColor: AppTheme.goldBright,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      onPressed: () {
                        _showNotImplemented('Kayıt işlemi yakında eklenecektir.');
                      },
                      child: const Text('Kayıt Ol', style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 24),
              const Divider(color: AppTheme.boardFrameDark),
              const SizedBox(height: 16),
              
              // Social Logins
              const Text(
                'Veya Şununla Bağlan',
                style: TextStyle(color: AppTheme.textSecondary, fontSize: 14),
              ),
              const SizedBox(height: 16),
              _buildSocialButton(
                icon: Icons.g_mobiledata,
                label: 'Google ile Bağlan',
                color: Colors.redAccent,
                onTap: () => _showNotImplemented('Google entegrasyonu yakında eklenecektir.'),
              ),
              const SizedBox(height: 12),
              _buildSocialButton(
                icon: Icons.apple,
                label: 'Apple ile Bağlan',
                color: Colors.white,
                onTap: () => _showNotImplemented('Apple entegrasyonu yakında eklenecektir.'),
              ),
              const SizedBox(height: 12),
              _buildSocialButton(
                icon: Icons.facebook,
                label: 'Facebook ile Bağlan',
                color: Colors.blueAccent,
                onTap: () => _showNotImplemented('Facebook entegrasyonu yakında eklenecektir.'),
              ),
              
              const SizedBox(height: 32),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.surfaceMid,
                  foregroundColor: AppTheme.textPrimary,
                  minimumSize: const Size(double.infinity, 48),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: () {
                  _saveName();
                  Navigator.of(context).pop();
                },
                child: const Text('KAPAT'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

