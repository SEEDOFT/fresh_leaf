# Routing

## Overview

FreshLeaf uses GetX for navigation with named routes. Routes are defined in `app_routes.dart` and registered in `app_pages.dart`.

## Route Definitions

```dart
// lib/app/routes/app_routes.dart
abstract class AppRoutes {
  static const splash = '/splash';
  static const onboarding = '/onboarding';
  static const networkCheck = '/network-check';
  static const login = '/login';
  static const register = '/register';
  static const dashboard = '/dashboard';
  static const home = '/home';
  static const search = '/search';
  static const productDetail = '/product-detail';
  static const productList = '/product-list';
  static const cart = '/cart';
  static const checkout = '/checkout';
  static const orders = '/orders';
  static const orderDetail = '/order-detail';
  static const profile = '/profile';
  static const personalDetails = '/personal-details';
  static const settings = '/settings';
  static const securitySettings = '/security-settings';
  static const pinSecurity = '/pin-security';
  static const addresses = '/addresses';
  static const addressesEdit = '/addresses-edit';
  static const wishlist = '/wishlist';
  static const paymentMethods = '/payment-methods';
  static const paymentMethodsAdd = '/payment-methods-add';
  static const wallet = '/wallet';
  static const walletTopUp = '/wallet-top-up';
  static const walletTopUpPayment = '/wallet-top-up-payment';
  static const aiAssistant = '/ai-assistant';
  static const supportChat = '/support-chat';
  static const notifications = '/notifications';
}
```

## Page Registration

```dart
// lib/app/routes/app_pages.dart
class AppPages {
  static final routes = <GetPage>[
    GetPage(
      name: AppRoutes.splash,
      page: () => const SplashView(),
      binding: SplashBinding(),
    ),
    GetPage(
      name: AppRoutes.onboarding,
      page: () => const OnboardingView(),
      binding: OnboardingBinding(),
    ),
    GetPage(
      name: AppRoutes.login,
      page: () => const LoginView(),
      binding: LoginBinding(),
      middlewares: [OnboardingMiddleware()],
    ),
    GetPage(
      name: AppRoutes.register,
      page: () => const RegisterView(),
      binding: RegisterBinding(),
    ),
    GetPage(
      name: AppRoutes.dashboard,
      page: () => const DashboardView(),
      binding: DashboardBinding(),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: AppRoutes.home,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: AppRoutes.search,
      page: () => const SearchView(),
      binding: SearchBinding(),
    ),
    // ... more routes
  ];
}
```

## Navigation Methods

### Basic Navigation

```dart
// Navigate to a route
Get.toNamed(AppRoutes.login);

// Navigate and replace current page
Get.offNamed(AppRoutes.dashboard);

// Navigate and clear all previous pages
Get.offAllNamed(AppRoutes.splash);

// Go back
Get.back();

// Go back with result
Get.back(result: 'success');
```

### With Arguments

```dart
// Pass arguments
Get.toNamed(
  AppRoutes.productDetail,
  arguments: {'productId': 123},
);

// Receive arguments in controller
class ProductDetailController extends GetxController {
  final productId = Get.arguments['productId'] as int;
}
```

### Route Parameters

```dart
// Define route with parameters
GetPage(
  name: '/product/${product.id}',
  page: () => ProductDetailView(),
);

// Navigate with parameters
Get.toNamed('/product/123');

// Or use dynamic name
Get.toNamed('/product/${product.id}');
```

## Middlewares

### Auth Middleware

```dart
// lib/app/middlewares/auth_middleware.dart
class AuthMiddleware extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route) {
    final storage = Get.find<StorageService>();
    
    if (!storage.hasToken) {
      return const RouteSettings(name: AppRoutes.login);
    }
    
    return null;
  }
}
```

### Onboarding Middleware

```dart
// lib/app/middlewares/onboarding_middleware.dart
class OnboardingMiddleware extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route) {
    final storage = Get.find<StorageService>();
    
    if (!storage.hasSeenOnboarding) {
      return const RouteSettings(name: AppRoutes.onboarding);
    }
    
    return null;
  }
}
```

### Profile Sync Middleware

```dart
// lib/app/middlewares/profile_sync_middleware.dart
class ProfileSyncMiddleware extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route) async {
    final storage = Get.find<StorageService>();
    
    // Sync profile if not stored
    if (storage.userProfile == null) {
      try {
        final apiClient = Get.find<ApiClient>();
        final response = await apiClient.getRequest(ApiEndpoints.userProfile);
        
        if (response.statusCode == 200) {
          final profile = UserProfile.fromMap(response.data);
          await storage.setUserProfile(profile);
        }
      } catch (e) {
        // Handle error - redirect to login
        return const RouteSettings(name: AppRoutes.login);
      }
    }
    
    return null;
  }
}
```

## Route Guards

### Using GetX Guard

```dart
// Protect routes
GetPage(
  name: '/protected',
  page: () => ProtectedView(),
  middlewares: [
    AuthMiddleware(),
    ProfileSyncMiddleware(),
  ],
);
```

## Named Routes with Middlewares

```dart
// Group routes with common middleware
RouteMiddleware(
  middleware: AuthMiddleware(),
  bindings: [
    GetPage(
      name: AppRoutes.home,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: AppRoutes.cart,
      page: () => const CartView(),
      binding: CartBinding(),
    ),
  ],
)
```

## Bottom Navigation

```dart
// Dashboard controller manages bottom nav
class DashboardController extends GetxController {
  final currentIndex = 0.obs;
  
  final tabs = [
    AppRoutes.home,
    AppRoutes.search,
    AppRoutes.aiAssistant,
    AppRoutes.orders,
    AppRoutes.profile,
  ];
  
  void changePage(int index) {
    currentIndex.value = index;
    Get.toNamed(tabs[index]);
  }
}

// In dashboard view
BottomNavigationBar(
  currentIndex: controller.currentIndex.value,
  onTap: controller.changePage,
  items: const [
    BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
    BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
    BottomNavigationBarItem(icon: Icon(Icons.chat), label: 'AI'),
    BottomNavigationBarItem(icon: Icon(Icons.receipt), label: 'Orders'),
    BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
  ],
)
```

---

## Related Files

- `lib/app/app.dart` - App widget with GetMaterialApp
- `lib/app/middlewares/` - Middleware implementations
- `documentations/development_summary.md` - Module details