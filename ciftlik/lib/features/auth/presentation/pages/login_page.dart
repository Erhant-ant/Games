import 'package:flutter/material.dart';
import '../../../store/presentation/widgets/mobile_drawer.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../../core/state/auth_state.dart';
import '../../../store/presentation/widgets/app_header.dart';
import '../../../store/presentation/widgets/app_footer.dart';
import '../../../store/presentation/widgets/cart_drawer.dart';
import '../../../../core/state/cart_state.dart';
import '../../../checkout/presentation/pages/checkout_page.dart';
import '../../../store/presentation/widgets/mobile_drawer.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key, required this.onLanguageChanged});

  final ValueChanged<String> onLanguageChanged;

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _phoneController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  void _sendCode() {
    if (_formKey.currentState!.validate()) {
      final phone = _phoneController.text.trim();
      AuthState.instance.sendOtp(phone);
      Navigator.of(context).pushNamed('/verify-phone', arguments: phone);
    }
  }

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.sizeOf(context).width >= 900;
    final strings = AppLocalizations.of(context);

    return Scaffold(
      key: _scaffoldKey,
      drawer: isDesktop ? null : MobileDrawer(onLanguageChanged: widget.onLanguageChanged),
      endDrawer: ValueListenableBuilder(
        valueListenable: CartState.instance,
        builder: (context, cartItems, child) => CartDrawer(
          items: cartItems,
          onQuantityChanged: CartState.instance.changeQuantity,
          onRemove: CartState.instance.remove,
          onCheckout: () {
            Navigator.of(context).pop();
            Navigator.of(context).push(MaterialPageRoute<void>(builder: (_) => CheckoutPage(items: List.of(cartItems))));
          },
        ),
      ),
      body: CustomScrollView(
        slivers: [
          ...buildStoreHeaderSlivers(
            isDesktop: isDesktop,
            onLanguageChanged: widget.onLanguageChanged,
            onCartTap: () => _scaffoldKey.currentState?.openEndDrawer(),
            strings: strings,
          ),
          SliverToBoxAdapter(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 450),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 60),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          strings.isTurkish ? 'Giriş Yap' : 'Log In',
                          style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          strings.isTurkish ? 'Devam etmek için cep telefonu numaranızı girin.' : 'Enter your phone number to continue.',
                          style: const TextStyle(color: Colors.black54),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 40),
                        TextFormField(
                          controller: _phoneController,
                          decoration: InputDecoration(
                            labelText: strings.isTurkish ? 'Cep Telefonu' : 'Phone Number',
                            hintText: '5XX XXX XX XX',
                            border: const OutlineInputBorder(),
                            prefixIcon: const Icon(Icons.phone_android_outlined),
                            prefixText: '+90 ',
                          ),
                          keyboardType: TextInputType.phone,
                          validator: (value) => value == null || value.isEmpty ? (strings.isTurkish ? 'Telefon numarası gerekli' : 'Phone number is required') : null,
                        ),
                        const SizedBox(height: 32),
                        ElevatedButton(
                          onPressed: _sendCode,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.forest,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          child: Text(strings.isTurkish ? 'Devam Et' : 'Continue'),
                        ),
                        const SizedBox(height: 24),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(strings.isTurkish ? 'Hesabınız yok mu?' : 'Don\'t have an account?'),
                            TextButton(
                              onPressed: () => Navigator.of(context).pushReplacementNamed('/register'),
                              child: Text(
                                strings.isTurkish ? 'Kayıt Ol' : 'Sign Up',
                                style: const TextStyle(color: AppColors.terracotta, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SliverToBoxAdapter(child: AppFooter()),
        ],
      ),
    );
  }
}
