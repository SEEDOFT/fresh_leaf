import 'dart:io';

import 'package:dio/dio.dart' as dio;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';
import 'package:flutter/material.dart' hide SearchController;
import 'package:flutter_test/flutter_test.dart';
import 'package:fresh_leaf/app/modules/ai_assistant/bindings/ai_assistant_binding.dart';
import 'package:fresh_leaf/app/modules/ai_assistant/controllers/ai_assistant_controller.dart';
import 'package:fresh_leaf/app/modules/cart/bindings/cart_binding.dart';
import 'package:fresh_leaf/app/modules/cart/controllers/cart_controller.dart';
import 'package:fresh_leaf/app/modules/checkout/bindings/checkout_binding.dart';
import 'package:fresh_leaf/app/modules/checkout/controllers/checkout_controller.dart';
import 'package:fresh_leaf/app/modules/dashboard/bindings/dashboard_binding.dart';
import 'package:fresh_leaf/app/modules/dashboard/controllers/dashboard_controller.dart';
import 'package:fresh_leaf/app/modules/home/bindings/home_binding.dart';
import 'package:fresh_leaf/app/modules/home/controllers/home_controller.dart';
import 'package:fresh_leaf/app/modules/login/bindings/login_binding.dart';
import 'package:fresh_leaf/app/modules/login/controllers/login_controller.dart';
import 'package:fresh_leaf/app/modules/network_check/bindings/network_check_binding.dart';
import 'package:fresh_leaf/app/modules/network_check/controllers/network_check_controller.dart';
import 'package:fresh_leaf/app/modules/notifications/bindings/notification_detail_binding.dart';
import 'package:fresh_leaf/app/modules/notifications/bindings/notifications_binding.dart';
import 'package:fresh_leaf/app/modules/notifications/controllers/notification_detail_controller.dart';
import 'package:fresh_leaf/app/modules/notifications/controllers/notifications_controller.dart';
import 'package:fresh_leaf/app/modules/onboarding/bindings/onboarding_binding.dart';
import 'package:fresh_leaf/app/modules/onboarding/controllers/onboarding_controller.dart';
import 'package:fresh_leaf/app/modules/order_detail/bindings/order_detail_binding.dart';
import 'package:fresh_leaf/app/modules/order_detail/controllers/order_detail_controller.dart';
import 'package:fresh_leaf/app/modules/order_external_payment/bindings/order_external_payment_binding.dart';
import 'package:fresh_leaf/app/modules/order_external_payment/controllers/order_external_payment_controller.dart';
import 'package:fresh_leaf/app/modules/order_wallet_payment/bindings/order_wallet_payment_binding.dart';
import 'package:fresh_leaf/app/modules/order_wallet_payment/controllers/order_wallet_payment_controller.dart';
import 'package:fresh_leaf/app/modules/orders/bindings/orders_binding.dart';
import 'package:fresh_leaf/app/modules/orders/controllers/orders_controller.dart';
import 'package:fresh_leaf/app/modules/payment_qr/bindings/payment_qr_binding.dart';
import 'package:fresh_leaf/app/modules/payment_qr/controllers/payment_qr_controller.dart';
import 'package:fresh_leaf/app/modules/product_detail/bindings/product_detail_binding.dart';
import 'package:fresh_leaf/app/modules/product_detail/controllers/product_detail_controller.dart';
import 'package:fresh_leaf/app/modules/product_list/bindings/product_list_binding.dart';
import 'package:fresh_leaf/app/modules/product_list/controllers/product_list_controller.dart';
import 'package:fresh_leaf/app/modules/profile/bindings/pin_verification_binding.dart';
import 'package:fresh_leaf/app/modules/profile/bindings/profile_address_edit_binding.dart';
import 'package:fresh_leaf/app/modules/profile/bindings/profile_addresses_binding.dart';
import 'package:fresh_leaf/app/modules/profile/bindings/profile_binding.dart';
import 'package:fresh_leaf/app/modules/profile/bindings/profile_help_center_binding.dart';
import 'package:fresh_leaf/app/modules/profile/bindings/profile_payment_add_binding.dart';
import 'package:fresh_leaf/app/modules/profile/bindings/profile_payment_binding.dart';
import 'package:fresh_leaf/app/modules/profile/bindings/profile_personal_details_binding.dart';
import 'package:fresh_leaf/app/modules/profile/bindings/profile_pin_binding.dart';
import 'package:fresh_leaf/app/modules/profile/bindings/profile_pin_password_verify_binding.dart';
import 'package:fresh_leaf/app/modules/profile/bindings/profile_privacy_binding.dart';
import 'package:fresh_leaf/app/modules/profile/bindings/profile_security_binding.dart';
import 'package:fresh_leaf/app/modules/profile/bindings/profile_settings_binding.dart';
import 'package:fresh_leaf/app/modules/profile/bindings/profile_wishlist_binding.dart';
import 'package:fresh_leaf/app/modules/profile/controllers/pin_verification_controller.dart';
import 'package:fresh_leaf/app/modules/profile/controllers/profile_address_edit_controller.dart';
import 'package:fresh_leaf/app/modules/profile/controllers/profile_addresses_controller.dart';
import 'package:fresh_leaf/app/modules/profile/controllers/profile_controller.dart';
import 'package:fresh_leaf/app/modules/profile/controllers/profile_help_center_controller.dart';
import 'package:fresh_leaf/app/modules/profile/controllers/profile_payment_add_controller.dart';
import 'package:fresh_leaf/app/modules/profile/controllers/profile_payment_controller.dart';
import 'package:fresh_leaf/app/modules/profile/controllers/profile_personal_details_controller.dart';
import 'package:fresh_leaf/app/modules/profile/controllers/profile_pin_controller.dart';
import 'package:fresh_leaf/app/modules/profile/controllers/profile_pin_password_verify_controller.dart';
import 'package:fresh_leaf/app/modules/profile/controllers/profile_privacy_controller.dart';
import 'package:fresh_leaf/app/modules/profile/controllers/profile_security_controller.dart';
import 'package:fresh_leaf/app/modules/profile/controllers/profile_settings_controller.dart';
import 'package:fresh_leaf/app/modules/profile/controllers/profile_wishlist_controller.dart';
import 'package:fresh_leaf/app/modules/register/bindings/register_binding.dart';
import 'package:fresh_leaf/app/modules/register/controllers/register_controller.dart';
import 'package:fresh_leaf/app/modules/search/bindings/search_binding.dart';
import 'package:fresh_leaf/app/modules/search/controllers/search_controller.dart'
    as search;
