# Modules

## Overview

The FreshLeaf app uses a modular architecture with GetX. Each feature is organized as a module with `controllers`, `views`, `widgets`, and `bindings`.

## Module Structure

```
module_name/
├── bindings/
│   └── module_name_binding.dart
├── controllers/
│   └── module_name_controller.dart
├── views/
│   └── module_name_view.dart
└── widgets/
    ├── widget_a.dart
    ├── widget_b.dart
    └── module_name_widgets.dart    # Barrel export
```

## All Modules

### Authentication Modules

#### Splash Module
- **Purpose**: App initialization with animated splash screen
- **Controller**: `splash_controller.dart`
- **View**: `splash_view.dart`
- **Route**: `/splash`
- **Key Features**:
  - Brand logo animation
  - Route resolution to onboarding, login, or dashboard

```dart
class SplashController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    _initializeApp();
  }
  
  Future<void> _initializeApp() async {
    await Future.delayed(const Duration(seconds: 2));
    // Navigate based on auth state
    Get.offAllNamed(AppRoutes.dashboard);
  }
}
```

#### Onboarding Module
- **Purpose**: First-time user introduction
- **Controller**: `onboarding_controller.dart`
- **View**: `onboarding_view.dart`
- **Route**: `/onboarding`
- **Key Features**:
  - Page indicator
  - Skip button
  - Animated transitions

#### Login Module
- **Purpose**: User authentication
- **Controller**: `login_controller.dart`
- **View**: `login_view.dart`
- **Route**: `/login`
- **Key Features**:
  - Phone + password login
  - Cambodia phone number normalization
  - Token storage via StorageService

```dart
class LoginController extends GetxController {
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();
  final isLoading = false.obs;
  
  Future<void> login() async {
    isLoading.value = true;
    try {
      final normalizedPhone = normalizeCambodiaPhoneForApi(
        phoneController.text,
      );
      
      final response = await Get.find<ApiClient>().postRequest(
        ApiEndpoints.login,
        data: {
          'phone': normalizedPhone,
          'password': passwordController.text,
        },
      );
      
      // Save token
      final token = response.data['token'];
      await Get.find<StorageService>().saveToken(token);
      
      // Navigate to dashboard
      Get.offAllNamed(AppRoutes.dashboard);
    } catch (e) {
      Get.snackbar('Error', parseApiErrorMessage(e));
    } finally {
      isLoading.value = false;
    }
  }
}
```

#### Register Module
- **Purpose**: New user registration
- **Controller**: `register_controller.dart`
- **View**: `register_view.dart`
- **Route**: `/register`

---

### Main Navigation

#### Dashboard Module
- **Purpose**: Main app shell with bottom navigation
- **Controller**: `dashboard_controller.dart`
- **View**: `dashboard_view.dart`
- **Route**: `/dashboard`
- **Key Features**:
  - 5 tab navigation (Home, Search, AI, Orders, Profile)
  - Tab controller persistence

```dart
class DashboardController extends GetxController {
  final currentIndex = 0.obs;
  
  void changePage(int index) {
    currentIndex.value = index;
  }
  
  // Navigation tabs
  static const int tabHome = 0;
  static const int tabSearch = 1;
  static const int tabAI = 2;
  static const int tabOrders = 3;
  static const int tabProfile = 4;
}
```

---

### Shopping Modules

#### Home Module
- **Purpose**: Home feed with products and categories
- **Controller**: `home_controller.dart`
- **View**: `home_view.dart`
- **Route**: `/home`
- **Key Features**:
  - Hero section
  - Category chips
  - Product highlights

```dart
class HomeController extends GetxController {
  final categories = <HomeCategory>[].obs;
  final products = <HomeProduct>[].obs;
  final isLoading = false.obs;
  final userLocation = Rxn<LocationData>();
  
  @override
  void onInit() {
    super.onInit();
    loadCategories();
    loadProducts();
  }
  
  Future<void> loadCategories() async {
    try {
      final response = await Get.find<CategoryService>().getCategories();
      categories.assignAll(response);
    } catch (e) {
      // Handle error
    }
  }
}
```

