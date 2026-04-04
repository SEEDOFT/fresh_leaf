import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fresh_leaf/app/routes/app_routes.dart';
import 'package:fresh_leaf/core/constants/api_endpoints.dart';
import 'package:fresh_leaf/core/models/api_response.dart';
import 'package:fresh_leaf/core/models/user_profile.dart';
import 'package:fresh_leaf/core/services/api_client.dart';
import 'package:fresh_leaf/core/services/storage_service.dart';
import 'package:fresh_leaf/shared/helpers/helper.dart';
import 'package:get/get.dart';

class ProfilePinController extends GetxController {
  final currentPinController = TextEditingController();
  final newPinController = TextEditingController();
  final confirmPinController = TextEditingController();

  final RxBool isSaving = false.obs;
  final RxBool hasPin = false.obs;

  @override
  Future<void> onInit() async {
    super.onInit();
    final storage = Get.find<StorageService>();
    hasPin.value = storage.userProfile?.setPin ?? false;

    if (storage.pinOrderVerification) {
      await storage.savePinOrderVerification(enabled: false);
    }

    await _syncPinStateFromProfile();
  }

  List<TextInputFormatter> get pinInputFormatter => <TextInputFormatter>[
    FilteringTextInputFormatter.digitsOnly,
    LengthLimitingTextInputFormatter(6),
  ];

  Future<void> openSetPinWithPassword() async {
    final result = await Get.toNamed<bool?>(
      AppRoutes.pinPasswordVerification,
      arguments: const {'mode': 'set'},
    );
    if (result ?? false) {
      await _setPinState(true);
      Get.snackbar('success'.tr, 'pin_configured_success'.tr);
    }
  }

  Future<void> updateExistingPin() async {
    if (isSaving.value) return;
    if (!hasPin.value) {
      Get.snackbar('pin_not_set'.tr, 'set_pin_first'.tr);
      return;
    }

    final currentPin = currentPinController.text.trim();
    final newPin = newPinController.text.trim();
    final confirmPin = confirmPinController.text.trim();

    if (currentPin.isEmpty || newPin.isEmpty || confirmPin.isEmpty) {
      Get.snackbar('missing_fields'.tr, 'complete_all_pin_fields'.tr);
      return;
    }
    if (newPin.length < 4) {
      Get.snackbar('invalid_pin'.tr, 'pin_min_length'.tr);
      return;
    }
    if (newPin != confirmPin) {
      Get.snackbar('pin_mismatch'.tr, 'pin_confirmation_match'.tr);
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
      var updated = false;
      for (final payload in payloads) {
        try {
          final response = await api.postRequest(
            ApiEndpoints.updatePin,
            data: payload,
          );
          lastResponse = ApiResponse.parseDynamic(response.data);
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
          'update_pin_failed'.tr,
          lastResponse?.status.message.isNotEmpty ?? false
              ? lastResponse!.status.message
              : 'unable_update_pin'.tr,
        );
        return;
      }

      await _setPinState(true);
      _clearPinInputs();
      Get.snackbar(
        'success'.tr,
        lastResponse?.status.message.isNotEmpty ?? false
            ? lastResponse!.status.message
            : 'pin_updated_success'.tr,
      );
    } on DioException catch (e) {
      Get.snackbar(
        'update_pin_failed'.tr,
        parseApiErrorMessage(
          e,
          fallback: 'unable_update_pin'.tr,
        ),
      );
    } on Exception {
      Get.snackbar('update_pin_failed'.tr, 'unable_update_pin'.tr);
    } finally {
      isSaving.value = false;
    }
  }

  Future<void> openResetPinWithPassword() async {
    final result = await Get.toNamed<dynamic>(
      AppRoutes.pinPasswordVerification,
      arguments: const {'mode': 'reset'},
    );

    if (result is bool && result) {
      await _setPinState(true);
      Get.snackbar('success'.tr, 'pin_reset_success'.tr);
    }
  }

  Future<void> _setPinState(bool value) async {
    final storage = Get.find<StorageService>();
    hasPin.value = value;

    final profile = storage.userProfile;
    if (profile != null) {
      storage.setUserProfile(profile.copyWith(setPin: value));
    }

    await storage.savePinOrderVerification(enabled: false);
  }

  Future<void> _syncPinStateFromProfile() async {
    try {
      final apiClient = Get.find<ApiClient>();
      final response = await apiClient.getRequest(
        ApiEndpoints.userProfile,
      );
      final apiResponse = ApiResponse.parseMap(response.data);

      if (!apiResponse.isSuccess && response.statusCode != 200) {
        return;
      }

      final profile = UserProfile.fromMap(apiResponse.data);
      Get.find<StorageService>().setUserProfile(profile);
      hasPin.value = profile.setPin;
    } on DioException {
      // Keep current state from in-memory profile if request fails.
    } on Exception {
      // Keep current state from in-memory profile if request fails.
    }
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
