import 'package:fresh_leaf/app/routes/app_routes.dart';
import 'package:fresh_leaf/core/constants/api_endpoints.dart';
import 'package:fresh_leaf/core/models/user_profile.dart';
import 'package:fresh_leaf/core/services/api_client.dart';
import 'package:fresh_leaf/core/services/storage_service.dart';
import 'package:get/get.dart';

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
    phone.value = profile.phoneNumber;
    memberSince.value = memberSince.value.isEmpty
        ? 'Member'
        : memberSince.value;
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
