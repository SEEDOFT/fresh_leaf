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
    if (responseData is! Map<String, dynamic>) {
      throw const FormatException('Unexpected API response shape');
    }

    final statusMap = responseData['status'] as Map<String, dynamic>? ?? {};
    final status = ApiStatus.fromMap(statusMap);
    final parsedData = parser(responseData['data']);

    return ApiResponse(status: status, data: parsedData);
  }

  final ApiStatus status;
  final T data;

  bool get isSuccess => status.success;
}
