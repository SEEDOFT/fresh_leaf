import 'package:fresh_leaf/shared/helpers/helper.dart';

class VendorProfile {
  VendorProfile({
    required this.id,
    required this.name,
    required this.email,
    this.phoneNumber,
    this.businessName,
    this.contactPhone,
    this.village,
    this.commune,
    this.district,
    this.province,
    this.address,
    this.shopDescription,
    this.storeFrontImage,
    this.openingTime,
    this.closingTime,
    this.isOpen = false,
    this.isVerified = false,
    this.productCount = 0,
  });

  factory VendorProfile.fromMap(Map<String, dynamic> map) {
    return VendorProfile(
      id: toInt(map['id']),
      name: formatToString(map['name']),
      email: formatToString(map['email']),
      phoneNumber: map['phone_number'] != null
          ? formatToString(map['phone_number'])
          : null,
      businessName: map['business_name'] != null
          ? formatToString(map['business_name'])
          : null,
      contactPhone: map['contact_phone'] != null
          ? formatToString(map['contact_phone'])
          : null,
      village: map['village'] != null ? formatToString(map['village']) : null,
      commune: map['commune'] != null ? formatToString(map['commune']) : null,
      district: map['district'] != null
          ? formatToString(map['district'])
          : null,
      province: map['province'] != null
          ? formatToString(map['province'])
          : null,
      address: map['address'] != null ? formatToString(map['address']) : null,
      shopDescription: map['shop_description'] != null
          ? formatToString(map['shop_description'])
          : null,
      storeFrontImage: map['store_front_image'] != null
          ? formatToString(map['store_front_image'])
          : null,
      openingTime: map['opening_time'] != null
          ? formatToString(map['opening_time'])
          : null,
      closingTime: map['closing_time'] != null
          ? formatToString(map['closing_time'])
          : null,
      isOpen: toBool(map['is_open']),
      isVerified: toBool(map['is_verified']),
      productCount: toInt(map['product_count']),
    );
  }

  final int id;
  final String name;
  final String email;
  final String? phoneNumber;
  final String? businessName;
  final String? contactPhone;
  final String? village;
  final String? commune;
  final String? district;
  final String? province;
  final String? address;
  final String? shopDescription;
  final String? storeFrontImage;
  final String? openingTime;
  final String? closingTime;
  final bool isOpen;
  final bool isVerified;
  final int productCount;

  String get displayName => businessName ?? name;
}
