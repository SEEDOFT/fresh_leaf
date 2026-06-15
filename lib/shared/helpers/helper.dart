import 'package:dio/dio.dart';
import 'package:fresh_leaf/shared/helpers/app_formatter.dart';

String formatPrice(double price) {
  return AppFormatter.formatNumber(price);
}

String formatPriceNoDecimals(double price) {
  return AppFormatter.formatNumber(price);
}

String formatDateTime(DateTime? value, {String defaultValue = ''}) {
  if (value == null) return defaultValue;
  return AppFormatter.formatDateTime(value);
}

String formatToString(dynamic value, {String defaultValue = ''}) {
  if (value == null) return defaultValue;
  try {
    return value.toString();
  } on Exception {
    return defaultValue;
  }
}

DateTime toDateTime(dynamic value, {DateTime? defaultValue}) {
  defaultValue ??= DateTime(0);
  if (value == null) return defaultValue;
  try {
    if (value is DateTime) return value.toLocal();
    if (value is String) {
      final trimmed = value.trim();
      if (trimmed.isEmpty) return defaultValue;
      final parsed = DateTime.tryParse(trimmed);
      return parsed?.toLocal() ?? defaultValue;
    }
    if (value is int) {
      return DateTime.fromMillisecondsSinceEpoch(value).toLocal();
    }
    if (value is double) {
      return DateTime.fromMillisecondsSinceEpoch(value.toInt()).toLocal();
    }
    return defaultValue;
  } on Exception {
    return defaultValue;
  }
}

DateTime? toNullableDateTime(dynamic value) {
  if (value == null) return null;
  if (value is DateTime) return value.toLocal();
  final raw = formatToString(value);
  if (raw.isEmpty) return null;
  return DateTime.tryParse(raw)?.toLocal();
}

bool toBool(dynamic value, {bool defaultValue = false}) {
  if (value == null) return defaultValue;
  try {
    if (value is bool) return value;
    if (value is num) return value != 0;
    if (value is String) {
      final normalized = value.trim().toLowerCase();
      if (normalized == 'true' || normalized == '1' || normalized == 'yes') {
        return true;
      }
      if (normalized == 'false' || normalized == '0' || normalized == 'no') {
        return false;
      }
    }
    return defaultValue;
  } on Exception {
    return defaultValue;
  }
}

double toDouble(dynamic value, {double defaultValue = 0.0}) {
  if (value == null) return defaultValue;
  try {
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is bool) return value ? 1.0 : 0.0;
    if (value is String) {
      final trimmed = value.trim();
      if (trimmed.isEmpty) return defaultValue;
      final cleaned = trimmed.replaceAll(',', '');
      final parsed = double.tryParse(cleaned);
      return parsed ?? defaultValue;
    }
    return defaultValue;
  } on Exception {
    return defaultValue;
  }
}

int toInt(dynamic value, {int defaultValue = 0}) {
  if (value == null) return defaultValue;
  try {
    if (value is int) return value;
    if (value is double) {
      if (value.isNaN || value.isInfinite) return defaultValue;
      return value.toInt();
    }
    if (value is bool) return value ? 1 : 0;
    if (value is String) {
      final normalized = value.trim();
      if (normalized.isEmpty) return defaultValue;
      final intVal = int.tryParse(normalized);
      if (intVal != null) return intVal;
      final cleaned = normalized.replaceAll(',', '');
      final doubleVal = double.tryParse(cleaned);
      if (doubleVal != null) return doubleVal.toInt();
      return defaultValue;
    }
    return defaultValue;
  } on Exception {
    return defaultValue;
  }
}

String parseApiErrorMessage(
  Object error, {
  String fallback = 'Unexpected error',
}) {
  if (error is DioException) {
    final payload = error.response?.data;

    if (payload is Map<String, dynamic>) {
      final status = payload['status'];
      if (status is Map<String, dynamic>) {
        final statusMessage = formatToString(status['message']);
        if (statusMessage.isNotEmpty) {
          return statusMessage;
        }
      }

      final message = formatToString(payload['message']);
      if (message.isNotEmpty) {
        return message;
      }
    }

    final dioMessage = formatToString(error.message);
    if (dioMessage.isNotEmpty) {
      return dioMessage;
    }
  }

  if (error is FormatException) {
    final message = formatToString(error.message);
    if (message.isNotEmpty) {
      return message;
    }
  }

  return fallback;
}

String normalizeCambodiaPhoneForApi(String rawValue) {
  var raw = rawValue.trim().replaceAll(RegExp(r'[\s-]'), '');
  if (raw.isEmpty) return '';

  if (raw.startsWith('+') && !raw.startsWith('+855')) {
    return '';
  }

  if (raw.startsWith('+855')) {
    raw = raw.substring(4);
  } else if (raw.startsWith('855')) {
    raw = raw.substring(3);
  }

  raw = raw.replaceAll(RegExp('[^0-9]'), '');
  if (raw.startsWith('0')) {
    raw = raw.substring(1);
  }

  if (raw.isEmpty) return '';
  return '+855$raw';
}
