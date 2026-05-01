# Authentication

## Overview

FreshLeaf implements comprehensive authentication including login, registration, and PIN security for order verification.

## Authentication Flow

```
┌─────────────────┐
│   Splash View   │
│  Check Token    │
└────────┬────────┘
         │
    ┌────▼────┐
    │ Token   │──Yes──► Dashboard
    │ Exists? │
    └────┬────┘
         │ No
    ┌────▼────┐
    │Onboarding│──Yes──► Onboarding
    │ Seen?    │
    └────┬────┘
         │ No
    ┌────▼────┐
    │  Login  │
    │  View   │
    └─────────┘
```

## Login

### Login Controller

```dart
// lib/app/modules/login/controllers/login_controller.dart
class LoginController extends GetxController {
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();
  final isLoading = false.obs;
  final showPassword = false.obs;
  
  @override
  void onClose() {
    phoneController.dispose();
    passwordController.dispose();
    super.onClose();
  }
  
  Future<void> login() async {
    // Validate input
    if (phoneController.text.isEmpty || passwordController.text.isEmpty) {
      Get.snackbar('Error', 'Please fill in all fields');
      return;
    }
    
    isLoading.value = true;
    
    try {
      // Normalize Cambodia phone number
      final normalizedPhone = normalizeCambodiaPhoneForApi(
        phoneController.text,
      );
      
      // Call API
      final response = await Get.find<ApiClient>().postRequest(
        ApiEndpoints.login,
        data: {
          'phone': normalizedPhone,
          'password': passwordController.text,
        },
      );
      
      // Parse response
      final apiResponse = ApiResponse.parseMap(response.data);
      
      if (apiResponse.isSuccess) {
        // Save token
        final token = apiResponse.data['token'];
        await Get.find<StorageService>().saveToken(token);
        
        // Update API client auth header
        Get.find<ApiClient>().updateToken(token);
        
        // Fetch and save user profile
        await _syncUserProfile();
        
        // Upload FCM token
        await _uploadFcmToken();
        
        // Navigate to dashboard
        Get.offAllNamed(AppRoutes.dashboard);
      } else {
        Get.snackbar('Error', apiResponse.status.message);
      }
    } catch (e) {
      Get.snackbar('Error', parseApiErrorMessage(e));
    } finally {
      isLoading.value = false;
    }
  }
  
  Future<void> _syncUserProfile() async {
    try {
      final response = await Get.find<ApiClient>().getRequest(
        ApiEndpoints.userProfile,
      );
      final profile = UserProfile.fromMap(response.data);
      await Get.find<StorageService>().setUserProfile(profile);
    } catch (e) {
      // Profile sync failed - continue anyway
    }
  }
  
  Future<void> _uploadFcmToken() async {
    try {
      final fcmToken = await FirebaseMessaging.instance.getToken();
      if (fcmToken != null) {
        await Get.find<ApiClient>().postRequest(
          ApiEndpoints.userDevices,
          data: {'device_token': fcmToken},
        );
      }
    } catch (e) {
      // FCM token upload failed - continue anyway
    }
  }
}
```

### Login View

```dart
// lib/app/modules/login/views/login_view.dart
class LoginView extends GetView<LoginController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              // Logo
              const SizedBox(height: 60),
              Image.asset('assets/logo/fresh_leaf.png'),
              const SizedBox(height: 40),
              
              // Form
              Expanded(
                child: LoginFormContentWidget(
                  phoneController: controller.phoneController,
                  passwordController: controller.passwordController,
                  onLogin: controller.login,
                  isLoading: controller.isLoading,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
```

## Registration

```dart
// lib/app/modules/register/controllers/register_controller.dart
class RegisterController extends GetxController {
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  
  final isLoading = false.obs;
  final agreeToTerms = false.obs;
  
  Future<void> register() async {
    // Validation
    if (!_validateInput()) return;
    
    isLoading.value = true;
    
    try {
      final normalizedPhone = normalizeCambodiaPhoneForApi(
        phoneController.text,
      );
      
      final response = await Get.find<ApiClient>().postRequest(
        ApiEndpoints.register,
        data: {
          'first_name': firstNameController.text,
          'last_name': lastNameController.text,
          'phone': normalizedPhone,
          'password': passwordController.text,
          'password_confirmation': confirmPasswordController.text,
        },
      );
      
      final apiResponse = ApiResponse.parseMap(response.data);
      
      if (apiResponse.isSuccess) {
        // Auto-login after registration
        final token = apiResponse.data['token'];
        await Get.find<StorageService>().saveToken(token);
        
        Get.offAllNamed(AppRoutes.dashboard);
      } else {
        Get.snackbar('Error', apiResponse.status.message);
      }
    } catch (e) {
      Get.snackbar('Error', parseApiErrorMessage(e));
    } finally {
      isLoading.value = false;
    }
  }
  
  bool _validateInput() {
    if (firstNameController.text.isEmpty ||
        lastNameController.text.isEmpty ||
        phoneController.text.isEmpty ||
        passwordController.text.isEmpty) {
      Get.snackbar('Error', 'Please fill in all fields');
      return false;
    }
    
    if (passwordController.text != confirmPasswordController.text) {
      Get.snackbar('Error', 'Passwords do not match');
      return false;
    }
    
    if (!agreeToTerms.value) {
      Get.snackbar('Error', 'Please agree to terms and conditions');
      return false;
    }
    
    return true;
  }
}
```

