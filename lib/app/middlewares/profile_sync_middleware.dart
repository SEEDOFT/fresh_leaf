import 'package:flutter/widgets.dart';
import 'package:fresh_leaf/core/constants/api_endpoints.dart';
import 'package:fresh_leaf/core/models/api_response.dart';
import 'package:fresh_leaf/core/models/user_profile.dart';
import 'package:fresh_leaf/core/services/api_client.dart';
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
    _syncProfile(); // fire and forget
    return null;
  }

  Future<void> _syncProfile() async {
    final storage = Get.find<StorageService>();
    final hasToken = storage.token?.isNotEmpty ?? false;
    if (!hasToken) return;

    try {
      final apiClient = Get.find<ApiClient>();
      final response = await apiClient.getRequest(ApiEndpoints.userProfile);
      final apiResponse = ApiResponse.fromResponse(
        response.data,
        (json) => (json is Map<String, dynamic>) ? json : <String, dynamic>{},
      );

      if (apiResponse.isSuccess || response.statusCode == 200) {
        final profile = UserProfile.fromMap(apiResponse.data);
        storage.setUserProfile(profile);
      }
      _syncedOnce = true;
    } on Exception catch (_) {
      // If fetching fails, allow navigation; downstream screens can handle refresh errors.
    }
  }
}
