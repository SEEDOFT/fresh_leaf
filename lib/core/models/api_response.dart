class ApiStatus {
  final String code;
  final bool success;
  final String message;

  const ApiStatus({
    required this.code,
    required this.success,
    required this.message,
  });

  factory ApiStatus.fromMap(Map<String, dynamic> map) {
    return ApiStatus(
      code: map['code']?.toString() ?? '',
      success: map['success'] as bool? ?? false,
      message: map['message']?.toString() ?? '',
    );
  }
}

class ApiResponse<T> {
  final ApiStatus status;
  final T data;

  const ApiResponse({
    required this.status,
    required this.data,
  });

  bool get isSuccess => status.success;

  static ApiResponse<T> fromResponse<T>(
    dynamic responseData,
    T Function(dynamic json) parser,
  ) {
    if (responseData is! Map<String, dynamic>) {
      throw const FormatException('Unexpected API response shape');
    }

    final statusMap = responseData['status'] as Map<String, dynamic>? ?? {};
    final status = ApiStatus.fromMap(statusMap);
    final data = parser(responseData['data']);

    return ApiResponse(status: status, data: data);
  }
}
