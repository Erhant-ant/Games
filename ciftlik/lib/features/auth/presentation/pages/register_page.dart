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

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key, required this.onLanguageChanged});

  final ValueChanged<String> onLanguageChanged;

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  void _sendCode() {
    if (_formKey.currentState!.validate()) {
      final phone = _phoneController.text.trim();
      final name = _nameController.text.trim();
      final email = _emailController.text.trim();
      
      AuthState.instance.sendRegistrationOtp(name, email, phone);
      Navigator.of(context).pushNamed('/verify-phone', arguments: phone);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
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
                          strings.isTurkish ? 'Kayıt Ol' : 'Sign Up',
                          style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          strings.isTurkish ? 'Bilgilerinizi girerek yeni hesap oluşturun.' : 'Enter your details to create an account.',
                          style: const TextStyle(color: Colors.black54),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 40),
                        TextFormField(
                          controller: _nameController,
                          decoration: InputDecoration(
                            labelText: strings.isTurkish ? 'Ad Soyad' : 'Full Name',
                            border: const OutlineInputBorder(),
                            prefixIcon: const Icon(Icons.person_outline),
                          ),
                          validator: (value) => value == null || value.isEmpty ? (strings.isTurkish ? 'İsim gerekli' : 'Name is required') : null,
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _emailController,
                          decoration: InputDecoration(
                            labelText: strings.isTurkish ? 'E-posta Adresi' : 'Email Address',
                            border: const OutlineInputBorder(),
                            prefixIcon: const Icon(Icons.email_outlined),
                          ),
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) => value == null || value.isEmpty ? (strings.isTurkish ? 'E-posta gerekli' : 'Email is required') : null,
                        ),
                        const SizedBox(height: 16),
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
                          child: Text(strings.isTurkish ? 'Doğrulama Kodu Gönder' : 'Send Verification Code'),
                        ),
                        const SizedBox(height: 24),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(strings.isTurkish ? 'Zaten hesabınız var mı?' : 'Already have an account?'),
                            TextButton(
                              onPressed: () => Navigator.of(context).pushReplacementNamed('/login'),
                              child: Text(
                                strings.isTurkish ? 'Giriş Yap' : 'Log In',
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