import 'package:fresh_leaf/app/modules/splash/bindings/splash_binding.dart';
import 'package:fresh_leaf/app/modules/splash/controllers/splash_controller.dart';
import 'package:fresh_leaf/app/modules/support_chat/bindings/support_chat_binding.dart';
import 'package:fresh_leaf/app/modules/support_chat/controllers/support_chat_controller.dart';
import 'package:fresh_leaf/app/modules/support_tickets/bindings/support_tickets_binding.dart';
import 'package:fresh_leaf/app/modules/support_tickets/controllers/support_tickets_controller.dart';
import 'package:fresh_leaf/app/modules/vendor_profile/bindings/vendor_profile_binding.dart';
import 'package:fresh_leaf/app/modules/vendor_profile/controllers/vendor_profile_controller.dart';
import 'package:fresh_leaf/app/modules/wallet/bindings/wallet_binding.dart';
import 'package:fresh_leaf/app/modules/wallet/controllers/wallet_controller.dart';
import 'package:fresh_leaf/app/modules/wallet_top_up/bindings/wallet_top_up_binding.dart';
import 'package:fresh_leaf/app/modules/wallet_top_up/controllers/wallet_top_up_controller.dart';
import 'package:fresh_leaf/app/modules/wallet_top_up_payment/bindings/wallet_top_up_payment_binding.dart';
import 'package:fresh_leaf/app/modules/wallet_top_up_payment/controllers/wallet_top_up_payment_controller.dart';
import 'package:fresh_leaf/app/routes/app_routes.dart';
import 'package:fresh_leaf/core/controllers/app_settings_controller.dart';
import 'package:fresh_leaf/core/controllers/wishlist_controller.dart';
import 'package:fresh_leaf/core/services/ai_assistant_api_service.dart';
import 'package:fresh_leaf/core/services/ai_assistant_realtime_service.dart';
import 'package:fresh_leaf/core/services/ai_chat_storage_service.dart';
import 'package:fresh_leaf/core/services/api_client.dart';
import 'package:fresh_leaf/core/services/cart_service.dart';
import 'package:fresh_leaf/core/services/chat_realtime_service.dart';
import 'package:fresh_leaf/core/services/launch_route_service.dart';
import 'package:fresh_leaf/core/services/notification_service.dart';
import 'package:fresh_leaf/core/services/order_service.dart';
import 'package:fresh_leaf/core/services/payment_session_service.dart';
import 'package:fresh_leaf/core/services/product_service.dart';
import 'package:fresh_leaf/core/services/storage_service.dart';
import 'package:fresh_leaf/core/services/wishlist_service.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class _FakeFlutterSecureStorage extends FlutterSecureStorage {
  final _store = <String, String>{};

  @override
  Future<String?> read({
    required String key,
    AppleOptions? iOptions,
    AndroidOptions? aOptions,
    LinuxOptions? lOptions,
    WebOptions? webOptions,
    AppleOptions? mOptions,
    WindowsOptions? wOptions,
  }) async {
    return _store[key];
  }

  @override
  Future<void> write({
    required String key,
    required String? value,
    AppleOptions? iOptions,
    AndroidOptions? aOptions,
    LinuxOptions? lOptions,
    WebOptions? webOptions,
    AppleOptions? mOptions,
    WindowsOptions? wOptions,
  }) async {
    if (value == null) {
      _store.remove(key);
    } else {
      _store[key] = value;
    }
  }

  @override
  Future<void> delete({
    required String key,
    AppleOptions? iOptions,
    AndroidOptions? aOptions,
    LinuxOptions? lOptions,
    WebOptions? webOptions,
    AppleOptions? mOptions,
    WindowsOptions? wOptions,
  }) async {
    _store.remove(key);
  }

  @override
  Future<bool> containsKey({
    required String key,
    AppleOptions? iOptions,
    AndroidOptions? aOptions,
    LinuxOptions? lOptions,
    WebOptions? webOptions,
    AppleOptions? mOptions,
    WindowsOptions? wOptions,
  }) async {
    return _store.containsKey(key);
  }

  @override
  Future<void> deleteAll({
    AppleOptions? iOptions,
    AndroidOptions? aOptions,
    LinuxOptions? lOptions,
    WebOptions? webOptions,
    AppleOptions? mOptions,
    WindowsOptions? wOptions,
  }) async {
    _store.clear();
  }

  @override
  Future<Map<String, String>> readAll({
    AppleOptions? iOptions,
    AndroidOptions? aOptions,
    LinuxOptions? lOptions,
    WebOptions? webOptions,
    AppleOptions? mOptions,
    WindowsOptions? wOptions,
  }) async {
    return Map<String, String>.from(_store);
  }
}

