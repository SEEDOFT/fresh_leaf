import 'package:fresh_leaf/shared/helpers/helper.dart';

class PaymentSession {
  const PaymentSession({
    required this.sessionId,
    required this.status,
    this.redirectUrl,
    this.qrPayload,
    this.qrImageUrl,
    this.expiresAt,
  });

  factory PaymentSession.fromMap(Map<String, dynamic> map) {
    return PaymentSession(
      sessionId:
          formatToString(map['session_id']).isNotEmpty
              ? formatToString(map['session_id'])
              : formatToString(map['id']),
      status: formatToString(map['status']),
      redirectUrl: _toNullableString(map['redirect_url']),
      qrPayload: _toNullableString(map['qr_payload']),
      qrImageUrl: _toNullableString(map['qr_image_url']),
      expiresAt: _toNullableDateTime(map['expires_at']),
    );
  }

  final String sessionId;
  final String status;
  final String? redirectUrl;
  final String? qrPayload;
  final String? qrImageUrl;
  final DateTime? expiresAt;

  bool get isPaid => status.toLowerCase() == 'paid';

  Map<String, dynamic> toMap() => {
    'session_id': sessionId,
    'status': status,
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
    final raw = formatToString(value);
    if (raw.isEmpty) return null;
    return DateTime.tryParse(raw);
  }
}

