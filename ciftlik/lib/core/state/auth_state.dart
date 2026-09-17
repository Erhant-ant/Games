import 'package:flutter/foundation.dart';
import '../models/user_models.dart';

class AuthState extends ValueNotifier<UserModel?> {
  AuthState._() : super(null);

  static final AuthState instance = AuthState._();

  bool get isLoggedIn => value != null;
  UserModel? get user => value;

  String? _pendingPhone;
  String? _pendingName;
  String? _pendingEmail;

  void sendOtp(String phone) {
    // Simulate sending OTP SMS for Login
    _pendingPhone = phone;
    _pendingName = null;
    _pendingEmail = null;
  }

  void sendRegistrationOtp(String name, String email, String phone) {
    // Simulate sending OTP SMS for Registration
    _pendingPhone = phone;
    _pendingName = name;
    _pendingEmail = email;
  }

  bool verifyOtp(String code) {
    // Simulate verifying OTP. Let's say any 4 digit code works for demo.
    if (code.length == 4 && _pendingPhone != null) {
      value = UserModel(
        id: 'u1',
        name: _pendingName ?? 'Misafir Kullanıcı',
        email: _pendingEmail ?? 'eklenmedi',
        phone: _pendingPhone!,
        addresses: const [
          AddressModel(id: 'a1', title: 'Ev', address: 'Atatürk Mah. Cumhuriyet Cad. No:1 D:4', city: 'İstanbul'),
          AddressModel(id: 'a2', title: 'İş', address: 'Levent Mah. Çiçek Sok. Plaza 1 Kat:5', city: 'İstanbul'),
        ],
      );
      _pendingPhone = null;
      _pendingName = null;
      _pendingEmail = null;
      return true;
    }
    return false;
  }

  void updateProfile({String? name, String? email, String? phone}) {
    if (value != null) {
      value = value!.copyWith(name: name, email: email, phone: phone);
    }
  }

  void addAddress(AddressModel address) {
    if (value != null) {
      value = value!.copyWith(addresses: [...value!.addresses, address]);
    }
  }

  void updateAddress(AddressModel address) {
    if (value != null) {
      final index = value!.addresses.indexWhere((a) => a.id == address.id);
      if (index != -1) {
        final newAddresses = List<AddressModel>.from(value!.addresses);
        newAddresses[index] = address;
        value = value!.copyWith(addresses: newAddresses);
      }
    }
  }

  void removeAddress(String id) {
    if (value != null) {
      value = value!.copyWith(addresses: value!.addresses.where((a) => a.id != id).toList());
    }
  }

  void logout() {
    value = null;
  }
}
