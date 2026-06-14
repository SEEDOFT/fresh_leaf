import 'package:fresh_leaf/shared/helpers/helper.dart';

class VendorInventoryRating {
  VendorInventoryRating({
    required this.id,
    required this.userId,
    required this.userName,
    required this.vendorInventoryId,
    required this.rating,
    required this.createdAt,
    this.review,
  });

  factory VendorInventoryRating.fromMap(Map<String, dynamic> map) {
    return VendorInventoryRating(
      id: map['id'] as int,
      userId: map['user_id'] as int,
      userName: map['user_name'] as String? ?? '',
      vendorInventoryId: map['vendor_inventory_id'] as int,
      rating: map['rating'] as int,
      review: formatToString(map['review']),
      createdAt:
          DateTime.tryParse(map['created_at']?.toString() ?? '') ??
          DateTime.now(),
    );
  }

  final int id;
  final int userId;
  final String userName;
  final int vendorInventoryId;
  final int rating;
  final String? review;
  final DateTime createdAt;
}
