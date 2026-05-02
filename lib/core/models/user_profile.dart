import 'package:fresh_leaf/shared/helpers/helper.dart';

class UserProfile {
  const UserProfile({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.image,
    required this.phoneNumber,
    this.locale = 'en',
    this.preferTheme = 'system',
    this.setPin = false,
    this.createdAt,
    this.updatedAt,
  });

  factory UserProfile.fromMap(Map<String, dynamic> map) {
    final source = (map['data'] is Map<String, dynamic>)
        ? map['data'] as Map<String, dynamic>
        : map;

    return UserProfile(
      id: toInt(source['id']),
      firstName: formatToString(source['first_name'] ?? source['firstName']),
      lastName: formatToString(source['last_name'] ?? source['lastName']),
      email: formatToString(source['email']),
      image: formatToString(source['image']),
      phoneNumber: formatToString(
        source['phone_number'] ?? source['phoneNumber'],
      ),
      locale: formatToString(source['locale'] ?? 'en'),
      preferTheme: formatToString(
        source['prefer_theme'] ?? source['preferTheme'] ?? 'system',
      ),
      setPin: toBool(source['set_pin'] ?? source['setPin']),
      createdAt: toDateTime(source['created_at'] ?? source['createdAt']),
      updatedAt: toDateTime(source['updated_at'] ?? source['updatedAt']),
    );
  }

  final int id;
  final String firstName;
  final String lastName;
  final String email;
  final String image;
  final String phoneNumber;
  final String locale;
  final String preferTheme;
  final bool setPin;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  UserProfile copyWith({
    int? id,
    String? firstName,
    String? lastName,
    String? email,
    String? image,
    String? phoneNumber,
    String? locale,
    String? preferTheme,
    bool? setPin,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return UserProfile(
      id: id ?? this.id,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      image: image ?? this.image,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      locale: locale ?? this.locale,
      preferTheme: preferTheme ?? this.preferTheme,
      setPin: setPin ?? this.setPin,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toMap() => {
    'id': id,
    'first_name': firstName,
    'last_name': lastName,
    'email': email,
    'image': image,
    'phone_number': phoneNumber,
    'locale': locale,
    'prefer_theme': preferTheme,
    'set_pin': setPin,
    'created_at': createdAt?.toIso8601String(),
    'updated_at': updatedAt?.toIso8601String(),
  };
}