#### Search Module
- **Purpose**: Product search with filters
- **Controller**: `search_controller.dart`
- **View**: `search_view.dart`
- **Route**: `/search`
- **Key Features**:
  - Search field with debounce
  - Filter chips (category, price range)
  - Results list

#### Product Detail Module
- **Purpose**: Individual product page
- **Route**: `/product_detail/:id`
- **Key Features**:
  - Product images carousel
  - Price display (KHR/USD)
  - Quantity selector
  - Add to cart
  - Add to wishlist

#### Product List Module
- **Purpose**: Product listing page
- **Route**: `/product_list/:categoryId`
- **Key Features**:
  - Grid/list view toggle
  - Sort options
  - Pagination

#### Cart Module
- **Purpose**: Shopping cart
- **Controller**: `cart_controller.dart`
- **View**: `cart_view.dart`
- **Route**: `/cart`
- **Key Features**:
  - Quantity controls
  - Remove items
  - Cart summary
  - Proceed to checkout

```dart
class CartController extends GetxController {
  final cartItems = <CartItem>[].obs;
  final subtotal = 0.obs;
  final isLoading = false.obs;
  
  double get total => subtotal.value;
  
  void addItem(Product product, int quantity) {
    final index = cartItems.indexWhere((item) => item.productId == product.id);
    if (index >= 0) {
      cartItems[index].quantity += quantity;
    } else {
      cartItems.add(CartItem(product: product, quantity: quantity));
    }
    _calculateTotal();
  }
  
  void removeItem(String productId) {
    cartItems.removeWhere((item) => item.productId == productId);
    _calculateTotal();
  }
  
  void updateQuantity(String productId, int quantity) {
    final index = cartItems.indexWhere((item) => item.productId == productId);
    if (index >= 0) {
      cartItems[index].quantity = quantity;
      _calculateTotal();
    }
  }
}
```

#### Checkout Module
- **Purpose**: Order checkout process
- **Controller**: `checkout_controller.dart`
- **View**: `checkout_view.dart`
- **Route**: `/checkout`
- **Key Features**:
  - Address selection
  - Payment method selection
  - Order summary
  - Place order

---

### Order Modules

#### Orders Module
- **Purpose**: Order history
- **View**: `orders_view.dart`
- **Route**: `/orders`
- **Key Features**:
  - Filter tabs (Active, Completed, Cancelled)
  - Grouped by date
  - Order status display

#### Order Detail Module
- **Purpose**: Single order details
- **Route**: `/order_detail/:id`
- **Key Features**:
  - Order items list
  - Order status timeline
  - Delivery address
  - Payment info

---

### Profile Modules

#### Profile Module
- **Purpose**: User profile and settings
- **View**: `profile_view.dart`
- **Route**: `/profile`
- **Key Features**:
  - Profile stats
  - Quick actions (wishlist, addresses, payment methods)
  - Settings navigation

#### Address Management
- **Routes**: `/addresses`, `/addressesEdit`
- **Key Features**:
  - Map-based address picker (OpenStreetMap)
  - Search with Nominatim
  - Current location detection

#### Payment Methods
- **Routes**: `/paymentMethods`, `/paymentMethodsAdd`
- **Key Features**:
  - Card form with validation (Luhn, expiry, CVV)
  - Default method toggle
  - Remove action

#### Security Settings
- **Routes**: `/securitySettings`, `/pinSecurity`
- **Key Features**:
  - Password change
  - PIN set/update/reset

---

### Wallet Modules

#### Wallet Module
- **Purpose**: Digital wallet display
- **Controller**: `wallet_controller.dart`
- **View**: `wallet_view.dart`
- **Route**: `/wallet`
- **Key Features**:
  - Balance display (KHR/USD)
  - Transaction history
  - Quick actions

