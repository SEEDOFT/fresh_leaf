# Project Overview

## Overview

FreshLeaf is a B2C mobile application built with Flutter and GetX for consumers to purchase organic vegetables from registered vendors. The app features a complete e-commerce flow including authentication, product browsing, cart management, checkout, order tracking, wallet system, AI assistant, and customer support chat.

## Tech Stack

| Technology | Version | Purpose |
|------------|---------|---------|
| Flutter | stable | UI Framework |
| Dart | ^3.9.0 | Language |
| GetX | Latest | State management, routing, DI |
| Dio | Latest | HTTP client |
| GetStorage | Latest | Local persistence |
| Firebase | Latest | Push notifications |
| Flutter Map | Latest | Maps/address picker |
| Geolocator | Latest | Location services |

## Project Structure

```
fresh_leaf/
├── lib/
│   ├── app/
│   │   ├── modules/                    # Feature modules (GetX)
│   │   │   ├── splash/
│   │   │   ├── onboarding/
│   │   │   ├── login/
│   │   │   ├── register/
│   │   │   ├── dashboard/
│   │   │   ├── home/
│   │   │   ├── search/
│   │   │   ├── product_detail/
│   │   │   ├── product_list/
│   │   │   ├── cart/
│   │   │   ├── checkout/
│   │   │   ├── orders/
│   │   │   ├── order_detail/
│   │   │   ├── profile/
│   │   │   ├── wallet/
│   │   │   ├── wallet_top_up/
│   │   │   ├── wallet_top_up_payment/
│   │   │   ├── ai_assistant/
│   │   │   ├── support_chat/
│   │   │   └── notifications/
│   │   ├── routes/                      # Navigation
│   │   │   ├── app_routes.dart          # Route names
│   │   │   └── app_pages.dart           # Page definitions
│   │   ├── middlewares/                 # Route middleware
│   │   │   ├── auth_middleware.dart
│   │   │   └── profile_sync_middleware.dart
│   │   └── app.dart                     # App widget
│   ├── core/
│   │   ├── services/                    # Core services
│   │   │   ├── api_client.dart          # HTTP client
│   │   │   ├── storage_service.dart     # Token storage
│   │   │   ├── product_service.dart     # Product API
│   │   │   ├── category_service.dart    # Category API
│   │   │   ├── notification_service.dart # FCM
│   │   │   ├── ai_assistant_api_service.dart
│   │   │   ├── ai_assistant_realtime_service.dart
│   │   │   ├── support_realtime_service.dart
│   │   │   ├── pin_security_service.dart
│   │   │   └── ...
│   │   ├── models/                      # Data models
│   │   │   ├── user_profile.dart
│   │   │   ├── organic_product.dart
│   │   │   ├── order.dart
│   │   │   ├── wallet.dart
│   │   │   ├── ai_chat_message.dart
│   │   │   └── ...
│   │   ├── config/
│   │   │   └── app_config.dart          # Environment config
│   │   ├── constants/
│   │   │   ├── api_endpoints.dart       # API URLs
│   │   │   └── app_constants.dart
│   │   ├── theme/
│   │   │   ├── app_theme.dart
│   │   │   ├── app_colors.dart
│   │   │   └── app_text_styles.dart
│   │   ├── localization/
│   │   │   ├── translations_en.dart
│   │   │   └── translations_km.dart
│   │   └── bootstrap/
│   │       └── app_bootstrap.dart       # App initialization
│   └── shared/
│       ├── widgets/                      # Reusable widgets
│       ├── helpers/                     # Utility functions
│       └── fixtures/                     # Mock data
├── documentations/                       # Existing docs
├── android/                              # Android config
├── ios/                                  # iOS config
├── pubspec.yaml                          # Dependencies
└── .fvmrc                                # Flutter version
```

## Module Structure Pattern

Each GetX module follows this pattern:

```dart
// Module directory structure
module_name/
├── bindings/
│   └── module_name_binding.dart     # DI setup
├── controllers/
│   └── module_name_controller.dart   # Business logic
├── views/
│   └── module_name_view.dart          # Main UI
└── widgets/
    ├── widget_a.dart
    ├── widget_b.dart
    └── module_name_widgets.dart      # Barrel export
```

### Example: Controller

```dart
// lib/app/modules/home/controllers/home_controller.dart
class HomeController extends GetxController {
  // Reactive variables
  final categories = <HomeCategory>[].obs;
  final products = <HomeProduct>[].obs;
  final isLoading = false.obs;
  
  @override
  void onInit() {
    super.onInit();
    loadData();
  }
  
  Future<void> loadData() async {
    isLoading.value = true;
    try {
      // Load data from service
      final response = await Get.find<CategoryService>().getCategories();
      categories.assignAll(response);
    } catch (e) {
      // Handle error
    } finally {
      isLoading.value = false;
    }
  }
}
```

### Example: Binding

```dart
// lib/app/modules/home/bindings/home_binding.dart
class HomeBinding extends Bindings {
  @override
  void dependencies() {
    // Register controller
    Get.lazyPut<HomeController>(() => HomeController());
    
    // Register services if needed
    if (!Get.isRegistered<CategoryService>()) {
      Get.lazyPut<CategoryService>(() => CategoryService());
    }
  }
}
```

