import 'package:dio/dio.dart';
import 'package:fresh_leaf/app/routes/app_routes.dart';
import 'package:fresh_leaf/core/constants/api_endpoints.dart';
import 'package:fresh_leaf/core/models/api_response.dart';
import 'package:fresh_leaf/core/models/user_profile.dart';
import 'package:fresh_leaf/core/services/api_client.dart';
import 'package:fresh_leaf/core/services/pin_security_service.dart';
import 'package:fresh_leaf/core/services/storage_service.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class ProfileController extends GetxController {
  final RxBool isLoading = false.obs;
  final RxString userName = ''.obs;
  final RxString email = ''.obs;
  final RxString image = ''.obs;
  final RxString phone = ''.obs;
  final RxString memberSince = ''.obs;

  @override
  void onInit() {
    super.onInit();
    _loadUser();
  }

  void _loadUser() {
    final storage = Get.find<StorageService>();
    final profile = storage.userProfile;
    if (profile != null) {
      setProfile(profile);
    } else {
      final tokenPresent = storage.token?.isNotEmpty ?? false;
      if (tokenPresent) {
        userName.value = 'member_placeholder'.tr;
        email.value = '—';
        phone.value = '—';
        memberSince.value = 'active_member'.tr;
      }
    }
  }

  void setProfile(UserProfile profile) {
    userName.value = '${profile.firstName} ${profile.lastName}'.trim();
    email.value = profile.email;
    image.value = profile.image;
    phone.value = profile.phoneNumber;
    memberSince.value = profile.createdAt != null
        ? DateFormat(
            'dd MMM, yyyy',
          ).format(profile.createdAt!)
        : '';
  }

  Future<void> refreshProfile() async {
    try {
      final api = Get.find<ApiClient>();
      final response = await api.getRequest(
        ApiEndpoints.userProfile,
      );
      final apiResponse = ApiResponse.fromResponse(
        response.data,
        (json) => (json is Map<String, dynamic>) ? json : <String, dynamic>{},
      );

      if (!apiResponse.isSuccess && response.statusCode != 200) {
        Get.snackbar('update_failed'.tr, 'unable_refresh_profile'.tr);
        return;
      }

      final profile = UserProfile.fromMap(apiResponse.data);
      Get.find<StorageService>().setUserProfile(profile);
      setProfile(profile);
    } on DioException catch (e) {
      Get.snackbar(
        'update_failed'.tr,
        e.message ?? 'unable_refresh_profile'.tr,
      );
    } on Exception {
      Get.snackbar('update_failed'.tr, 'unable_refresh_profile'.tr);
    }
  }

  Future<void> openOrders() async {
    final canOpen = await PinSecurityService.verifyOrderAccess();
    if (!canOpen) return;
    await Get.toNamed<void>(AppRoutes.orders);
  }

  Future<void> logout() async {
    if (isLoading.value) return;
    isLoading.value = true;
    try {
      final api = Get.find<ApiClient>();
      await api.postRequest(ApiEndpoints.logout);
    } on DioException catch (e) {
      Get.snackbar('logout_failed'.tr, e.message ?? 'unable_logout'.tr);
    } on Exception {
      Get.snackbar('logout_failed'.tr, 'unable_logout'.tr);
    }

    final storage = Get.find<StorageService>();
    await storage.clear();
    await Get.offAllNamed<void>(AppRoutes.login);
    isLoading.value = false;
  }
}
