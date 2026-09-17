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
import '../../../../core/models/user_models.dart';
import '../../../store/presentation/widgets/mobile_drawer.dart';
import '../../../store/presentation/widgets/brand_refresh_indicator.dart';

class MyAccountPage extends StatefulWidget {
  const MyAccountPage({super.key, required this.onLanguageChanged});

  final ValueChanged<String> onLanguageChanged;

  @override
  State<MyAccountPage> createState() => _MyAccountPageState();
}

class _MyAccountPageState extends State<MyAccountPage> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  int _selectedIndex = 0;

  void _logout() {
    AuthState.instance.logout();
    Navigator.of(context).pushReplacementNamed('/');
  }

  final List<OrderModel> _dummyOrders = [
    OrderModel(id: 'ORD-1024', date: DateTime.now().subtract(const Duration(days: 2)), status: 'Teslim Edildi', totalAmount: 450.00, itemCount: 3),
    OrderModel(id: 'ORD-0982', date: DateTime.now().subtract(const Duration(days: 15)), status: 'Teslim Edildi', totalAmount: 1200.50, itemCount: 8),
  ];

  void _showEditProfileDialog(AppLocalizations strings, UserModel user) {
    final nameController = TextEditingController(text: user.name);
    final emailController = TextEditingController(text: user.email);
    final phoneController = TextEditingController(text: user.phone);
    final formKey = GlobalKey<FormState>();

    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(strings.isTurkish ? 'Profili Düzenle' : 'Edit Profile'),
        content: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: nameController,
                decoration: InputDecoration(labelText: strings.isTurkish ? 'Ad Soyad' : 'Full Name', border: const OutlineInputBorder()),
                validator: (val) => val == null || val.isEmpty ? '*' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: emailController,
                decoration: InputDecoration(labelText: strings.isTurkish ? 'E-posta' : 'Email', border: const OutlineInputBorder()),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: phoneController,
                decoration: InputDecoration(labelText: strings.isTurkish ? 'Telefon' : 'Phone', border: const OutlineInputBorder()),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.of(context).pop(), child: Text(strings.isTurkish ? 'İptal' : 'Cancel', style: const TextStyle(color: Colors.grey))),
          FilledButton(
            onPressed: () {
              if (formKey.currentState!.validate()) {
                AuthState.instance.updateProfile(name: nameController.text, email: emailController.text, phone: phoneController.text);
                Navigator.of(context).pop();
              }
            },
            style: FilledButton.styleFrom(backgroundColor: AppColors.forest),
            child: Text(strings.isTurkish ? 'Kaydet' : 'Save'),
          ),
        ],
      ),
    );
  }

  void _showAddressDialog(AppLocalizations strings, {AddressModel? address}) {
    final isEditing = address != null;
    final titleController = TextEditingController(text: address?.title ?? '');
    final addressController = TextEditingController(text: address?.address ?? '');
    final cityController = TextEditingController(text: address?.city ?? '');
    final formKey = GlobalKey<FormState>();

    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(isEditing ? (strings.isTurkish ? 'Adresi Düzenle' : 'Edit Address') : (strings.isTurkish ? 'Yeni Adres Ekle' : 'Add New Address')),
        content: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: titleController,
                decoration: InputDecoration(labelText: strings.isTurkish ? 'Adres Başlığı (Örn: Ev)' : 'Address Title (e.g., Home)', border: const OutlineInputBorder()),
                validator: (val) => val == null || val.isEmpty ? '*' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: addressController,
                maxLines: 3,
                decoration: InputDecoration(labelText: strings.isTurkish ? 'Açık Adres' : 'Full Address', border: const OutlineInputBorder()),
                validator: (val) => val == null || val.isEmpty ? '*' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: cityController,
                decoration: InputDecoration(labelText: strings.isTurkish ? 'İl/İlçe' : 'City/District', border: const OutlineInputBorder()),
                validator: (val) => val == null || val.isEmpty ? '*' : null,
              ),
            ],
          ),
        ),
        actions: [
          if (isEditing)
            TextButton(
              onPressed: () {
                AuthState.instance.removeAddress(address.id);
                Navigator.of(context).pop();
              },
              child: Text(strings.isTurkish ? 'Sil' : 'Delete', style: const TextStyle(color: AppColors.terracotta)),
            ),
          const Spacer(),
          TextButton(onPressed: () => Navigator.of(context).pop(), child: Text(strings.isTurkish ? 'İptal' : 'Cancel', style: const TextStyle(color: Colors.grey))),
          FilledButton(
            onPressed: () {
              if (formKey.currentState!.validate()) {
                final newAddress = AddressModel(
                  id: isEditing ? address.id : DateTime.now().millisecondsSinceEpoch.toString(),
                  title: titleController.text,
                  address: addressController.text,
                  city: cityController.text,
                );
                if (isEditing) {
                  AuthState.instance.updateAddress(newAddress);
                } else {
                  AuthState.instance.addAddress(newAddress);
                }
                Navigator.of(context).pop();
              }
            },
            style: FilledButton.styleFrom(backgroundColor: AppColors.forest),
            child: Text(strings.isTurkish ? 'Kaydet' : 'Save'),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileTab(AppLocalizations strings) {
    final user = AuthState.instance.user;
    if (user == null) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(strings.isTurkish ? 'Kişisel Bilgiler' : 'Personal Information', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
            TextButton.icon(
              onPressed: () => _showEditProfileDialog(strings, user),
              icon: const Icon(Icons.edit, size: 18),
              label: Text(strings.isTurkish ? 'Düzenle' : 'Edit'),
              style: TextButton.styleFrom(foregroundColor: AppColors.forest),
            ),
          ],
        ),
        const SizedBox(height: 24),
        ListTile(
          contentPadding: EdgeInsets.zero,
          title: Text(strings.isTurkish ? 'Ad Soyad' : 'Full Name', style: const TextStyle(color: Colors.black54, fontSize: 13)),
          subtitle: Text(user.name, style: const TextStyle(color: AppColors.ink, fontSize: 16, fontWeight: FontWeight.w600)),
        ),
        const Divider(),
        ListTile(
          contentPadding: EdgeInsets.zero,
          title: Text(strings.isTurkish ? 'E-posta' : 'Email', style: const TextStyle(color: Colors.black54, fontSize: 13)),
          subtitle: Text(user.email, style: const TextStyle(color: AppColors.ink, fontSize: 16, fontWeight: FontWeight.w600)),
        ),
        const Divider(),
        ListTile(
          contentPadding: EdgeInsets.zero,
          title: Text(strings.isTurkish ? 'Telefon' : 'Phone', style: const TextStyle(color: Colors.black54, fontSize: 13)),
          subtitle: Text(user.phone.isEmpty ? '-' : user.phone, style: const TextStyle(color: AppColors.ink, fontSize: 16, fontWeight: FontWeight.w600)),
        ),
      ],
    );
  }

  Widget _buildOrdersTab(AppLocalizations strings) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(strings.isTurkish ? 'Siparişlerim' : 'My Orders', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
        const SizedBox(height: 24),
        if (_dummyOrders.isEmpty)
          Text(strings.isTurkish ? 'Henüz siparişiniz yok.' : 'No orders yet.')
        else
          ..._dummyOrders.map((order) => Card(
            margin: const EdgeInsets.only(bottom: 16),
            elevation: 0,
            shape: RoundedRectangleBorder(side: const BorderSide(color: Color(0xFFE4DED2)), borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(order.id, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(color: AppColors.sage.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(4)),
                        child: Text(order.status, style: const TextStyle(color: AppColors.forest, fontSize: 12, fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('${order.date.day}/${order.date.month}/${order.date.year}', style: const TextStyle(color: Colors.black54)),
                      Text('₺ ${order.totalAmount.toStringAsFixed(2)}', style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.terracotta, fontSize: 16)),
                    ],
                  ),
                ],
              ),
            ),
          )),
      ],
    );
  }

  Widget _buildAddressesTab(AppLocalizations strings, UserModel user) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(strings.isTurkish ? 'Adreslerim' : 'My Addresses', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
            TextButton.icon(
              onPressed: () => _showAddressDialog(strings),
              icon: const Icon(Icons.add, size: 18),
              label: Text(strings.isTurkish ? 'Yeni Ekle' : 'Add New'),
              style: TextButton.styleFrom(foregroundColor: AppColors.forest),
            ),
          ],
        ),
        const SizedBox(height: 16),
        if (user.addresses.isEmpty)
          Text(strings.isTurkish ? 'Kayıtlı adresiniz bulunmuyor.' : 'No saved addresses.')
        else
          ...user.addresses.map((addr) => Card(
            margin: const EdgeInsets.only(bottom: 16),
            elevation: 0,
            shape: RoundedRectangleBorder(side: const BorderSide(color: Color(0xFFE4DED2)), borderRadius: BorderRadius.circular(12)),
            child: ListTile(
              contentPadding: const EdgeInsets.all(16),
              title: Text(addr.title, style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text('${addr.address}\n${addr.city}', style: const TextStyle(height: 1.5)),
              ),
              trailing: IconButton(
                icon: const Icon(Icons.edit_outlined, color: AppColors.forest),
                onPressed: () => _showAddressDialog(strings, address: addr),
              ),
            ),
          )),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.sizeOf(context).width >= 900;
    final strings = AppLocalizations.of(context);

    return ValueListenableBuilder(
      valueListenable: AuthState.instance,
      builder: (context, user, _) {
        if (user == null) {
          WidgetsBinding.instance.addPostFrameCallback((_) => Navigator.of(context).pushReplacementNamed('/login'));
          return const SizedBox.shrink();
        }

        final tabs = [
          strings.isTurkish ? 'Profilim' : 'My Profile',
          strings.isTurkish ? 'Siparişlerim' : 'My Orders',
          strings.isTurkish ? 'Adreslerim' : 'My Addresses',
        ];

        Widget content;
        switch (_selectedIndex) {
          case 0: content = _buildProfileTab(strings); break;
          case 1: content = _buildOrdersTab(strings); break;
          case 2: content = _buildAddressesTab(strings, user); break;
          default: content = const SizedBox.shrink();
        }

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
      body: BrandRefreshIndicator(
          onRefresh: () async {
            await Future<void>.delayed(const Duration(milliseconds: 1500));
            if (mounted) setState(() {});
          },
          child: CustomScrollView(
        slivers: [
          ...buildStoreHeaderSlivers(
            isDesktop: isDesktop,
            onLanguageChanged: widget.onLanguageChanged,
            onCartTap: () => _scaffoldKey.currentState?.openEndDrawer(),
            strings: strings,
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: isDesktop ? 60 : 20, vertical: 40),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (isDesktop)
                    Container(
                      width: 250,
                      margin: const EdgeInsets.only(right: 40),
                      padding: const EdgeInsets.symmetric(vertical: 24),
                      decoration: BoxDecoration(
                        color: AppColors.cream,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          ...List.generate(tabs.length, (index) {
                            final isSelected = _selectedIndex == index;
                            return InkWell(
                              onTap: () => setState(() => _selectedIndex = index),
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                                decoration: BoxDecoration(
                                  color: isSelected ? AppColors.sage.withValues(alpha: 0.3) : Colors.transparent,
                                  border: isSelected ? const Border(left: BorderSide(color: AppColors.forest, width: 4)) : const Border(left: BorderSide(color: Colors.transparent, width: 4)),
                                ),
                                child: Text(tabs[index], style: TextStyle(fontWeight: isSelected ? FontWeight.bold : FontWeight.normal, color: AppColors.ink)),
                              ),
                            );
                          }),
                          const Divider(height: 32),
                          InkWell(
                            onTap: _logout,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                              child: Row(
                                children: [
                                  const Icon(Icons.logout, size: 20, color: AppColors.terracotta),
                                  const SizedBox(width: 12),
                                  Text(strings.isTurkish ? 'Çıkış Yap' : 'Log Out', style: const TextStyle(color: AppColors.terracotta, fontWeight: FontWeight.bold)),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        if (!isDesktop) ...[
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: List.generate(tabs.length, (index) {
                                final isSelected = _selectedIndex == index;
                                return Padding(
                                  padding: const EdgeInsets.only(right: 8),
                                  child: ChoiceChip(
                                    label: Text(tabs[index]),
                                    selected: isSelected,
                                    selectedColor: AppColors.sage,
                                    onSelected: (val) {
                                      if (val) setState(() => _selectedIndex = index);
                                    },
                                  ),
                                );
                              }),
                            ),
                          ),
                          const SizedBox(height: 24),
                        ],
                        content,
                        if (!isDesktop) ...[
                          const SizedBox(height: 48),
                          TextButton.icon(
                            onPressed: _logout,
                            icon: const Icon(Icons.logout, color: AppColors.terracotta),
                            label: Text(strings.isTurkish ? 'Çıkış Yap' : 'Log Out', style: const TextStyle(color: AppColors.terracotta)),
                          )
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SliverToBoxAdapter(child: AppFooter()),
        ],
      ),
        ),
    );
      }
    );
  }
}