## PIN Security

PIN security provides quick order verification without password.

### PIN Flow

```
1. User has set_pin = false:
   - Verify password before setting first PIN
   
2. User has set_pin = true:
   - Update PIN using current PIN (no password needed)
   
3. Forgot PIN:
   - Reset by verifying password
```

### PIN Security Service

```dart
// lib/core/services/pin_security_service.dart
class PinSecurityService extends GetxService {
  final ApiClient _apiClient = Get.find<ApiClient>();
  final StorageService _storage = Get.find<StorageService>();
  
  bool get hasPinSet => _storage.userProfile?.setPin ?? false;
  
  Future<bool> setPin(String pin) async {
    try {
      final response = await _apiClient.postRequest(
        ApiEndpoints.setPin,
        data: {'pin': pin},
      );
      
      if (response.statusCode == 200) {
        await _storage.setUserProfile(
          _storage.userProfile!.copyWith(setPin: true),
        );
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }
  
  Future<bool> verifyPin(String pin) async {
    try {
      final response = await _apiClient.postRequest(
        ApiEndpoints.verifyPin,
        data: {'pin': pin},
      );
      
      if (response.statusCode == 200) {
        await _storage.setPinOrderVerified(true);
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }
  
  Future<bool> updatePin(String currentPin, String newPin) async {
    try {
      final response = await _apiClient.postRequest(
        ApiEndpoints.updatePin,
        data: {
          'current_pin': currentPin,
          'new_pin': newPin,
        },
      );
      
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }
  
  Future<bool> resetPin(String newPin, String password) async {
    try {
      // First verify password
      final verifyResponse = await _apiClient.postRequest(
        ApiEndpoints.verifyPassword,
        data: {'password': password},
      );
      
      if (verifyResponse.statusCode != 200) {
        return false;
      }
      
      // Then reset PIN
      final resetResponse = await _apiClient.postRequest(
        ApiEndpoints.resetPin,
        data: {'pin': newPin},
      );
      
      return resetResponse.statusCode == 200;
    } catch (e) {
      return false;
    }
  }
  
  void clearVerification() {
    _storage.setPinOrderVerified(false);
  }
}
```

### PIN Verification in Order Access

```dart
// Using PIN to access orders
Future<void> openOrders() async {
  if (!Get.find<PinSecurityService>().hasPinSet) {
    Get.toNamed(AppRoutes.pinSecurity);
    return;
  }
  
  if (!Get.find<PinSecurityService>().pinOrderVerified) {
    // Show PIN dialog
    await _showPinDialog();
    return;
  }
  
  Get.toNamed(AppRoutes.orders);
}

Future<void> _showPinDialog() async {
  // Show dialog to verify PIN
  final pin = await Get.dialog<String>(
    PinVerificationDialog(),
  );
  
  if (pin != null) {
    final success = await Get.find<PinSecurityService>().verifyPin(pin);
    if (success) {
      Get.toNamed(AppRoutes.orders);
    }
  }
}
```

## API Endpoints

| Endpoint | Method | Description |
|----------|--------|--------------|
| `/user/auth/login` | POST | User login |
| `/user/auth/register` | POST | User registration |
| `/user/auth/logout` | POST | User logout |
| `/user/auth/password/verify` | POST | Verify password |
| `/user/auth/password/update` | POST | Update password |
| `/user/pin/set` | POST | Set PIN |
| `/user/pin/update` | POST | Update PIN |
| `/user/pin/reset` | POST | Reset PIN |
| `/user/pin/verify` | POST | Verify PIN |

## Helper Functions

```dart
// lib/shared/helpers/helper.dart

/// Normalize Cambodia phone number for API
/// Input: +855 12 345 678, 012345678, 85512345678
/// Output: 85512345678
String normalizeCambodiaPhoneForApi(String phone) {
  // Remove spaces and +855 prefix
  var cleaned = phone.replaceAll(RegExp(r'\s+'), '').replaceAll('+855', '');
  
  // If starts with 0, remove it
  if (cleaned.startsWith('0')) {
    cleaned = cleaned.substring(1);
  }
  
  return cleaned;
}

/// Parse API error message
String parseApiErrorMessage(dynamic error) {
  if (error is DioException) {
    if (error.response?.data != null) {
      return error.response?.data['message'] ?? 
             error.response?.data['error'] ?? 
             'Unknown error';
    }
    return error.message ?? 'Connection error';
  }
  return 'Unknown error';
}
```

---

## Related Files

- `lib/core/services/storage_service.dart` - Token storage
- `lib/core/services/pin_security_service.dart` - PIN service
- `lib/shared/helpers/helper.dart` - Helper functions
- `lib/core/constants/api_endpoints.dart` - API endpoints