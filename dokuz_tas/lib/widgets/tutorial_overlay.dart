import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class TutorialOverlay extends StatelessWidget {
  final VoidCallback onClose;

  const TutorialOverlay({super.key, required this.onClose});

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: Container(
        color: Colors.black.withValues(alpha: 0.8),
        child: Center(
          child: Container(
            width: 320,
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
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Text(
                    'NASIL OYNANIR?',
                    style: TextStyle(
                      color: AppTheme.goldBright,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                
                _buildInstructionRow(
                  icon: Icons.looks_one,
                  title: 'Yerleştirme Evresi',
                  description: 'Oyuncular sırayla boş noktalara taşlarını yerleştirir.',
                ),
                const SizedBox(height: 16),
                
                _buildInstructionRow(
                  icon: Icons.looks_two,
                  title: 'Hareket Evresi',
                  description: 'Tüm taşlar yerleşince, taşları komşu boş noktalara hareket ettir.',
                ),
                const SizedBox(height: 16),
                
                _buildInstructionRow(
                  icon: Icons.star,
                  title: 'Cızz (Mill) Yapma',
                  description: 'Aynı renkteki 3 taşı yatay veya dikey sıraladığında (cızz), rakibin bir taşını tahtadan kaldırabilirsin.',
                ),
                const SizedBox(height: 16),

                _buildInstructionRow(
                  icon: Icons.looks_3,
                  title: 'Uçma Evresi (3 Taş)',
                  description: 'Sadece 3 taşın kalırsa, taşını tahtadaki herhangi bir boş noktaya hareket ettirebilirsin (Uçma).',
                ),
                const SizedBox(height: 16),
                
                _buildInstructionRow(
                  icon: Icons.warning,
                  title: 'Kazanma Koşulu',
                  description: 'Rakibin 2 taşı kaldığında oyunu kazanırsın.',
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
                    onPressed: onClose,
                    child: const Text(
                      'ANLADIM, OYUNA DÖN',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInstructionRow({required IconData icon, required String title, required String description}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: AppTheme.goldBright, size: 24),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: AppTheme.textPrimary,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                description,
                style: const TextStyle(
                  color: AppTheme.textSecondary,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
