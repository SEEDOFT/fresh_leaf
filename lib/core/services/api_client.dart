import 'dart:convert';

import 'package:dio/dio.dart' as dio;
import 'package:flutter/foundation.dart';
import 'package:fresh_leaf/core/config/app_config.dart';
import 'package:fresh_leaf/core/services/storage_service.dart';
import 'package:get/get.dart' hide FormData, Response;

class ApiClient extends GetxService {
  ApiClient({required this.storageService}) {
    _dio = dio.Dio(
      dio.BaseOptions(
        baseUrl: AppConfig.apiUrl,
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 20),
        sendTimeout: const Duration(seconds: 20),
        headers: const {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    _dio.interceptors.add(
      dio.InterceptorsWrapper(
        onRequest: (options, handler) {
          final token = storageService.token;
          final languageCode = storageService.languageCode ?? 'km';
          options.headers['Accept-Language'] = _toApiLanguage(languageCode);
          if (token != null && token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
          } else {
            options.headers.remove('Authorization');
          }
          return handler.next(options);
        },
      ),
    );

    if (kDebugMode) {
      _dio.interceptors.add(
        dio.LogInterceptor(
          requestBody: true,
          responseBody: true,
          requestHeader: false,
          responseHeader: false,
          logPrint: (obj) => debugPrint(obj.toString()),
        ),
      );
    }

    _dio.interceptors.add(
      dio.InterceptorsWrapper(
        onError: (err, handler) {
          if (kDebugMode) {
            final payload = {
              'type': err.type.name,
              'message': err.message,
              'url': err.requestOptions.uri.toString(),
              'method': err.requestOptions.method,
              'status': err.response?.statusCode,
              'response': err.response?.data,
              'headers': err.response?.headers.map,
            };
            const encoder = JsonEncoder.withIndent('  ');
            debugPrint(encoder.convert(payload));
          }
          return handler.next(err);
        },
      ),
    );
  }

  late final dio.Dio _dio;
  final StorageService storageService;

  Future<void> updateAuthToken(String? token) async {
    await storageService.saveToken(token);
  }

  Future<dio.Response<Map<String, dynamic>>> getRequest(
    String path, {
    Map<String, dynamic>? queryParameters,
    dio.Options? options,
    dio.CancelToken? cancelToken,
    dio.ProgressCallback? onReceiveProgress,
  }) {
    return _dio.get<Map<String, dynamic>>(
      path,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
      onReceiveProgress: onReceiveProgress,
    );
  }

  Future<dio.Response<Map<String, dynamic>>> postRequest(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    dio.Options? options,
    dio.CancelToken? cancelToken,
    dio.ProgressCallback? onSendProgress,
    dio.ProgressCallback? onReceiveProgress,
  }) {
    final resolvedOptions = _resolveOptions(options, data);
    return _dio.post<Map<String, dynamic>>(
      path,
      data: data,
      queryParameters: queryParameters,
      options: resolvedOptions,
      cancelToken: cancelToken,
      onSendProgress: onSendProgress,
      onReceiveProgress: onReceiveProgress,
    );
  }

  Future<dio.Response<Map<String, dynamic>>> postMultipart(
    String path, {
    required dio.FormData data,
    Map<String, dynamic>? queryParameters,
    dio.Options? options,
    dio.CancelToken? cancelToken,
    dio.ProgressCallback? onSendProgress,
    dio.ProgressCallback? onReceiveProgress,
  }) {
    return _dio.post<Map<String, dynamic>>(
      path,
      data: data,
      queryParameters: queryParameters,
      options: dio.Options(
        headers: {
          'Content-Type': 'multipart/form-data',
        },
      ),
      cancelToken: cancelToken,
      onSendProgress: onSendProgress,
      onReceiveProgress: onReceiveProgress,
    );
  }

  dio.Options _resolveOptions(dio.Options? provided, dynamic data) {
    if (data is dio.FormData) {
      return dio.Options(
        headers: {
          'Content-Type': 'multipart/form-data',
          ...?provided?.headers,
        },
      );
    }
    return provided ?? dio.Options();
  }

  Future<dio.Response<Map<String, dynamic>>> putRequest(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    dio.Options? options,
    dio.CancelToken? cancelToken,
    dio.ProgressCallback? onSendProgress,
    dio.ProgressCallback? onReceiveProgress,
  }) {
    return _dio.put<Map<String, dynamic>>(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
      onSendProgress: onSendProgress,
      onReceiveProgress: onReceiveProgress,
    );
  }

  Future<dio.Response<Map<String, dynamic>>> patchRequest(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    dio.Options? options,
    dio.CancelToken? cancelToken,
    dio.ProgressCallback? onSendProgress,
    dio.ProgressCallback? onReceiveProgress,
  }) {
    return _dio.patch<Map<String, dynamic>>(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
      onSendProgress: onSendProgress,
      onReceiveProgress: onReceiveProgress,
    );
  }

  Future<dio.Response<Map<String, dynamic>>> deleteRequest(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    dio.Options? options,
    dio.CancelToken? cancelToken,
  }) {
    return _dio.delete<Map<String, dynamic>>(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
    );
  }

  Future<dio.Response<T>> externalRequest<T>(
    String url, {
    String method = 'GET',
    dynamic data,
    Map<String, dynamic>? queryParameters,
    dio.Options? options,
    dio.CancelToken? cancelToken,
  }) {
    final resolvedOptions = (options ?? dio.Options()).copyWith(method: method);
    return _dio.request<T>(
      url,
      data: data,
      queryParameters: queryParameters,
      options: resolvedOptions,
      cancelToken: cancelToken,
    );
  }

  String _toApiLanguage(String languageCode) {
    return languageCode == 'en' ? 'en' : 'km';
  }
}