class _FakePathProviderPlatform extends PathProviderPlatform {
  @override
  Future<String> getApplicationDocumentsPath() async {
    return Directory.systemTemp.path;
  }

  @override
  Future<String> getTemporaryPath() async {
    return Directory.systemTemp.path;
  }

  @override
  Future<String> getLibraryPath() async {
    return Directory.systemTemp.path;
  }

  @override
  Future<String> getApplicationSupportPath() async {
    return Directory.systemTemp.path;
  }

  @override
  Future<String> getDownloadsPath() async {
    return Directory.systemTemp.path;
  }

  @override
  Future<List<String>?> getExternalStoragePaths({
    StorageDirectory? type,
  }) async {
    return <String>[Directory.systemTemp.path];
  }
}

class FakeApiClient extends ApiClient {
  FakeApiClient({required super.storageService});

  @override
  Future<dio.Response<Map<String, dynamic>>> getRequest(
    String path, {
    Map<String, dynamic>? queryParameters,
    dio.Options? options,
    dio.CancelToken? cancelToken,
    dio.ProgressCallback? onReceiveProgress,
  }) {
    return _okResponse(path);
  }

  @override
  Future<dio.Response<Map<String, dynamic>>> postRequest(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    dio.Options? options,
    dio.CancelToken? cancelToken,
    dio.ProgressCallback? onSendProgress,
    dio.ProgressCallback? onReceiveProgress,
  }) {
    return _okResponse(path);
  }

  @override
  Future<dio.Response<Map<String, dynamic>>> putRequest(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    dio.Options? options,
    dio.CancelToken? cancelToken,
    dio.ProgressCallback? onSendProgress,
    dio.ProgressCallback? onReceiveProgress,
  }) {
    return _okResponse(path);
  }

  @override
  Future<dio.Response<Map<String, dynamic>>> patchRequest(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    dio.Options? options,
    dio.CancelToken? cancelToken,
    dio.ProgressCallback? onSendProgress,
    dio.ProgressCallback? onReceiveProgress,
  }) {
    return _okResponse(path);
  }

  @override
  Future<dio.Response<Map<String, dynamic>>> deleteRequest(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    dio.Options? options,
    dio.CancelToken? cancelToken,
  }) {
    return _okResponse(path);
  }

  @override
  Future<dio.Response<Map<String, dynamic>>> postMultipart(
    String path, {
    required dio.FormData data,
    Map<String, dynamic>? queryParameters,
    dio.Options? options,
    dio.CancelToken? cancelToken,
    dio.ProgressCallback? onSendProgress,
    dio.ProgressCallback? onReceiveProgress,
  }) {
    return _okResponse(path);
  }

  @override
  Future<dio.Response<T>> externalRequest<T>(
    String url, {
    String method = 'GET',
    dynamic data,
    Map<String, dynamic>? queryParameters,
    dio.Options? options,
    dio.CancelToken? cancelToken,
  }) {
    final empty = <String, dynamic>{};
    return Future<dio.Response<T>>.value(
      dio.Response<T>(
        requestOptions: dio.RequestOptions(path: url),
        statusCode: 200,
        data: empty as T,
      ),
    );
  }

  Future<dio.Response<Map<String, dynamic>>> _okResponse(String path) {
    return Future<dio.Response<Map<String, dynamic>>>.value(
      dio.Response<Map<String, dynamic>>(
        requestOptions: dio.RequestOptions(path: path),
        statusCode: 200,
        data: <String, dynamic>{
          'status': <String, dynamic>{'code': '200', 'message': 'Success'},
          'data': <dynamic, dynamic>{},
        },
      ),
    );
  }
}

