import 'package:fresh_leaf/shared/helpers/helper.dart';

class UserProfile {
  const UserProfile({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.image,
    required this.phoneNumber,
    this.setPin = false,
    this.createdAt,
    this.updatedAt,
  });

  factory UserProfile.fromMap(Map<String, dynamic> map) {
    final source = (map['data'] is Map<String, dynamic>)
        ? map['data'] as Map<String, dynamic>
        : map;

    return UserProfile(
      firstName: formatToString(source['first_name'] ?? source['firstName']),
      lastName: formatToString(source['last_name'] ?? source['lastName']),
      email: formatToString(source['email']),
      image: formatToString(source['image']),
      phoneNumber: formatToString(
        source['phone_number'] ?? source['phoneNumber'],
      ),
      setPin: toBool(source['set_pin'] ?? source['setPin']),
      createdAt: toDateTime(source['created_at'] ?? source['createdAt']),
      updatedAt: toDateTime(source['updated_at'] ?? source['updatedAt']),
    );
  }

  final String firstName;
  final String lastName;
  final String email;
  final String image;
  final String phoneNumber;
  final bool setPin;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  UserProfile copyWith({
    String? firstName,
    String? lastName,
    String? email,
    String? image,
    String? phoneNumber,
    bool? setPin,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return UserProfile(
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      image: image ?? this.image,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      setPin: setPin ?? this.setPin,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toMap() => {
    'first_name': firstName,
    'last_name': lastName,
    'email': email,
    'image': image,
    'phone_number': phoneNumber,
    'set_pin': setPin,
    'created_at': createdAt?.toIso8601String(),
    'updated_at': updatedAt?.toIso8601String(),
  };
}
