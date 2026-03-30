class UserProfile {
  final String firstName;
  final String lastName;
  final String email;
  final String image;
  final String phoneNumber;
  final bool setPin;
  final DateTime? createdAt;
  final DateTime? updatedAt;

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
      firstName: _toString(source['first_name'] ?? source['firstName']),
      lastName: _toString(source['last_name'] ?? source['lastName']),
      email: _toString(source['email']),
      image: _toString(source['image']),
      phoneNumber: _toString(source['phone_number'] ?? source['phoneNumber']),
      setPin: _toBool(source['set_pin'] ?? source['setPin']),
      createdAt: _toDateTime(source['created_at'] ?? source['createdAt']),
      updatedAt: _toDateTime(source['updated_at'] ?? source['updatedAt']),
    );
  }

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

  static String _toString(dynamic value) {
    if (value == null) return '';
    return value.toString();
  }

  static DateTime? _toDateTime(dynamic value) {
    if (value == null) return null;
    if (value is DateTime) return value;
    if (value is String) {
      try {
        return DateTime.parse(value);
      } catch (e) {
        return null;
      }
    }
    return null;
  }

  static bool _toBool(dynamic value) {
    if (value is bool) return value;
    if (value is num) return value != 0;
    if (value is String) {
      final normalized = value.trim().toLowerCase();
      return normalized == 'true' ||
          normalized == '1' ||
          normalized == 'yes';
    }
    return false;
  }
}