Future<void> registerCoreServices() async {
  final storage = StorageService(
    box: GetStorage(),
    secureStorage: _FakeFlutterSecureStorage(),
  );
  await storage.init();

  final apiClient = FakeApiClient(storageService: storage);
  final productService = ProductService(apiClient: apiClient);
  final cartService = CartService(apiClient: apiClient);
  final orderService = OrderService(apiClient: apiClient);
  final wishlistService = WishlistService(apiClient: apiClient);
  final paymentSessionService = PaymentSessionService(apiClient: apiClient);
  final notificationService = NotificationService(apiClient: apiClient);
  final aiChatStorageService = AiChatStorageService(box: GetStorage());
  final aiAssistantApiService = AiAssistantApiService(apiClient: apiClient);
  final aiAssistantRealtimeService = AiAssistantRealtimeService(
    apiClient: apiClient,
  );
  final chatRealtimeService = ChatRealtimeService(apiClient: apiClient);
  final appSettingsController = AppSettingsController(
    storageService: storage,
  );
  final wishlistController = WishlistController(
    wishlistService: wishlistService,
  );
  final launchRouteService = LaunchRouteService(AppRoutes.login);

  Get
    ..put<StorageService>(storage, permanent: true)
    ..put<ApiClient>(apiClient, permanent: true)
    ..put<ProductService>(productService, permanent: true)
    ..put<CartService>(cartService, permanent: true)
    ..put<OrderService>(orderService, permanent: true)
    ..put<WishlistService>(wishlistService, permanent: true)
    ..put<PaymentSessionService>(paymentSessionService, permanent: true)
    ..put<NotificationService>(notificationService, permanent: true)
    ..put<AiChatStorageService>(aiChatStorageService, permanent: true)
    ..put<AiAssistantApiService>(aiAssistantApiService, permanent: true)
    ..put<AiAssistantRealtimeService>(
      aiAssistantRealtimeService,
      permanent: true,
    )
    ..put<AppSettingsController>(appSettingsController, permanent: true)
    ..put<WishlistController>(wishlistController, permanent: true)
    ..put<ChatRealtimeService>(chatRealtimeService, permanent: true)
    ..put<LaunchRouteService>(launchRouteService, permanent: true);
}

