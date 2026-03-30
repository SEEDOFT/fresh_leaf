import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fresh_leaf/app/routes/app_routes.dart';
import 'package:fresh_leaf/core/constants/api_endpoints.dart';
import 'package:fresh_leaf/core/models/api_response.dart';
import 'package:fresh_leaf/core/models/user_profile.dart';
import 'package:fresh_leaf/core/services/api_client.dart';
import 'package:fresh_leaf/core/services/storage_service.dart';
import 'package:get/get.dart';

class ProfilePinController extends GetxController {
  final currentPinController = TextEditingController();
  final newPinController = TextEditingController();
  final confirmPinController = TextEditingController();

  final isSaving = false.obs;
  final hasPin = false.obs;

  @override
  void onInit() {
    super.onInit();
    final storage = Get.find<StorageService>();
    hasPin.value = storage.userProfile?.setPin ?? false;

    if (storage.pinOrderVerification) {
      storage.savePinOrderVerification(false);
    }

    _syncPinStateFromProfile();
  }

  List<TextInputFormatter> get pinInputFormatter => <TextInputFormatter>[
    FilteringTextInputFormatter.digitsOnly,
    LengthLimitingTextInputFormatter(6),
  ];

  Future<void> openSetPinWithPassword() async {
    final result = await Get.toNamed(
      AppRoutes.pinPasswordVerification,
      arguments: const {'mode': 'set'},
    );
    if (result == true) {
      await _setPinState(true);
      Get.snackbar('Success', 'PIN configured successfully.');
    }
  }

  Future<void> updateExistingPin() async {
    if (isSaving.value) return;
    if (!hasPin.value) {
      Get.snackbar('PIN not set', 'Please set your PIN first.');
      return;
    }

    final currentPin = currentPinController.text.trim();
    final newPin = newPinController.text.trim();
    final confirmPin = confirmPinController.text.trim();

    if (currentPin.isEmpty || newPin.isEmpty || confirmPin.isEmpty) {
      Get.snackbar('Missing fields', 'Please complete all PIN fields.');
      return;
    }
    if (newPin.length < 4) {
      Get.snackbar('Invalid PIN', 'PIN must be at least 4 digits.');
      return;
    }
    if (newPin != confirmPin) {
      Get.snackbar('PIN mismatch', 'PIN and confirmation must match.');
      return;
    }

    isSaving.value = true;
    try {
      final api = Get.find<ApiClient>();
      final payloads = <Map<String, dynamic>>[
        {
          'current_pin': currentPin,
          'pin': newPin,
          'pin_confirmation': confirmPin,
        },
        {
          'current_pin': currentPin,
          'new_pin': newPin,
          'new_pin_confirmation': confirmPin,
        },
      ];

      ApiResponse<dynamic>? lastResponse;
      bool updated = false;
      for (final payload in payloads) {
        try {
          final response = await api.postRequest(
            ApiEndpoints.updatePin,
            data: payload,
          );
          lastResponse = ApiResponse.fromResponse<dynamic>(
            response.data,
            (json) => json,
          );
          if (lastResponse.isSuccess || response.statusCode == 200) {
            updated = true;
            break;
          }
        } on DioException {
          // Try next payload shape.
        }
      }

      if (!updated) {
        Get.snackbar(
          'Update PIN failed',
          lastResponse?.status.message.isNotEmpty == true
              ? lastResponse!.status.message
              : 'Unable to update PIN',
        );
        return;
      }

      await _setPinState(true);
      _clearPinInputs();
      Get.snackbar(
        'Success',
        lastResponse?.status.message.isNotEmpty == true
            ? lastResponse!.status.message
            : 'PIN updated successfully',
      );
    } on DioException catch (e) {
      Get.snackbar(
        'Update PIN failed',
        _extractApiMessage(e, fallback: 'Unable to update PIN'),
      );
    } catch (_) {
      Get.snackbar('Update PIN failed', 'Unable to update PIN');
    } finally {
      isSaving.value = false;
    }
  }

  Future<void> openResetPinWithPassword() async {
    final result = await Get.toNamed(
      AppRoutes.pinPasswordVerification,
      arguments: const {'mode': 'reset'},
    );
    if (result == true) {
      await _setPinState(true);
      Get.snackbar('Success', 'PIN reset successfully.');
    }
  }

  Future<void> _setPinState(bool value) async {
    final storage = Get.find<StorageService>();
    hasPin.value = value;

    final profile = storage.userProfile;
    if (profile != null) {
      storage.setUserProfile(profile.copyWith(setPin: value));
    }

    await storage.savePinOrderVerification(false);
  }

  Future<void> _syncPinStateFromProfile() async {
    try {
      final api = Get.find<ApiClient>();
      final response = await api.getRequest(ApiEndpoints.userProfile);
      final apiResponse = ApiResponse.fromResponse<Map<String, dynamic>>(
        response.data,
        (json) => (json is Map<String, dynamic>) ? json : <String, dynamic>{},
      );

      if (!apiResponse.isSuccess && response.statusCode != 200) {
        return;
      }

      final profile = UserProfile.fromMap(apiResponse.data);
      final storage = Get.find<StorageService>();
      storage.setUserProfile(profile);
      hasPin.value = profile.setPin;
    } catch (_) {
      // Keep current state from in-memory profile if request fails.
    }
  }

  String _extractApiMessage(DioException error, {required String fallback}) {
    final responseData = error.response?.data;
    if (responseData is Map) {
      final status = responseData['status'];
      if (status is Map && status['message'] != null) {
        return status['message'].toString();
      }
    }
    return fallback;
  }

  void _clearPinInputs() {
    currentPinController.clear();
    newPinController.clear();
    confirmPinController.clear();
  }

  @override
  void onClose() {
    currentPinController.dispose();
    newPinController.dispose();
    confirmPinController.dispose();
    super.onClose();
  }
}
