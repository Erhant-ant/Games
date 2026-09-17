import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/services/network_service.dart';
import '../../../home/presentation/pages/home_screen.dart';

class SplashScreen extends StatefulWidget {
  SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool _isLoading = true;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _checkInternet();
  }

  Future<void> _checkInternet() async {
    setState(() {
      _isLoading = true;
      _hasError = false;
    });

    // Small delay for the splash animation to show
    await Future.delayed(Duration(seconds: 1));

    bool hasInternet = await NetworkService.hasInternetConnection();

    if (!mounted) return;

    if (hasInternet) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );
    } else {
      setState(() {
        _isLoading = false;
        _hasError = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo / Icon
            Container(
              padding: EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(color: AppColors.primaryShadow, offset: Offset(0, 6)),
                ],
                border: Border.all(color: Colors.white, width: 4),
              ),
              child: Icon(Icons.change_history_rounded, size: 80, color: Colors.white),
            ).animate().scale(curve: Curves.elasticOut, duration: 1200.ms),
            
            SizedBox(height: 32),
            
            Text(
              'PASAPOLA PRO',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.w900,
                color: AppColors.primary,
                letterSpacing: 2,
              ),
            ).animate().fadeIn(delay: 500.ms),
            
            SizedBox(height: 48),

            if (_isLoading)
              CircularProgressIndicator(color: AppColors.primary).animate().fadeIn(delay: 800.ms)
            else if (_hasError)
              Column(
                children: [
                  Icon(Icons.wifi_off_rounded, size: 48, color: AppColors.danger),
                  SizedBox(height: 16),
                  Text(
                    'Bağlantı Hatası',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textMain,
                    ),
                  ),
                  SizedBox(height: 8),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 40),
                    child: Text(
                      'Oyuna giriş yapabilmek için internet bağlantısı gereklidir. Lütfen bağlantınızı kontrol edip tekrar deneyin.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.textLight,
                      ),
                    ),
                  ),
                  SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: _checkInternet,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: Text(
                      'Tekrar Dene',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ).animate().fadeIn(),
          ],
        ),
      ),
    );
  }
}
