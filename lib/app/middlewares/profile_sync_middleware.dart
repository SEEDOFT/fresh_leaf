import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:fresh_leaf/core/constants/api_endpoints.dart';
import 'package:fresh_leaf/core/models/api_response.dart';
import 'package:fresh_leaf/core/models/user_profile.dart';
import 'package:fresh_leaf/core/services/api_client.dart';
import 'package:fresh_leaf/core/services/notification_service.dart';
import 'package:fresh_leaf/core/services/storage_service.dart';
import 'package:get/get.dart';

class ProfileSyncMiddleware extends GetMiddleware {
  ProfileSyncMiddleware({this.priorityValue = 0});

  final int priorityValue;
  static bool _syncedOnce = false;

  @override
  int? get priority => priorityValue;

  @override
  RouteSettings? redirect(String? route) {
    if (_syncedOnce) return null;
    unawaited(_syncProfile());
    return null;
  }

  Future<void> _syncProfile() async {
    final storage = Get.find<StorageService>();
    final hasToken = storage.token?.isNotEmpty ?? false;
    if (!hasToken) return;

    // Ensure FCM token is synced with backend
    if (Get.isRegistered<NotificationService>()) {
      unawaited(Get.find<NotificationService>().uploadToken());
    }

    try {
      final apiClient = Get.find<ApiClient>();
      final response = await apiClient.getRequest(ApiEndpoints.userProfile);
      final apiResponse = ApiResponse.fromResponse(
        response.data,
        (json) => (json is Map<String, dynamic>) ? json : <String, dynamic>{},
      );

      if (apiResponse.isSuccess || response.statusCode == 200) {
        storage.userProfile = UserProfile.fromMap(apiResponse.data);
      }
      _syncedOnce = true;
    } on Exception {
      // If fetching fails, allow navigation;
      //downstream screens can handle refresh errors.
    }
  }
}
