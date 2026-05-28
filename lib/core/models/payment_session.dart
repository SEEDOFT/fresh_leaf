import 'package:fresh_leaf/shared/helpers/helper.dart';
import 'package:get/get.dart';

class PaymentSession {
  const PaymentSession({
    required this.sessionId,
    required this.statusId,
    this.redirectUrl,
    this.qrPayload,
    this.qrImageUrl,
    this.expiresAt,
  });

  factory PaymentSession.fromMap(Map<String, dynamic> map) {
    return PaymentSession(
      sessionId: formatToString(map['session_id']).isNotEmpty
          ? formatToString(map['session_id'])
          : formatToString(map['id']),
      statusId: (map['status'] as Map<String, dynamic>?)?['id'] as int? ?? 1,
      redirectUrl: _toNullableString(map['redirect_url']),
      qrPayload: _toNullableString(map['qr_payload']),
      qrImageUrl: _toNullableString(map['qr_image_url']),
      expiresAt: _toNullableDateTime(map['expires_at']),
    );
  }

  final String sessionId;
  final int statusId;
  final String? redirectUrl;
  final String? qrPayload;
  final String? qrImageUrl;
  final DateTime? expiresAt;

  bool get isPaid => statusId == 2;

  String get status {
    return switch (statusId) {
      1 => 'payment_pending'.tr,
      2 => 'payment_completed'.tr,
      3 => 'payment_failed'.tr,
      4 => 'payment_refunded'.tr,
      _ => 'payment_pending'.tr,
    };
  }

  Map<String, dynamic> toMap() => {
    'session_id': sessionId,
    'status_id': statusId,
    'redirect_url': redirectUrl,
    'qr_payload': qrPayload,
    'qr_image_url': qrImageUrl,
    'expires_at': expiresAt?.toIso8601String(),
  };

  static String? _toNullableString(dynamic value) {
    final raw = formatToString(value);
    if (raw.isEmpty) return null;
    return raw;
  }

  static DateTime? _toNullableDateTime(dynamic value) {
    return toNullableDateTime(value);
  }
}
