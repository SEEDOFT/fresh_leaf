# Storage

## Overview

FreshLeaf uses GetStorage for local data persistence. The storage service handles token storage, user preferences, and offline data caching.

## Storage Service

### Initialization

```dart
// lib/core/services/storage_service.dart
class StorageService extends GetxService {
  static StorageService get to => Get.find<StorageService>();
  
  late final GetStorage _storage;
  
  static const String _tokenKey = 'auth_token';
  static const String _userProfileKey = 'user_profile';
  static const String _localeKey = 'locale';
  static const String _seenOnboardingKey = 'seen_onboarding';
  static const String _cartKey = 'cart_items';
  static const String _pinVerifiedKey = 'pin_verified';
  
  Future<StorageService> init() async {
    await GetStorage.init();
    _storage = GetStorage();
    return this;
  }
}
```

## Storage Keys

### Authentication

```dart
// Token
String? get token => _storage.read(_tokenKey);
set token(String? value) => _storage.write(_tokenKey, value);

bool get hasToken => token != null && token!.isNotEmpty;

Future<void> saveToken(String token) async {
  await _storage.write(_tokenKey, token);
}

Future<void> clearToken() async {
  await _storage.remove(_tokenKey);
}

// User Profile
UserProfile? get userProfile {
  final data = _storage.read(_userProfileKey);
  if (data != null) {
    return UserProfile.fromMap(Map<String, dynamic>.from(data));
  }
  return null;
}

Future<void> setUserProfile(UserProfile profile) async {
  await _storage.write(_userProfileKey, profile.toMap());
}

Future<void> clearUserProfile() async {
  await _storage.remove(_userProfileKey);
}
```

### Preferences

```dart
// Locale
String? get locale => _storage.read(_localeKey);

Future<void> setLocale(String locale) async {
  await _storage.write(_localeKey, locale);
}

// Onboarding
bool get hasSeenOnboarding => _storage.read(_seenOnboardingKey) ?? false;

Future<void> setSeenOnboarding() async {
  await _storage.write(_seenOnboardingKey, true);
}
```

### PIN Verification

```dart
// PIN verified for order access
bool get pinOrderVerified => _storage.read(_pinVerifiedKey) ?? false;

Future<void> setPinOrderVerified(bool verified) async {
  await _storage.write(_pinVerifiedKey, verified);
}

Future<void> clearPinVerification() async {
  await _storage.remove(_pinVerifiedKey);
}
```

### Cart (Offline)

```dart
// Cart items stored locally
List<CartItem> get cartItems {
  final data = _storage.read(_cartKey);
  if (data != null) {
    return (data as List)
        .map((item) => CartItem.fromMap(Map<String, dynamic>.from(item)))
        .toList();
  }
  return [];
}

Future<void> setCartItems(List<CartItem> items) async {
  await _storage.write(
    _cartKey,
    items.map((item) => item.toMap()).toList(),
  );
}

Future<void> clearCart() async {
  await _storage.remove(_cartKey);
}
```

## Usage Examples

### Check Authentication State

```dart
// In splash controller
class SplashController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    _checkAuthState();
  }
  
  void _checkAuthState() async {
    final storage = Get.find<StorageService>();
    
    await Future.delayed(const Duration(seconds: 2));
    
    if (storage.hasToken) {
      // Token exists - go to dashboard
      Get.offAllNamed(AppRoutes.dashboard);
    } else if (!storage.hasSeenOnboarding) {
      // First time - show onboarding
      Get.offAllNamed(AppRoutes.onboarding);
    } else {
      // Show login
      Get.offAllNamed(AppRoutes.login);
    }
  }
}
```

### Update User Profile

```dart
// In profile controller after updating profile
Future<void> updateProfile(UserProfile updatedProfile) async {
  try {
    // Call API
    final response = await Get.find<ApiClient>().postRequest(
      ApiEndpoints.updateProfile,
      data: updatedProfile.toMap(),
    );
    
    if (response.statusCode == 200) {
      // Update local storage
      final newProfile = UserProfile.fromMap(response.data['data']);
      await Get.find<StorageService>().setUserProfile(newProfile);
      
      Get.snackbar('Success', 'Profile updated successfully');
    }
  } catch (e) {
    Get.snackbar('Error', 'Failed to update profile');
  }
}
```

### Persist Cart Offline

```dart
// When adding to cart
Future<void> addToCart(Product product, int quantity) async {
  final storage = Get.find<StorageService>();
  
  // Get existing items
  var items = storage.cartItems;
  
  // Check if product already exists
  final existingIndex = items.indexWhere((i) => i.productId == product.id);
  
  if (existingIndex >= 0) {
    // Update quantity
    items[existingIndex].quantity += quantity;
  } else {
    // Add new item
    items.add(CartItem(
      productId: product.id,
      productName: product.name,
      quantity: quantity,
      unitPrice: product.priceUsd,
      imageUrl: product.imageUrl,
    ));
  }
  
  // Save to storage
  await storage.setCartItems(items);
  
  // Also sync with API
  try {
    await Get.find<ApiClient>().postRequest(
      ApiEndpoints.addToCart,
      data: {
        'product_id': product.id,
        'quantity': quantity,
      },
    );
  } catch (e) {
    // API failed - cart is still saved locally
  }
}
```

## Clear All Storage

```dart
// When logging out
Future<void> logout() async {
  final storage = Get.find<StorageService>();
  
  // Clear all storage
  await storage.clearToken();
  await storage.clearUserProfile();
  await storage.clearCart();
  await storage.clearPinVerification();
  
  // Navigate to login
  Get.offAllNamed(AppRoutes.login);
}
```

## Encrypted Storage

For sensitive data like tokens, consider using flutter_secure_storage:

```dart
// lib/core/services/secure_storage_service.dart
class SecureStorageService {
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage(
    aOptions: AndroidOptions(
      encryptedSharedPreferences: true,
    ),
  );
  
  Future<void> saveToken(String token) async {
    await _secureStorage.write(key: 'auth_token', value: token);
  }
  
  Future<String?> getToken() async {
    return await _secureStorage.read(key: 'auth_token');
  }
  
  Future<void> deleteToken() async {
    await _secureStorage.delete(key: 'auth_token');
  }
}
```

---

## Related Files

- `lib/core/services/storage_service.dart` - Storage service
- `lib/app/modules/splash/` - Auth state checking
- `lib/shared/helpers/helper.dart` - Helper functions