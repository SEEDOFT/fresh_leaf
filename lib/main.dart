import 'package:flutter/material.dart';
import 'package:fresh_leaf/app/routes/app_pages.dart';
import 'package:fresh_leaf/app/routes/app_routes.dart';
import 'package:fresh_leaf/core/models/user_profile.dart';
import 'package:fresh_leaf/core/services/api_client.dart';
import 'package:fresh_leaf/core/services/ai_chat_storage_service.dart';
import 'package:fresh_leaf/core/services/storage_service.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:fresh_leaf/core/constants/api_endpoints.dart';
import 'package:fresh_leaf/core/models/api_response.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  await _initServices();
  final initialRoute = await _determineInitialRoute();
  runApp(MainApp(initialRoute: initialRoute));
}

// Initialize services
Future<void> _initServices() async {
  final storage = StorageService();
  await storage.init();

  Get.put<StorageService>(storage, permanent: true);
  Get.put<ApiClient>(
    ApiClient(storageService: Get.find<StorageService>()),
    permanent: true,
  );
  Get.put<AiChatStorageService>(AiChatStorageService(), permanent: true);
}

// Decide start screen based on token + profile
Future<String> _determineInitialRoute() async {
  final storage = Get.find<StorageService>();
  final api = Get.find<ApiClient>();
  final token = storage.token;
  final seenOnboarding = storage.onboardingSeen;
  storage.init();

  if (token == null || token.isEmpty) {
    return seenOnboarding ? AppRoutes.login : AppRoutes.onboarding;
  }

  api.updateAuthToken(token);

  try {
    final response = await api.getRequest(
      ApiEndpoints.userProfile,
    );
    final apiResponse = ApiResponse.fromResponse<Map<String, dynamic>>(
      response.data,
      (json) => (json is Map<String, dynamic>) ? json : <String, dynamic>{},
    );

    if (apiResponse.isSuccess || response.statusCode == 200) {
      // Set the instance of UserProfile into memory
      storage.setUserProfile(UserProfile.fromMap(apiResponse.data));
      return AppRoutes.dashboard;
    }
  } catch (_) {
    // Ignore errors and fall back to onboarding
  }
  await storage.saveToken(null);
  return seenOnboarding ? AppRoutes.login : AppRoutes.onboarding;
}

class MainApp extends StatelessWidget {
  const MainApp({super.key, required this.initialRoute});

  final String initialRoute;

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: initialRoute,
      getPages: AppPages.pages,
    );
  }
}
