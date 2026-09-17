import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../../core/models/cart_item.dart';
import '../../../../core/state/auth_state.dart';
import '../../../../core/state/cart_state.dart';
import '../../../store/presentation/widgets/brand_refresh_indicator.dart';

class CheckoutPage extends StatefulWidget {
  const CheckoutPage({super.key, required this.items});

  final List<CartItem> items;

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  final _formKey = GlobalKey<FormState>();
  String _paymentMethod = 'card';

  late final TextEditingController _nameController;
  late final TextEditingController _phoneController;

  @override
  void initState() {
    super.initState();
    final user = AuthState.instance.user;
    _nameController = TextEditingController(text: user?.name ?? '');
    _phoneController = TextEditingController(text: user?.phone ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  int get _subtotal => widget.items.fold(0, (sum, item) => sum + _price(item.product.price) * item.quantity);

  int _price(String value) => int.parse(value.replaceAll(RegExp(r'[^0-9]'), ''));

  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context);
    final isDesktop = MediaQuery.sizeOf(context).width >= 900;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.cream,
        surfaceTintColor: Colors.transparent,
        title: Text(strings.text('checkoutTitle'), style: const TextStyle(color: AppColors.forest, fontWeight: FontWeight.bold)),
      ),
      body: BrandRefreshIndicator(
          onRefresh: () async {
            await Future<void>.delayed(const Duration(milliseconds: 1500));
            if (mounted) setState(() {});
          },
          child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1120),
              child: Flex(
                direction: isDesktop ? Axis.horizontal : Axis.vertical,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  isDesktop
                      ? Expanded(
                          flex: 6,
                          child: _CheckoutForm(
                            formKey: _formKey,
                            paymentMethod: _paymentMethod,
                            nameController: _nameController,
                            phoneController: _phoneController,
                            onPaymentChanged: (value) => setState(() => _paymentMethod = value),
                          ),
                        )
                      : _CheckoutForm(
                      formKey: _formKey,
                      paymentMethod: _paymentMethod,
                      nameController: _nameController,
                      phoneController: _phoneController,
                      onPaymentChanged: (value) => setState(() => _paymentMethod = value),
                    ),
                  SizedBox(width: isDesktop ? 40 : 0, height: isDesktop ? 0 : 28),
                  isDesktop
                      ? Expanded(
                          flex: 4,
                          child: _OrderSummary(
                            items: widget.items,
                            subtotal: _subtotal,
                            onSubmit: () => _submit(context, strings),
                          ),
                        )
                      : _OrderSummary(
                      items: widget.items,
                      subtotal: _subtotal,
                      onSubmit: () => _submit(context, strings),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
        ),
    );
  }

  void _submit(BuildContext context, AppLocalizations strings) {
    if (!_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(strings.text('formRequired'))));
      return;
    }

    showDialog<void>(
      context: context,
      builder: (_) => AlertDialog(
        icon: const Icon(Icons.check_circle_outline_rounded, color: AppColors.olive, size: 48),
        title: Text(strings.text('orderReceived'), textAlign: TextAlign.center),
        content: Text(strings.text('orderReceivedBody'), textAlign: TextAlign.center),
        actions: [
          Center(
            child: FilledButton(
              onPressed: () {
                CartState.instance.clear();
                Navigator.of(context).popUntil((route) => route.isFirst);
              },
              child: const Text('Tamam'),
            ),
          ),
        ],
      ),
    );
  }
}

class _CheckoutForm extends StatelessWidget {
  const _CheckoutForm({
    required this.formKey,
    required this.paymentMethod,
    required this.onPaymentChanged,
    required this.nameController,
    required this.phoneController,
  });