```dart
class WalletController extends GetxController {
  final wallets = <Wallet>[].obs;
  final transactions = <WalletTransaction>[].obs;
  final isLoading = false.obs;
  
  Wallet? get primaryWallet => wallets.isNotEmpty ? wallets.first : null;
  
  @override
  void onInit() {
    super.onInit();
    loadWallets();
  }
  
  Future<void> loadWallets() async {
    isLoading.value = true;
    try {
      final response = await Get.find<ApiClient>().getRequest(
        ApiEndpoints.userWallets,
      );
      wallets.assignAll(response.data.map((w) => Wallet.fromMap(w)));
    } finally {
      isLoading.value = false;
    }
  }
}
```

#### Wallet Top Up Module
- **Purpose**: Add funds to wallet
- **Controller**: `wallet_top_up_controller.dart`
- **View**: `wallet_top_up_view.dart`
- **Route**: `/walletTopUp`
- **Key Features**:
  - Amount presets
  - Custom amount input

#### Wallet Top Up Payment Module
- **Purpose**: Payment for top-up
- **View**: `wallet_top_up_payment_view.dart`
- **Route**: `/walletTopUpPayment`
- **Key Features**:
  - Payment method selection

---

### AI & Support Modules

#### AI Assistant Module
- **Purpose**: AI-powered shopping assistant
- **Controller**: `ai_assistant_controller.dart`
- **View**: `ai_assistant_view.dart`
- **Route**: `/ai_assistant`
- **Key Features**:
  - Real-time streaming responses
  - Message persistence
  - Product recommendations

```dart
class AiAssistantController extends GetxController {
  final messages = <AiChatMessage>[].obs;
  final isStreaming = false.obs;
  final isTyping = false.obs;
  final currentSession = Rxn<AiChatSession>();
  
  final messageController = TextEditingController();
  
  Future<void> sendMessage(String text) async {
    if (text.trim().isEmpty) return;
    
    // Add user message
    messages.add(AiChatMessage(
      content: text,
      isUser: true,
    ));
    
    // Clear input
    messageController.clear();
    
    // Start streaming response
    isStreaming.value = true;
    
    try {
      // Send to API and listen for real-time events
      await Get.find<AiAssistantApiService>().sendMessage(
        sessionId: currentSession.value?.sessionId,
        message: text,
      );
    } catch (e) {
      Get.snackbar('Error', 'Failed to send message');
    } finally {
      isStreaming.value = false;
    }
  }
}
```

#### Support Chat Module
- **Purpose**: Customer support chat
- **Controller**: `support_chat_controller.dart`
- **View**: `support_chat_view.dart`
- **Route**: `/supportChat`
- **Key Features**:
  - Real-time message sync
  - Typing indicators
  - File attachments

---

### Notifications Module
- **Purpose**: Push notification center
- **Controller**: `notifications_controller.dart`
- **View**: `notifications_view.dart`
- **Route**: `/notifications`
- **Key Features**:
  - Notification list
  - Unread badge
  - Detail view

---

## Module Creation Pattern

### 1. Create Controller

```dart
// lib/app/modules/example/controllers/example_controller.dart
class ExampleController extends GetxController {
  final data = <dynamic>[].obs;
  
  void loadData() async {
    // Load data
  }
}
```

### 2. Create Binding

```dart
// lib/app/modules/example/bindings/example_binding.dart
class ExampleBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ExampleController>(() => ExampleController());
  }
}
```

### 3. Create View

```dart
// lib/app/modules/example/views/example_view.dart
class ExampleView extends GetView<ExampleController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() => ListView.builder(
        itemCount: controller.data.length,
        itemBuilder: (context, index) => Text(controller.data[index].toString()),
      )),
    );
  }
}
```

### 4. Register Route

```dart
// lib/app/routes/app_routes.dart
abstract class AppRoutes {
  static const example = '/example';
}

// lib/app/routes/app_pages.dart
GetPage(
  name: AppRoutes.example,
  page: () => const ExampleView(),
  binding: ExampleBinding(),
),
```

---

## Related Files

- `lib/app/routes/app_routes.dart` - Route definitions
- `lib/app/routes/app_pages.dart` - Page registrations
- `documentations/development_summary.md` - Module details