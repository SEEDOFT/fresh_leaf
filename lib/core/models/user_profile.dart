class UserProfile {
  final String firstName;
  final String lastName;
  final String email;
  final String phoneNumber;

  const UserProfile({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phoneNumber,
  });

  factory UserProfile.fromMap(Map<String, dynamic> map) {
    return UserProfile(
      firstName: map['first_name'] as String? ?? '',
      lastName: map['last_name'] as String? ?? '',
      email: map['email'] as String? ?? '',
      phoneNumber: map['phone_number'] as String? ?? '',
    );
  }

  Map<String, dynamic> toMap() => {
        'first_name': firstName,
        'last_name': lastName,
        'email': email,
        'phone_number': phoneNumber,
      };
}