Widget buildApp(String route) {
  return GetMaterialApp(
    initialRoute: route,
    getPages: <GetPage<dynamic>>[
      GetPage(
        name: AppRoutes.login,
        page: SizedBox.shrink,
      ),
      GetPage(
        name: route,
        page: SizedBox.shrink,
      ),
    ],
  );
}

void main() {
  setUpAll(() async {
    PathProviderPlatform.instance = _FakePathProviderPlatform();
    await GetStorage.init();
  });

  setUp(() async {
    await registerCoreServices();
  });

  tearDown(() {
    Get.reset();
  });

  group('Auth-free pages', () {
    testWidgets('/network_check initializes', (tester) async {
      NetworkCheckBinding().dependencies();
      await tester.pumpWidget(buildApp(AppRoutes.networkCheck));
      await tester.pump();
      expect(Get.isRegistered<NetworkCheckController>(), isTrue);
    });

    testWidgets('/onboarding initializes', (tester) async {
      OnboardingBinding().dependencies();
      await tester.pumpWidget(buildApp(AppRoutes.onboarding));
      await tester.pump();
      expect(Get.isRegistered<OnboardingController>(), isTrue);
    });

    testWidgets('/login initializes', (tester) async {
      LoginBinding().dependencies();
      await tester.pumpWidget(buildApp(AppRoutes.login));
      await tester.pump();
      expect(Get.isRegistered<LoginController>(), isTrue);
    });

    testWidgets('/register initializes', (tester) async {
      RegisterBinding().dependencies();
      await tester.pumpWidget(buildApp(AppRoutes.register));
      await tester.pump();
      expect(Get.isRegistered<RegisterController>(), isTrue);
    });

    testWidgets('/splash initializes', (tester) async {
      SplashBinding().dependencies();
      await tester.pumpWidget(
        GetMaterialApp(
          initialRoute: AppRoutes.splash,
          getPages: <GetPage<dynamic>>[
            GetPage(name: AppRoutes.splash, page: SizedBox.shrink),
          ],
        ),
      );
      await tester.pump();
      expect(Get.isRegistered<SplashController>(), isTrue);
    });
  });

  group('Self-contained auth pages', () {
    testWidgets('/orders initializes', (tester) async {
      await Get.find<StorageService>().saveToken('test-token');
      OrdersBinding().dependencies();
      await tester.pumpWidget(buildApp(AppRoutes.orders));
      await tester.pump();
      expect(Get.isRegistered<OrdersController>(), isTrue);
    });

    testWidgets('/notifications initializes', (tester) async {
      await Get.find<StorageService>().saveToken('test-token');
      NotificationsBinding().dependencies();
      await tester.pumpWidget(buildApp(AppRoutes.notifications));
      await tester.pump();
      expect(Get.isRegistered<NotificationsController>(), isTrue);
    });

    testWidgets('/notification_detail initializes', (tester) async {
      await Get.find<StorageService>().saveToken('test-token');
      NotificationDetailBinding().dependencies();
      await tester.pumpWidget(buildApp(AppRoutes.notificationDetail));
      await tester.pump();
      expect(Get.isRegistered<NotificationDetailController>(), isTrue);
    });

    testWidgets('/product_list initializes', (tester) async {
      await Get.find<StorageService>().saveToken('test-token');
      ProductListBinding().dependencies();
      await tester.pumpWidget(buildApp(AppRoutes.productList));
      await tester.pump();
      expect(Get.isRegistered<ProductListController>(), isTrue);
    });

    testWidgets('/payment_qr initializes', (tester) async {
      await Get.find<StorageService>().saveToken('test-token');
      PaymentQrBinding().dependencies();
      await tester.pumpWidget(buildApp(AppRoutes.paymentQr));
      await tester.pump();
      expect(Get.isRegistered<PaymentQrController>(), isTrue);
    });

    testWidgets('/wallet initializes', (tester) async {
      await Get.find<StorageService>().saveToken('test-token');
      WalletBinding().dependencies();
      await tester.pumpWidget(buildApp(AppRoutes.wallet));
      await tester.pump();
      expect(Get.isRegistered<WalletController>(), isTrue);
    });

    testWidgets('/wallet_top_up_payment initializes', (tester) async {
      await Get.find<StorageService>().saveToken('test-token');
      WalletTopUpPaymentBinding().dependencies();
      await tester.pumpWidget(buildApp(AppRoutes.walletTopUpPayment));
      await tester.pump();
      expect(Get.isRegistered<WalletTopUpPaymentController>(), isTrue);
    });

    testWidgets('/order_detail initializes', (tester) async {
      await Get.find<StorageService>().saveToken('test-token');
      OrderDetailBinding().dependencies();
      await tester.pumpWidget(buildApp(AppRoutes.orderDetail));
      await tester.pump();
      expect(Get.isRegistered<OrderDetailController>(), isTrue);
    });

    testWidgets('/order_wallet_payment initializes', (tester) async {
      await Get.find<StorageService>().saveToken('test-token');
      OrderWalletPaymentBinding().dependencies();
      await tester.pumpWidget(buildApp(AppRoutes.orderWalletPayment));
      await tester.pump();
      expect(Get.isRegistered<OrderWalletPaymentController>(), isTrue);
    });

    testWidgets('/support_tickets initializes', (tester) async {
      await Get.find<StorageService>().saveToken('test-token');
      SupportTicketsBinding().dependencies();
      await tester.pumpWidget(buildApp(AppRoutes.supportTickets));
      await tester.pump();
      expect(Get.isRegistered<SupportTicketsController>(), isTrue);
    });

    testWidgets('/support_chat initializes', (tester) async {
      await Get.find<StorageService>().saveToken('test-token');
      SupportChatBinding().dependencies();
      await tester.pumpWidget(buildApp(AppRoutes.supportChat));
      await tester.pump();
      expect(Get.isRegistered<SupportChatController>(), isTrue);
    });

    testWidgets('/ai_assistant initializes', (tester) async {
      await Get.find<StorageService>().saveToken('test-token');
      AiAssistantBinding().dependencies();
      await tester.pumpWidget(buildApp(AppRoutes.aiAssistant));
      await tester.pump();
      expect(Get.isRegistered<AiAssistantController>(), isTrue);
    });

    testWidgets('/vendor_profile initializes', (tester) async {
      await Get.find<StorageService>().saveToken('test-token');
      VendorProfileBinding().dependencies();
      await tester.pumpWidget(buildApp(AppRoutes.vendorProfile));
      await tester.pump();
      expect(Get.isRegistered<VendorProfileController>(), isTrue);
    });

    testWidgets('/security_settings initializes', (tester) async {
      await Get.find<StorageService>().saveToken('test-token');
      ProfileSecurityBinding().dependencies();
      await tester.pumpWidget(buildApp(AppRoutes.securitySettings));
      await tester.pump();
      expect(Get.isRegistered<ProfileSecurityController>(), isTrue);
    });

    testWidgets('/pin_security initializes', (tester) async {
      await Get.find<StorageService>().saveToken('test-token');
      ProfilePinBinding().dependencies();
      await tester.pumpWidget(buildApp(AppRoutes.pinSecurity));
      await tester.pump();
      expect(Get.isRegistered<ProfilePinController>(), isTrue);
    });

    testWidgets('/pin_password_verification initializes', (tester) async {
      await Get.find<StorageService>().saveToken('test-token');
      ProfilePinPasswordVerifyBinding().dependencies();
      await tester.pumpWidget(buildApp(AppRoutes.pinPasswordVerification));
      await tester.pump();
      expect(Get.isRegistered<ProfilePinPasswordVerifyController>(), isTrue);
    });

    testWidgets('/pin_verification initializes', (tester) async {
      await Get.find<StorageService>().saveToken('test-token');
      PinVerificationBinding().dependencies();
      await tester.pumpWidget(buildApp(AppRoutes.pinVerification));
      await tester.pump();
      expect(Get.isRegistered<PinVerificationController>(), isTrue);
    });

    testWidgets('/privacy_terms initializes', (tester) async {
      await Get.find<StorageService>().saveToken('test-token');
      ProfilePrivacyBinding().dependencies();
      await tester.pumpWidget(buildApp(AppRoutes.privacyTerms));
      await tester.pump();
      expect(Get.isRegistered<ProfilePrivacyController>(), isTrue);
    });

    testWidgets('/payment_methods_add initializes', (tester) async {
      await Get.find<StorageService>().saveToken('test-token');
      ProfilePaymentAddBinding().dependencies();
      await tester.pumpWidget(buildApp(AppRoutes.paymentMethodsAdd));
      await tester.pump();
      expect(Get.isRegistered<ProfilePaymentAddController>(), isTrue);
    });

    testWidgets('/help_center initializes', (tester) async {
      await Get.find<StorageService>().saveToken('test-token');
      ProfileHelpCenterBinding().dependencies();
      await tester.pumpWidget(buildApp(AppRoutes.helpCenter));
      await tester.pump();
      expect(Get.isRegistered<ProfileHelpCenterController>(), isTrue);
    });

    testWidgets('/addresses_edit initializes', (tester) async {
      await Get.find<StorageService>().saveToken('test-token');
      ProfileAddressEditBinding().dependencies();
      await tester.pumpWidget(buildApp(AppRoutes.addressesEdit));
      await tester.pump();
      expect(Get.isRegistered<ProfileAddressEditController>(), isTrue);
    });

    testWidgets('/settings initializes', (tester) async {
      await Get.find<StorageService>().saveToken('test-token');
      ProfileSettingsBinding().dependencies();
      await tester.pumpWidget(buildApp(AppRoutes.settings));
      await tester.pump();
      expect(Get.isRegistered<ProfileSettingsController>(), isTrue);
    });
  });

  group('Auth pages with cross-controller deps', () {
    testWidgets('/dashboard initializes', (tester) async {
      await Get.find<StorageService>().saveToken('test-token');
      DashboardBinding().dependencies();
      await tester.pumpWidget(buildApp(AppRoutes.dashboard));
      await tester.pump();
      expect(Get.isRegistered<DashboardController>(), isTrue);
    });

    testWidgets('/home initializes', (tester) async {
      await Get.find<StorageService>().saveToken('test-token');
      HomeBinding().dependencies();
      await tester.pumpWidget(buildApp(AppRoutes.home));
      await tester.pump();
      expect(Get.isRegistered<HomeController>(), isTrue);
    });

    testWidgets('/cart initializes', (tester) async {
      await Get.find<StorageService>().saveToken('test-token');
      CartBinding().dependencies();
      await tester.pumpWidget(buildApp(AppRoutes.cart));
      await tester.pump();
      expect(Get.isRegistered<CartController>(), isTrue);
    });

    testWidgets('/search initializes', (tester) async {
      await Get.find<StorageService>().saveToken('test-token');
      HomeBinding().dependencies();
      SearchBinding().dependencies();
      await tester.pumpWidget(buildApp(AppRoutes.search));
      await tester.pump();
      expect(Get.isRegistered<search.SearchController>(), isTrue);
    });

    testWidgets('/checkout initializes', (tester) async {
      await Get.find<StorageService>().saveToken('test-token');
      CartBinding().dependencies();
      DashboardBinding().dependencies();
      CheckoutBinding().dependencies();
      await tester.pumpWidget(buildApp(AppRoutes.checkout));
      await tester.pump();
      expect(Get.isRegistered<CheckoutController>(), isTrue);
    });

    testWidgets('/product_detail initializes', (tester) async {
      await Get.find<StorageService>().saveToken('test-token');
      CartBinding().dependencies();
      ProductDetailBinding().dependencies();
      await tester.pumpWidget(buildApp(AppRoutes.productDetail));
      await tester.pump();
      expect(Get.isRegistered<ProductDetailController>(), isTrue);
    });

    testWidgets('/wallet_top_up initializes', (tester) async {
      await Get.find<StorageService>().saveToken('test-token');
      WalletBinding().dependencies();
      WalletTopUpBinding().dependencies();
      await tester.pumpWidget(buildApp(AppRoutes.walletTopUp));
      await tester.pump();
      expect(Get.isRegistered<WalletTopUpController>(), isTrue);
    });

    testWidgets('/order_external_payment initializes', (tester) async {
      await Get.find<StorageService>().saveToken('test-token');
      DashboardBinding().dependencies();
      OrderExternalPaymentBinding().dependencies();
      await tester.pumpWidget(buildApp(AppRoutes.orderExternalPayment));
      await tester.pump();
      expect(Get.isRegistered<OrderExternalPaymentController>(), isTrue);
    });

    testWidgets('/profile initializes', (tester) async {
      await Get.find<StorageService>().saveToken('test-token');
      WalletBinding().dependencies();
      ProfileBinding().dependencies();
      await tester.pumpWidget(buildApp(AppRoutes.profile));
      await tester.pump();
      expect(Get.isRegistered<ProfileController>(), isTrue);
    });

    testWidgets('/addresses initializes', (tester) async {
      await Get.find<StorageService>().saveToken('test-token');
      WalletBinding().dependencies();
      ProfileBinding().dependencies();
      ProfileAddressesBinding().dependencies();
      await tester.pumpWidget(buildApp(AppRoutes.addresses));
      await tester.pump();
      expect(Get.isRegistered<ProfileAddressesController>(), isTrue);
    });

    testWidgets('/personal_details initializes', (tester) async {
      await Get.find<StorageService>().saveToken('test-token');
      WalletBinding().dependencies();
      ProfileBinding().dependencies();
      ProfilePersonalDetailsBinding().dependencies();
      await tester.pumpWidget(buildApp(AppRoutes.personalDetails));
      await tester.pump();
      expect(Get.isRegistered<ProfilePersonalDetailsController>(), isTrue);
    });

    testWidgets('/payment_methods initializes', (tester) async {
      await Get.find<StorageService>().saveToken('test-token');
      WalletBinding().dependencies();
      ProfileBinding().dependencies();
      ProfilePaymentBinding().dependencies();
      await tester.pumpWidget(buildApp(AppRoutes.paymentMethods));
      await tester.pump();
      expect(Get.isRegistered<ProfilePaymentController>(), isTrue);
    });

    testWidgets('/wishlist initializes', (tester) async {
      await Get.find<StorageService>().saveToken('test-token');
      CartBinding().dependencies();
      ProfileWishlistBinding().dependencies();
      await tester.pumpWidget(buildApp(AppRoutes.wishlist));
      await tester.pump();
      expect(Get.isRegistered<ProfileWishlistController>(), isTrue);
    });
  });
}
