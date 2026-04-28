import 'package:dio/dio.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:fresh_leaf/app/routes/app_routes.dart';
import 'package:fresh_leaf/core/constants/api_endpoints.dart';
import 'package:fresh_leaf/core/controllers/app_settings_controller.dart';
import 'package:fresh_leaf/core/models/api_response.dart';
import 'package:fresh_leaf/core/models/user_profile.dart';
import 'package:fresh_leaf/core/services/ai_assistant_api_service.dart';
import 'package:fresh_leaf/core/services/ai_assistant_realtime_service.dart';
import 'package:fresh_leaf/core/services/ai_chat_storage_service.dart';
import 'package:fresh_leaf/core/services/api_client.dart';
import 'package:fresh_leaf/core/services/category_service.dart';
import 'package:fresh_leaf/core/services/network_service.dart';
import 'package:fresh_leaf/core/services/notification_service.dart';
import 'package:fresh_leaf/core/services/payment_session_service.dart';
import 'package:fresh_leaf/core/services/product_service.dart';
import 'package:fresh_leaf/core/services/secure_config_service.dart';
import 'package:fresh_leaf/core/services/storage_service.dart';
import 'package:fresh_leaf/firebase_options.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

final class AppBootstrap {
  AppBootstrap._();

  static Future<String> initialize() async {
    await GetStorage.init();
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    await _registerServices();
    return _resolveInitialRoute();
  }

  static Future<void> _registerServices() async {
    final storage = StorageService();
    await storage.init();

    // Initialize secure config service with environment variables
    final secureConfig = SecureConfigService();
    await secureConfig.init();

    final apiClient = ApiClient(storageService: storage);

    Get
      ..put<StorageService>(storage, permanent: true)
      ..put<SecureConfigService>(secureConfig, permanent: true)
      ..put<ApiClient>(apiClient, permanent: true)
      ..put<CategoryService>(
        CategoryService(apiClient: apiClient),
        permanent: true,
      )
      ..put<ProductService>(
        ProductService(apiClient: apiClient),
        permanent: true,
      )
      ..put<PaymentSessionService>(
        PaymentSessionService(apiClient: apiClient),
        permanent: true,
      )
      ..put<NotificationService>(
        NotificationService(apiClient: apiClient),
        permanent: true,
      )
      ..put<AiChatStorageService>(AiChatStorageService(), permanent: true)
      ..put<AiAssistantApiService>(AiAssistantApiService(), permanent: true)
      ..put<AiAssistantRealtimeService>(
        AiAssistantRealtimeService(),
        permanent: true,
      )
      ..put<AppSettingsController>(
        AppSettingsController(storageService: storage),
        permanent: true,
      );

    await Get.find<NotificationService>().init();
  }

  static Future<String> _resolveInitialRoute() async {
    final storage = Get.find<StorageService>();
    final apiClient = Get.find<ApiClient>();
    final token = storage.token;
    final seenOnboarding = storage.onboardingSeen;

    if (token == null || token.isEmpty) {
      if (!seenOnboarding) return AppRoutes.onboarding;
      final hasInternet = await NetworkService.hasInternetConnection();
      return hasInternet ? AppRoutes.login : AppRoutes.networkCheck;
    }

    await apiClient.updateAuthToken(token);

    try {
      final response = await apiClient.getRequest(ApiEndpoints.userProfile);
      final apiResponse = ApiResponse.fromResponse(
        response.data,
        (json) => (json is Map<String, dynamic>) ? json : <String, dynamic>{},
      );

      if (apiResponse.isSuccess || response.statusCode == 200) {
        storage.userProfile = UserProfile.fromMap(apiResponse.data);
        return AppRoutes.dashboard;
      }
    } on DioException catch (_) {
      // Fall back to auth flow
    }

    await storage.saveToken(null);
    if (!seenOnboarding) return AppRoutes.onboarding;
    final hasInternet = await NetworkService.hasInternetConnection();
    return hasInternet ? AppRoutes.login : AppRoutes.networkCheck;
  }
}