  final GlobalKey<FormState> formKey;
  final String paymentMethod;
  final ValueChanged<String> onPaymentChanged;
  final TextEditingController nameController;
  final TextEditingController phoneController;

  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context);
    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(strings.text('checkoutSubtitle'), style: const TextStyle(color: Colors.black54)),
          const SizedBox(height: 28),
          _CheckoutBlock(
            title: strings.text('contactInfo'),
            child: Column(children: [_field(strings.text('fullName'), controller: nameController), const SizedBox(height: 13), _field(strings.text('phone'), keyboardType: TextInputType.phone, controller: phoneController)]),
          ),
          const SizedBox(height: 22),
          _CheckoutBlock(
            title: strings.text('deliveryAddress'),
            child: Column(
              children: [
                _field(strings.text('address'), maxLines: 3),
                const SizedBox(height: 13),
                Row(children: [Expanded(child: _field(strings.text('city'))), const SizedBox(width: 13), Expanded(child: _field(strings.text('district')))]),
              ],
            ),
          ),
          const SizedBox(height: 22),
          _CheckoutBlock(
            title: strings.text('paymentMethod'),
            child: Column(
              children: [
                _PaymentTile(value: 'card', groupValue: paymentMethod, title: strings.text('cardPayment'), icon: Icons.credit_card_outlined, onChanged: onPaymentChanged),
                _PaymentTile(value: 'cash', groupValue: paymentMethod, title: strings.text('cashOnDelivery'), icon: Icons.payments_outlined, onChanged: onPaymentChanged),
                _PaymentTile(value: 'transfer', groupValue: paymentMethod, title: strings.text('bankTransfer'), icon: Icons.account_balance_outlined, onChanged: onPaymentChanged),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _field(String label, {int maxLines = 1, TextInputType? keyboardType, TextEditingController? controller}) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: keyboardType,
      validator: (value) => value == null || value.trim().isEmpty ? '' : null,
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Color(0xFFE3DAC8))),
      ),
    );
  }
}

class _CheckoutBlock extends StatelessWidget {
  const _CheckoutBlock({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: const Color(0xFFE8E2D3))),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(title, style: const TextStyle(color: AppColors.forest, fontSize: 19, fontWeight: FontWeight.bold)), const SizedBox(height: 17), child]),
    );
  }
}

class _PaymentTile extends StatelessWidget {
  const _PaymentTile({required this.value, required this.groupValue, required this.title, required this.icon, required this.onChanged});

  final String value;
  final String groupValue;
  final String title;
  final IconData icon;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return RadioListTile<String>(
      value: value,
      groupValue: groupValue,
      onChanged: (value) {
        if (value != null) onChanged(value);
      },
      contentPadding: EdgeInsets.zero,
      title: Text(title),
      secondary: Icon(icon, color: AppColors.olive),
    );
  }
}

class _OrderSummary extends StatelessWidget {
  const _OrderSummary({required this.items, required this.subtotal, required this.onSubmit});

  final List<CartItem> items;
  final int subtotal;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(color: AppColors.sand, borderRadius: BorderRadius.circular(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(strings.text('orderSummary'), style: const TextStyle(color: AppColors.forest, fontSize: 21, fontWeight: FontWeight.bold)),
          const SizedBox(height: 18),
          ...items.map((item) => Padding(padding: const EdgeInsets.only(bottom: 12), child: Row(children: [Expanded(child: Text('${item.quantity} × ${item.product.name}')), Text(item.product.price, style: const TextStyle(fontWeight: FontWeight.bold))]))),
          const Divider(height: 27),
          Row(children: [Text(strings.text('subtotal'), style: const TextStyle(fontWeight: FontWeight.bold)), const Spacer(), Text('₺ $subtotal', style: const TextStyle(color: AppColors.forest, fontSize: 20, fontWeight: FontWeight.bold))]),
          const SizedBox(height: 8),
          Text(strings.text('shippingAtCheckout'), style: const TextStyle(color: Colors.black54, fontSize: 12)),
          const SizedBox(height: 20),
          SizedBox(width: double.infinity, child: FilledButton(onPressed: onSubmit, style: FilledButton.styleFrom(backgroundColor: AppColors.forest, padding: const EdgeInsets.symmetric(vertical: 16)), child: Text(strings.text('placeOrder')))),
          const SizedBox(height: 11),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [const Icon(Icons.lock_outline, size: 14, color: AppColors.olive), const SizedBox(width: 5), Flexible(child: Text(strings.text('securePayment'), style: const TextStyle(color: Colors.black54, fontSize: 11), textAlign: TextAlign.center))]),
        ],
      ),
    );
  }
}
