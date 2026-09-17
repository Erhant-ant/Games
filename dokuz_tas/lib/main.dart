import 'package:flutter/material.dart';
import 'theme/app_theme.dart';
import 'theme/theme_controller.dart';
import 'screens/splash_screen.dart';
import 'services/audio_service.dart';
import 'services/stats_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AudioService().init();
  await ThemeController().init();
  await StatsService().init();
  runApp(const DokuzTasApp());
}

class DokuzTasApp extends StatelessWidget {
  const DokuzTasApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dokuz Taş',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      home: const SplashScreen(),
    );
  }
}
