import 'package:fresh_leaf/shared/helpers/helper.dart';

class AppNotification {
  AppNotification({
    required this.id,
    required this.title,
    required this.message,
    required this.isRead,
    this.readAt,
    this.createdAt,
    this.typeCode,
    this.typeNameEn,
    this.typeNameKm,
    this.data,
  });

  factory AppNotification.fromMap(Map<String, dynamic> map) {
    return AppNotification(
      id: map['id'] as int,
      title: formatToString(map['title']),
      message: formatToString(map['message']),
      isRead: toBool(map['is_read']),
      readAt: toNullableDateTime(map['read_at']),
      createdAt: toNullableDateTime(map['created_at']),
      typeCode: (map['type'] as Map<String, dynamic>?)?['code'] as String?,
      typeNameEn: (map['type'] as Map<String, dynamic>?)?['name_en'] as String?,
      typeNameKm: (map['type'] as Map<String, dynamic>?)?['name_km'] as String?,
      data: map['data'] as Map<String, dynamic>?,
    );
  }

  final int id;
  final String title;
  final String message;
  final bool isRead;
  final DateTime? readAt;
  final DateTime? createdAt;
  final String? typeCode;
  final String? typeNameEn;
  final String? typeNameKm;
  final Map<String, dynamic>? data;
}
