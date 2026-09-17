import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import '../core/localization/app_localizations.dart';
import '../features/store/data/store_data.dart';
import '../features/store/presentation/pages/product_detail_page.dart';
import '../features/store/presentation/pages/search_page.dart';
import '../features/store/presentation/pages/category_page.dart';
import '../features/store/presentation/pages/favorites_page.dart';
import '../features/store/presentation/pages/store_home_page.dart';
import '../features/auth/presentation/pages/login_page.dart';
import '../features/auth/presentation/pages/otp_verification_page.dart';
import '../features/auth/presentation/pages/register_page.dart';
import '../features/account/presentation/pages/my_account_page.dart';
import '../features/store/presentation/pages/journal_page.dart';
import '../features/store/presentation/pages/contact_page.dart';
import 'theme/app_theme.dart';

class ZahideHanimApp extends StatefulWidget {
  const ZahideHanimApp({super.key});

  @override
  State<ZahideHanimApp> createState() => _ZahideHanimAppState();
}

class _ZahideHanimAppState extends State<ZahideHanimApp> {
  Locale _locale = const Locale('tr');

  void _changeLanguage(String languageCode) {
    setState(() => _locale = Locale(languageCode));
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Zahide Hanım Çiftliği',
      theme: AppTheme.light,
      locale: _locale,
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      onGenerateRoute: (settings) {
        if (settings.name == null) return null;
        final uri = Uri.parse(settings.name!);

        if (uri.pathSegments.length == 2 && uri.pathSegments.first == 'product') {
          final productId = uri.pathSegments[1];
          final allProducts = StoreData.products(_locale.languageCode == 'tr');
          final product = allProducts.firstWhere(
            (p) => p.id == productId,
            orElse: () => allProducts.first, // Fallback
          );
          return MaterialPageRoute<void>(
            builder: (_) => AppLocalizations(
              locale: _locale,
              child: ProductDetailPage(
                product: product,
                onLanguageChanged: _changeLanguage,
              ),
            ),
          );
        }

        if (uri.pathSegments.isNotEmpty && uri.pathSegments.first == 'search') {
          final query = uri.queryParameters['q'] ?? '';
          return MaterialPageRoute<void>(
            builder: (_) => AppLocalizations(
              locale: _locale,
              child: SearchPage(
                query: query,
                onLanguageChanged: _changeLanguage,
              ),
            ),
          );
        }

        if (uri.pathSegments.length == 2 && uri.pathSegments.first == 'category') {
          final categoryId = uri.pathSegments[1];
          return MaterialPageRoute<void>(
            builder: (_) => AppLocalizations(
              locale: _locale,
              child: CategoryPage(
                categoryId: categoryId,
                onLanguageChanged: _changeLanguage,
              ),
            ),
          );
        }

        if (uri.pathSegments.isNotEmpty && uri.pathSegments.first == 'favorites') {
          return MaterialPageRoute<void>(
            builder: (_) => AppLocalizations(
              locale: _locale,
              child: FavoritesPage(
                onLanguageChanged: _changeLanguage,
              ),
            ),
          );
        }

        if (uri.pathSegments.isNotEmpty && uri.pathSegments.first == 'login') {
          return MaterialPageRoute<void>(
            builder: (_) => AppLocalizations(
              locale: _locale,
              child: LoginPage(
                onLanguageChanged: _changeLanguage,
              ),
            ),
          );
        }

        if (uri.pathSegments.isNotEmpty && uri.pathSegments.first == 'verify-phone') {
          final phone = settings.arguments as String? ?? '';
          return MaterialPageRoute<void>(
            builder: (_) => AppLocalizations(
              locale: _locale,
              child: OtpVerificationPage(
                phone: phone,
                onLanguageChanged: _changeLanguage,
              ),
            ),
          );
        }

        if (uri.pathSegments.isNotEmpty && uri.pathSegments.first == 'register') {
          return MaterialPageRoute<void>(
            builder: (_) => AppLocalizations(
              locale: _locale,
              child: RegisterPage(
                onLanguageChanged: _changeLanguage,
              ),
            ),
          );
        }

        if (uri.pathSegments.isNotEmpty && uri.pathSegments.first == 'account') {
          return MaterialPageRoute<void>(
            builder: (_) => AppLocalizations(
              locale: _locale,
              child: MyAccountPage(
                onLanguageChanged: _changeLanguage,
              ),
            ),
          );
        }

        if (uri.pathSegments.isNotEmpty && uri.pathSegments.first == 'journal') {
          return MaterialPageRoute<void>(
            builder: (_) => AppLocalizations(
              locale: _locale,
              child: JournalPage(
                onLanguageChanged: _changeLanguage,
              ),
            ),
          );
        }

        if (uri.pathSegments.isNotEmpty && uri.pathSegments.first == 'contact') {
          return MaterialPageRoute<void>(
            builder: (_) => AppLocalizations(
              locale: _locale,
              child: ContactPage(
                onLanguageChanged: _changeLanguage,
              ),
            ),
          );
        }

        return MaterialPageRoute<void>(
          builder: (_) => AppLocalizations(
            locale: _locale,
            child: StoreHomePage(onLanguageChanged: _changeLanguage),
          ),
        );
      },
    );
  }
}