### Example: View

```dart
// lib/app/modules/home/views/home_view.dart
class HomeView extends GetView<HomeController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        return ListView.builder(
          itemCount: controller.products.length,
          itemBuilder: (context, index) {
            return ProductCard(product: controller.products[index]);
          },
        );
      }),
    );
  }
}
```

### Example: Route Registration

```dart
// lib/app/routes/app_routes.dart
abstract class AppRoutes {
  static const splash = '/splash';
  static const login = '/login';
  static const home = '/home';
  // ... more routes
}

// lib/app/routes/app_pages.dart
class AppPages {
  static final routes = [
    GetPage(
      name: AppRoutes.splash,
      page: () => const SplashView(),
      binding: SplashBinding(),
    ),
    GetPage(
      name: AppRoutes.login,
      page: () => const LoginView(),
      binding: LoginBinding(),
    ),
    // ... more pages
  ];
}
```

## Key Services

### ApiClient (HTTP Client)

```dart
// lib/core/services/api_client.dart
class ApiClient {
  final Dio _dio;
  
  ApiClient() {
    _dio = Dio(BaseOptions(
      baseUrl: AppConfig.apiUrl,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
    ));
    
    // Add interceptors
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        // Add auth token
        final token = Get.find<StorageService>().token;
        if (token != null) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        return handler.next(options);
      },
      onError: (error, handler) {
        // Handle errors globally
        return handler.next(error);
      },
    ));
  }
  
  // GET request
  Future<Response> getRequest(
    String path, {
    Map<String, dynamic>? queryParameters,
  }) async {
    return _dio.get(path, queryParameters: queryParameters);
  }
  
  // POST request
  Future<Response> postRequest(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
  }) async {
    return _dio.post(path, data: data, queryParameters: queryParameters);
  }
}
```

### StorageService (Token Management)

```dart
// lib/core/services/storage_service.dart
class StorageService extends GetxService {
  final GetStorage _storage = GetStorage();
  
  // Token management
  String? get token => _storage.read('access_token');
  
  Future<void> saveToken(String token) async {
    await _storage.write('access_token', token);
  }
  
  Future<void> clearToken() async {
    await _storage.remove('access_token');
  }
  
  // User profile
  UserProfile? get userProfile {
    final data = _storage.read('user_profile');
    if (data != null) {
      return UserProfile.fromMap(data);
    }
    return null;
  }
  
  Future<void> setUserProfile(UserProfile profile) async {
    await _storage.write('user_profile', profile.toMap());
  }
  
  // Onboarding
  bool get hasSeenOnboarding => _storage.read('onboarding_seen') ?? false;
  Future<void> setOnboardingSeen() async {
    await _storage.write('onboarding_seen', true);
  }
}
```

## State Management (GetX)

### Reactive Variables

```dart
// Simple reactive
final count = 0.obs;

// List reactive
final items = <String>[].obs;

// Object reactive
final user = Rxn<User>();
```

### Obx Widget

```dart
Obx(() => Text('Count: ${controller.count.value}'));

// In ListView
Obx(() => ListView.builder(
  itemCount: controller.items.length,
  itemBuilder: (context, index) => Text(controller.items[index]),
));
```

### GetxController Lifecycle

```dart
class MyController extends GetxController {
  // Called when controller is initialized
  @override
  void onInit() {
    super.onInit();
    // Load initial data
  }
  
  // Called when controller is ready
  @override
  void onReady() {
    super.onReady();
    // UI is ready
  }
  
  // Called when controller is deleted
  @override
  void onClose() {
    // Clean up resources
    super.onClose();
  }
}
```

## Configuration

### Environment Variables

```dart
// .env.local
API_URL=http://10.0.2.2:8000/api/v1
REVERB_WS_SCHEME=ws
REVERB_WS_HOST=10.0.2.2
REVERB_WS_PORT=8080
```

### App Config

```dart
// lib/core/config/app_config.dart
class AppConfig {
  static String get apiUrl => const String.fromEnvironment('API_URL');
  static String get reverbWsScheme => const String.fromEnvironment('REVERB_WS_SCHEME');
  static String get reverbWsHost => const String.fromEnvironment('REVERB_WS_HOST');
  static int get reverbWsPort => int.tryParse(const String.fromEnvironment('REVERB_WS_PORT')) ?? 8080;
}
```

## Running the App

### Development
```bash
# Using FVM
fvm flutter run --dart-define-from-file=.env.local

# Or directly
flutter run --dart-define-from-file=.env.local
```

### Build
```bash
# Debug APK
flutter build apk --debug --dart-define-from-file=.env.local

# Release APK
flutter build apk --release --dart-define-from-file=.env.local
```

## Related Files

- `pubspec.yaml` - Dependencies
- `.fvmrc` - Flutter version
- `analysis_options.yaml` - Linting rules
- `documentations/VERY_GOOD_RULES.md` - Code standards