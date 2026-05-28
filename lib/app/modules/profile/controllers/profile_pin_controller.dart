import 'package:dio/dio.dart';
import 'package:fresh_leaf/app/routes/app_routes.dart';
import 'package:fresh_leaf/core/constants/api_endpoints.dart';
import 'package:fresh_leaf/core/models/api_response.dart';
import 'package:fresh_leaf/core/models/user_profile.dart';
import 'package:fresh_leaf/core/services/api_client.dart';
import 'package:fresh_leaf/core/services/storage_service.dart';
import 'package:get/get.dart';

class ProfilePinController extends GetxController {
  final StorageService _storageService = Get.find<StorageService>();
  final ApiClient _apiClient = Get.find<ApiClient>();

  final RxBool hasPin = false.obs;

  @override
  Future<void> onInit() async {
    super.onInit();
    hasPin.value = _storageService.userProfile?.setPin ?? false;

    if (_storageService.pinOrderVerification) {
      await _storageService.savePinOrderVerification(enabled: false);
    }

    await _syncPinStateFromProfile();
  }

  Future<void> openSetPinWithPassword() async {
    final result = await Get.toNamed<dynamic>(
      AppRoutes.pinPasswordVerification,
      arguments: const {'mode': 'set'},
    );
    if (result is bool && result) {
      await _setPinState(true);
      Get.snackbar('success'.tr, 'pin_configured_success'.tr);
    }
  }

  Future<void> openUpdatePinFlow() async {
    final result = await Get.toNamed<dynamic>(
      AppRoutes.pinPasswordVerification,
      arguments: const {'mode': 'update'},
    );
    if (result is bool && result) {
      await _setPinState(true);
      Get.snackbar('success'.tr, 'pin_updated_success'.tr);
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
    hasPin.value = value;

    final profile = _storageService.userProfile;
    if (profile != null) {
      _storageService.userProfile = profile.copyWith(setPin: value);
    }

    await _storageService.savePinOrderVerification(enabled: false);
  }

  Future<void> _syncPinStateFromProfile() async {
    try {
      final response = await _apiClient.getRequest(ApiEndpoints.profile);
      final apiResponse = ApiResponse.parseMap(response.data);

      if (!apiResponse.isSuccess && response.statusCode != 200) {
        return;
      }

      final profile = UserProfile.fromMap(apiResponse.data);
      _storageService.userProfile = profile;
      hasPin.value = profile.setPin;
    } on DioException {
      // Keep current state from in-memory profile if request fails.
    } on Exception {
      // Keep current state from in-memory profile if request fails.
    }
  }
}
