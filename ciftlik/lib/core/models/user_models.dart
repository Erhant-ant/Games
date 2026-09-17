class UserModel {
  const UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    this.addresses = const [],
  });

  final String id;
  final String name;
  final String email;
  final String phone;
  final List<AddressModel> addresses;

  UserModel copyWith({
    String? name,
    String? email,
    String? phone,
    List<AddressModel>? addresses,
  }) {
    return UserModel(
      id: id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      addresses: addresses ?? this.addresses,
    );
  }
}

class AddressModel {
  const AddressModel({
    required this.id,
    required this.title,
    required this.address,
    required this.city,
  });

  final String id;
  final String title;
  final String address;
  final String city;

  AddressModel copyWith({
    String? title,
    String? address,
    String? city,
  }) {
    return AddressModel(
      id: id,
      title: title ?? this.title,
      address: address ?? this.address,
      city: city ?? this.city,
    );
  }
}

class OrderModel {
  const OrderModel({
    required this.id,
    required this.date,
    required this.status,
    required this.totalAmount,
    required this.itemCount,
  });

  final String id;
  final DateTime date;
  final String status;
  final double totalAmount;
  final int itemCount;
}
