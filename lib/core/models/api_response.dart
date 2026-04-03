import 'package:fresh_leaf/shared/helpers/helper.dart';

class ApiStatus {
  const ApiStatus({
    required this.code,
    required this.success,
    required this.message,
  });

  factory ApiStatus.fromMap(Map<String, dynamic> map) {
    return ApiStatus(
      code: formatToString(map['code']),
      success: toBool(map['success']),
      message: formatToString(map['message']),
    );
  }

  final String code;
  final bool success;
  final String message;

  ApiStatus copyWith({
    String? code,
    bool? success,
    String? message,
  }) {
    return ApiStatus(
      code: code ?? this.code,
      success: success ?? this.success,
      message: message ?? this.message,
    );
  }

  Map<String, dynamic> toMap() => {
    'code': code,
    'success': success,
    'message': message,
  };
}

class ApiResponse<T> {
  const ApiResponse({
    required this.status,
    required this.data,
  });

  factory ApiResponse.fromResponse(
    dynamic responseData,
    T Function(dynamic json) parser,
  ) {
    final envelope = _toEnvelopeMap(responseData);
    final status = _parseStatus(envelope);
    final parsedData = parser(envelope['data']);

    return ApiResponse(status: status, data: parsedData);
  }

  static ApiResponse<Map<String, dynamic>> parseMap(dynamic responseData) {
    final envelope = _toEnvelopeMap(responseData);
    return ApiResponse<Map<String, dynamic>>(
      status: _parseStatus(envelope),
      data: _toMap(envelope['data']),
    );
  }

  static ApiResponse<List<Map<String, dynamic>>> parseList(
    dynamic responseData,
  ) {
    final envelope = _toEnvelopeMap(responseData);
    return ApiResponse<List<Map<String, dynamic>>>(
      status: _parseStatus(envelope),
      data: _toMapList(envelope['data']),
    );
  }

  static ApiResponse<String> parseString(dynamic responseData) {
    final envelope = _toEnvelopeMap(responseData);
    return ApiResponse<String>(
      status: _parseStatus(envelope),
      data: formatToString(envelope['data']),
    );
  }

  static ApiResponse<bool> parseBool(dynamic responseData) {
    final envelope = _toEnvelopeMap(responseData);
    return ApiResponse<bool>(
      status: _parseStatus(envelope),
      data: toBool(envelope['data']),
    );
  }

  static ApiResponse<dynamic> parseDynamic(dynamic responseData) {
    final envelope = _toEnvelopeMap(responseData);
    return ApiResponse<dynamic>(
      status: _parseStatus(envelope),
      data: envelope['data'],
    );
  }

  final ApiStatus status;
  final T data;

  bool get isSuccess => status.success;

  ApiResponse<T> copyWith({
    ApiStatus? status,
    T? data,
  }) {
    return ApiResponse(
      status: status ?? this.status,
      data: data ?? this.data,
    );
  }

  static ApiStatus _parseStatus(Map<String, dynamic> envelope) {
    final statusValue = envelope['status'];
    final statusMap = _toMap(statusValue);
    return ApiStatus.fromMap(statusMap);
  }

  static Map<String, dynamic> _toEnvelopeMap(dynamic responseData) {
    if (responseData is Map<String, dynamic>) {
      return responseData;
    }
    if (responseData is Map) {
      return responseData.map<String, dynamic>(
        (dynamic key, dynamic value) =>
            MapEntry<String, dynamic>(key.toString(), value),
      );
    }
    throw const FormatException('Unexpected API response shape');
  }

  static Map<String, dynamic> _toMap(dynamic value) {
    if (value is Map<String, dynamic>) {
      return value;
    }
    if (value is Map) {
      return value.map<String, dynamic>(
        (dynamic key, dynamic item) =>
            MapEntry<String, dynamic>(key.toString(), item),
      );
    }
    return <String, dynamic>{};
  }

  static List<Map<String, dynamic>> _toMapList(dynamic value) {
    if (value is List) {
      return value
          .whereType<Map<dynamic, dynamic>>()
          .map<Map<String, dynamic>>(
            (item) => item.map<String, dynamic>(
              (dynamic key, dynamic data) =>
                  MapEntry<String, dynamic>(key.toString(), data),
            ),
          )
          .toList();
    }
    return <Map<String, dynamic>>[];
  }
}
