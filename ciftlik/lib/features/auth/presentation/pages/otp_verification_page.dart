import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

class OtpVerificationPage extends StatefulWidget {
  const OtpVerificationPage({
    super.key,
    required this.phone,
    required this.onLanguageChanged,
  });

  final String phone;
  final ValueChanged<String> onLanguageChanged;

  @override
  State<OtpVerificationPage> createState() => _OtpVerificationPageState();
}

class _OtpVerificationPageState extends State<OtpVerificationPage> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _codeController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  void _verify() {
    if (_formKey.currentState!.validate()) {
      final code = _codeController.text.trim();
      final success = AuthState.instance.verifyOtp(code);
      if (success) {
        Navigator.of(context).pushReplacementNamed('/account');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              AppLocalizations.of(context).isTurkish ? 'Hatalı kod girdiniz. Lütfen tekrar deneyin.' : 'Invalid code. Please try again.',
            ),
            backgroundColor: AppColors.terracotta,
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    _codeController.dispose();
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
                          strings.isTurkish ? 'Doğrulama Kodu' : 'Verification Code',
                          style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          strings.isTurkish
                              ? '+90 ${widget.phone} numarasına gönderilen 4 haneli kodu giriniz.\n(Test için herhangi bir 4 rakam girebilirsiniz)'
                              : 'Enter the 4-digit code sent to +90 ${widget.phone}.\n(For testing, enter any 4 digits)',
                          style: const TextStyle(color: Colors.black54),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 40),
                        TextFormField(
                          controller: _codeController,
                          decoration: InputDecoration(
                            labelText: strings.isTurkish ? 'SMS Kodu' : 'SMS Code',
                            hintText: '----',
                            border: const OutlineInputBorder(),
                            prefixIcon: const Icon(Icons.sms_outlined),
                          ),
                          keyboardType: TextInputType.number,
                          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                          maxLength: 4,
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontSize: 24, letterSpacing: 8, fontWeight: FontWeight.bold),
                          validator: (value) => value == null || value.length != 4
                              ? (strings.isTurkish ? '4 haneli kodu girmelisiniz' : 'Must be 4 digits')
                              : null,
                        ),
                        const SizedBox(height: 32),
                        ElevatedButton(
                          onPressed: _verify,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.forest,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          child: Text(strings.isTurkish ? 'Doğrula ve Giriş Yap' : 'Verify & Log In'),
                        ),
                        const SizedBox(height: 24),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            TextButton(
                              onPressed: () {
                                // Simulate resend
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(strings.isTurkish ? 'Yeni kod gönderildi.' : 'New code sent.'),
                                    backgroundColor: AppColors.forest,
                                  ),
                                );
                              },
                              child: Text(
                                strings.isTurkish ? 'Kodu Tekrar Gönder' : 'Resend Code',
                                style: const TextStyle(color: AppColors.ink, fontWeight: FontWeight.bold),
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
