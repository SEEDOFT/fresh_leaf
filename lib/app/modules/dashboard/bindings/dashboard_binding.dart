import 'package:fresh_leaf/app/modules/ai_assistant/controllers/ai_assistant_controller.dart';
import 'package:fresh_leaf/app/modules/cart/controllers/cart_controller.dart';
import 'package:fresh_leaf/app/modules/checkout/controllers/checkout_controller.dart';
import 'package:fresh_leaf/app/modules/dashboard/controllers/dashboard_controller.dart';
import 'package:fresh_leaf/app/modules/home/controllers/home_controller.dart';
import 'package:fresh_leaf/app/modules/orders/controllers/orders_controller.dart';
import 'package:fresh_leaf/app/modules/profile/controllers/profile_controller.dart';
import 'package:fresh_leaf/app/modules/search/controllers/search_controller.dart';
import 'package:fresh_leaf/app/modules/wallet/controllers/wallet_controller.dart';
import 'package:fresh_leaf/core/controllers/app_settings_controller.dart';
import 'package:fresh_leaf/core/repositories/home_repository.dart';
import 'package:fresh_leaf/core/repositories/location_repository.dart';
import 'package:fresh_leaf/core/services/ai_assistant_api_service.dart';
import 'package:fresh_leaf/core/services/ai_assistant_realtime_service.dart';
import 'package:fresh_leaf/core/services/ai_chat_storage_service.dart';
import 'package:fresh_leaf/core/services/api_client.dart';
import 'package:fresh_leaf/core/services/cart_service.dart';
import 'package:fresh_leaf/core/services/notification_service.dart';
import 'package:fresh_leaf/core/services/order_service.dart';
import 'package:fresh_leaf/core/services/product_service.dart';
import 'package:fresh_leaf/core/services/storage_service.dart';
import 'package:get/get.dart';

class DashboardBinding extends Bindings {
  @override
  void dependencies() {
    final apiClient = Get.find<ApiClient>();
    _lazy(DashboardController.new);
    _lazy(
      () => HomeController(
        productService: Get.find<ProductService>(),
        notificationService: Get.find<NotificationService>(),
        homeRepository: HomeRepository(apiClient: apiClient),
        locationRepository: LocationRepository(apiClient: apiClient),
      ),
    );
    _lazy(
      () => CartController(cartService: Get.find<CartService>()),
    );
    _lazy(
      () => AiAssistantController(
        aiChatStorageService: Get.find<AiChatStorageService>(),
        aiAssistantApiService: Get.find<AiAssistantApiService>(),
        aiAssistantRealtimeService: Get.find<AiAssistantRealtimeService>(),
      ),
    );
    _lazy(
      () => OrdersController(orderService: Get.find<OrderService>()),
    );
    _lazy(
      () => SearchController(homeController: Get.find<HomeController>()),
    );
    if (!Get.isRegistered<WalletController>()) {
      Get.put(
        WalletController(apiClient: Get.find<ApiClient>()),
        permanent: true,
      );
    }
    Get
      ..put(
        ProfileController(
          apiClient: Get.find<ApiClient>(),
          storageService: Get.find<StorageService>(),
          appSettingsController: Get.find<AppSettingsController>(),
          walletController: Get.find<WalletController>(),
          notificationService: Get.find<NotificationService>(),
        ),
        permanent: true,
      )
      ..put(
        CheckoutController(
          cartController: Get.find<CartController>(),
          cartService: Get.find<CartService>(),
          apiClient: Get.find<ApiClient>(),
          storageService: Get.find<StorageService>(),
          dashboardController: Get.find<DashboardController>(),
        ),
      );
  }

  void _lazy<T>(T Function() builder) {
    if (!Get.isRegistered<T>()) {
      Get.lazyPut<T>(builder);
    }
  }
}
