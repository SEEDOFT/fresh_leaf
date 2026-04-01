String formatToString(dynamic value, {String defaultValue = ''}) {
  if (value == null) return defaultValue;
  try {
    return value.toString();
  } on Exception catch (_) {
    return defaultValue;
  }
}

DateTime toDateTime(dynamic value, {DateTime? defaultValue}) {
  defaultValue ??= DateTime(0);
  if (value == null) return defaultValue;
  try {
    if (value is DateTime) return value;
    if (value is String) {
      final trimmed = value.trim();
      if (trimmed.isEmpty) return defaultValue;
      final parsed = DateTime.tryParse(trimmed);
      return parsed ?? defaultValue;
    }
    if (value is int) {
      return DateTime.fromMillisecondsSinceEpoch(value);
    }
    if (value is double) {
      return DateTime.fromMillisecondsSinceEpoch(value.toInt());
    }
    return defaultValue;
  } on Exception catch (_) {
    return defaultValue;
  }
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
  } on Exception catch (_) {
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
  } on Exception catch (_) {
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
      final trimmed = value.trim();
      if (trimmed.isEmpty) return defaultValue;
      final intVal = int.tryParse(trimmed);
      if (intVal != null) return intVal;
      final cleaned = trimmed.replaceAll(',', '');
      final doubleVal = double.tryParse(cleaned);
      if (doubleVal != null) return doubleVal.toInt();
      return defaultValue;
    }
    return defaultValue;
  } on Exception catch (_) {
    return defaultValue;
  }
}
