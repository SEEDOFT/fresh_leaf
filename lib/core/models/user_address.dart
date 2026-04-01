import 'package:fresh_leaf/shared/helpers/helper.dart';

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

  factory UserAddress.fromMap(Map<String, dynamic> map) {
    final line1 = formatToString(
      map['address_line_1'] ?? map['line1'],
    );
    final line2 = formatToString(
      map['address_line_2'] ?? map['line2'],
    );

    final rawLabel = formatToString(map['label']);
    final safeLabel = rawLabel.isEmpty ? 'Address' : rawLabel;

    return UserAddress(
      id: formatToString(map['id']),
      label: safeLabel,
      recipientName: formatToString(map['recipient_name']),
      phone: formatToString(map['phone']),
      addressLine1: line1,
      addressLine2: line2,
      city: formatToString(map['city']),
      province: formatToString(map['province']),
      postalCode: formatToString(map['postal_code']),
      lat: toDouble(map['lat'] ?? map['latitude']),
      long: toDouble(map['long'] ?? map['longitude']),
      createdAt: formatToString(map['created_at']),
      updatedAt: formatToString(map['updated_at']),
    );
  }

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
}
