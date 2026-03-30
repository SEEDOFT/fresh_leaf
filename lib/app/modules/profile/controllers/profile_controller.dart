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
  final isLoading = false.obs;

  final userName = ''.obs;
  final email = ''.obs;
  final image = ''.obs;
  final phone = ''.obs;
  final memberSince = ''.obs;

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
      final tokenPresent = storage.token?.isNotEmpty == true;
      if (tokenPresent) {
        userName.value = 'FreshLeaf Member';
        email.value = '—';
        phone.value = '—';
        memberSince.value = 'Active';
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
      final response = await api.getRequest(ApiEndpoints.userProfile);
      final apiResponse = ApiResponse.fromResponse<Map<String, dynamic>>(
        response.data,
        (json) => (json is Map<String, dynamic>) ? json : <String, dynamic>{},
      );

      if (!apiResponse.isSuccess && response.statusCode != 200) {
        Get.snackbar('Error', 'Unable to refresh profile');
        return;
      }

      final profile = UserProfile.fromMap(apiResponse.data);
      final storage = Get.find<StorageService>();
      storage.setUserProfile(profile);
      setProfile(profile);
    } catch (_) {
      Get.snackbar('Error', 'Unable to refresh profile');
    }
  }

  Future<void> openOrders() async {
    final canOpen = await PinSecurityService.verifyOrderAccess();
    if (!canOpen) return;
    Get.toNamed(AppRoutes.orders);
  }

  Future<void> logout() async {
    if (isLoading.value) return;
    isLoading.value = true;
    try {
      final api = Get.find<ApiClient>();
      await api.postRequest(ApiEndpoints.logout);
    } catch (e) {
      Get.snackbar('Error', 'Cannot logout');
    }

    final storage = Get.find<StorageService>();
    await storage.clear();
    Get.offAllNamed(AppRoutes.login);
    isLoading.value = false;
  }
}
