class UserAddress {
  const UserAddress({
    this.id = '',
    this.label = '',
    this.recipientName = '',
    this.phone = '',
    this.addressLine1 = '',
    this.addressLine2 = '',
    this.city = '',
    this.province = '',
    this.postalCode = '',
    this.lat,
    this.long,
    this.createdAt = '',
    this.updatedAt = '',
  });

  final String id;
  final String label;
  final String recipientName;
  final String phone;
  final String addressLine1;
  final String addressLine2;
  final String city;
  final String province;
  final String postalCode;
  final double? lat;
  final double? long;
  final String createdAt;
  final String updatedAt;

  String get line1 => addressLine1;

  String get line2 {
    if (addressLine2.isNotEmpty) return addressLine2;
    return [city, province, postalCode].where((e) => e.isNotEmpty).join(', ');
  }

  double? get latitude => lat;
  double? get longitude => long;

  factory UserAddress.fromMap(Map<String, dynamic> map) {
    final line1 =
        map['address_line_1']?.toString() ?? map['line1']?.toString() ?? '';
    final line2 =
        map['address_line_2']?.toString() ?? map['line2']?.toString() ?? '';

    return UserAddress(
      id: map['id']?.toString() ?? '',
      label: map['label']?.toString() ?? 'Address',
      recipientName: map['recipient_name']?.toString() ?? '',
      phone: map['phone']?.toString() ?? '',
      addressLine1: line1,
      addressLine2: line2,
      city: map['city']?.toString() ?? '',
      province: map['province']?.toString() ?? '',
      postalCode: map['postal_code']?.toString() ?? '',
      lat: _parseDouble(map['lat'] ?? map['latitude']),
      long: _parseDouble(map['long'] ?? map['longitude']),
      createdAt: map['created_at']?.toString() ?? '',
      updatedAt: map['updated_at']?.toString() ?? '',
    );
  }

  UserAddress copyWith({
    String? id,
    String? label,
    String? recipientName,
    String? phone,
    String? addressLine1,
    String? addressLine2,
    String? city,
    String? province,
    String? postalCode,
    double? lat,
    double? long,
    String? createdAt,
    String? updatedAt,
  }) {
    return UserAddress(
      id: id ?? this.id,
      label: label ?? this.label,
      recipientName: recipientName ?? this.recipientName,
      phone: phone ?? this.phone,
      addressLine1: addressLine1 ?? this.addressLine1,
      addressLine2: addressLine2 ?? this.addressLine2,
      city: city ?? this.city,
      province: province ?? this.province,
      postalCode: postalCode ?? this.postalCode,
      lat: lat ?? this.lat,
      long: long ?? this.long,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toApiMap() {
    return {
      'label': label,
      'recipient_name': recipientName,
      'phone': phone,
      'address_line_1': addressLine1,
      'address_line_2': addressLine2,
      'city': city,
      'province': province,
      'postal_code': postalCode,
      'lat': lat,
      'long': long,
    };
  }

  static double? _parseDouble(Object? value) {
    if (value is num) return value.toDouble();
    return double.tryParse(value?.toString() ?? '');
  }
}
