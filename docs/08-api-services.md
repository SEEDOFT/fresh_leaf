# API Services

## Overview

FreshLeaf uses a centralized API client that handles all HTTP requests, authentication, error handling, and response parsing.

## Architecture

```
lib/core/services/
├── api_client.dart        # Main HTTP client
├── storage_service.dart   # Local storage
└── api_endpoints.dart    # All API endpoints
```

## API Client

### Initialization

```dart
// lib/core/services/api_client.dart
class ApiClient extends GetxService {
  late final Dio _dio;
  String? _token;
  
  Future<ApiClient> init() async {
    _dio = Dio(
      BaseOptions(
        baseUrl: ApiConfig.baseUrl,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );
    
    // Add interceptors
    _dio.interceptors.addAll([
      AuthInterceptor(this),
      LoggingInterceptor(),
    ]);
    
    return this;
  }
}
```

### Request Methods

```dart
// GET request
Future<Response> getRequest(
  String path, {
  Map<String, dynamic>? queryParameters,
  Options? options,
});

// POST request
Future<Response> postRequest(
  String path, {
  dynamic data,
  Map<String, dynamic>? queryParameters,
  Options? options,
});

// POST with file upload (multipart)
Future<Response<Map<String, dynamic>>> postMultipart(
  String path, {
  required FormData data,
  ProgressCallback? onSendProgress,
  ProgressCallback? onReceiveProgress,
});

// PUT request
Future<Response> putRequest(
  String path, {
  dynamic data,
  Map<String, dynamic>? queryParameters,
  Options? options,
});

// DELETE request
Future<Response> deleteRequest(
  String path, {
  dynamic data,
  Map<String, dynamic>? queryParameters,
  Options? options,
});

// External request (for third-party APIs like geocoding)
Future<Response<T>> externalRequest<T>(
  String url, {
  String method = 'GET',
  dynamic data,
  Map<String, dynamic>? queryParameters,
  Options? options,
  CancelToken? cancelToken,
});
```

### Usage Example

```dart
// Fetch user profile
final response = await Get.find<ApiClient>().getRequest(
  ApiEndpoints.userProfile,
);

if (response.statusCode == 200) {
  final profile = UserProfile.fromMap(response.data['data']);
  // Handle success
}

// Login
final response = await Get.find<ApiClient>().postRequest(
  ApiEndpoints.login,
  data: {
    'phone': '12345678',
    'password': 'password123',
  },
);
```

## Interceptors

### Auth Interceptor

```dart
// lib/core/interceptors/auth_interceptor.dart
class AuthInterceptor extends Interceptor {
  final ApiClient _apiClient;

  AuthInterceptor(this._apiClient);

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // Add auth token if available
    if (_apiClient.hasToken) {
      options.headers['Authorization'] = 'Bearer ${_apiClient.token}';
    }
    
    // Add language header
    final storage = Get.find<StorageService>();
    options.headers['Accept-Language'] = storage.locale ?? 'en';
    
    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    // Handle 401 - Unauthorized
    if (err.response?.statusCode == 401) {
      // Clear token and redirect to login
      Get.find<StorageService>().clearToken();
      Get.offAllNamed(AppRoutes.login);
    }
    
    handler.next(err);
  }
}
```

### Logging Interceptor

```dart
// lib/core/interceptors/logging_interceptor.dart
class LoggingInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    print('┌─────────────────────────────────────');
    print('│ REQUEST: ${options.method} ${options.uri}');
    print('│ Headers: ${options.headers}');
    if (options.data != null) {
      print('│ Body: ${options.data}');
    }
    print('└─────────────────────────────────────');
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    print('┌─────────────────────────────────────');
    print('│ RESPONSE: ${response.statusCode} ${response.requestOptions.uri}');
    print('│ Data: ${response.data}');
    print('└─────────────────────────────────────');
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    print('┌─────────────────────────────────────');
    print('│ ERROR: ${err.response?.statusCode} ${err.requestOptions.uri}');
    print('│ Message: ${err.message}');
    if (err.response?.data != null) {
      print('│ Response: ${err.response?.data}');
    }
    print('└─────────────────────────────────────');
    handler.next(err);
  }
}
```

## API Endpoints

### Authentication

```dart
// lib/core/constants/api_endpoints.dart
abstract class ApiEndpoints {
  // Auth
  static const String login = '/user/auth/login';
  static const String register = '/user/auth/register';
  static const String logout = '/user/auth/logout';
  static const String verifyPassword = '/user/auth/password/verify';
  static const String updatePassword = '/user/auth/password/update';
  
  // PIN
  static const String setPin = '/user/pin/set';
  static const String updatePin = '/user/pin/update';
  static const String resetPin = '/user/pin/reset';
  static const String verifyPin = '/user/pin/verify';
  
  // User
  static const String userProfile = '/user/profile';
  static const String updateProfile = '/user/profile/update';
  static const String userDevices = '/user/devices';
  static const String userAddress = '/user/addresses';
  static const String userAddressDefault = '/user/addresses/default';
}
```

### Products

```dart
abstract class ApiEndpoints {
  // Home
  static const String homeProducts = '/products/home';
  static const String homeCategories = '/categories/home';
  
  // Products
  static const String products = '/products';
  static const String productDetail = '/products/{id}';
  static const String productReviews = '/products/{id}/reviews';
  
  // Organic Products
  static const String organicProducts = '/organic-products';
  static const String organicProductDetail = '/organic-products/{id}';
  
  // Search
  static const String search = '/products/search';
  static const String searchSuggestions = '/products/search/suggestions';
  
  // Wishlist
  static const String wishlist = '/user/wishlist';
  static const String addToWishlist = '/user/wishlist/{productId}';
  static const String removeFromWishlist = '/user/wishlist/{productId}';
}
```

### Cart

```dart
abstract class ApiEndpoints {
  static const String cart = '/user/cart';
  static const String addToCart = '/user/cart/add';
  static const String updateCartItem = '/user/cart/update/{itemId}';
  static const String removeFromCart = '/user/cart/remove/{itemId}';
  static const String clearCart = '/user/cart/clear';
}
```

### Orders

```dart
abstract class ApiEndpoints {
  static const String orders = '/user/orders';
  static const String orderDetail = '/user/orders/{id}';
  static const String createOrder = '/user/orders/create';
  static const String cancelOrder = '/user/orders/{id}/cancel';
  static const String orderReview = '/user/orders/{id}/review';
}
```

### Payments

```dart
abstract class ApiEndpoints {
  static const String paymentMethods = '/user/payment-methods';
  static const String addPaymentMethod = '/user/payment-methods/add';
  static const String deletePaymentMethod = '/user/payment-methods/{id}';
  static const String setDefaultPayment = '/user/payment-methods/{id}/default';
  
  static const String paymentSession = '/payments/session';
  static const String paymentHistory = '/payments/history';
}
```

### Wallet

```dart
abstract class ApiEndpoints {
  static const String wallet = '/user/wallet';
  static const String walletBalance = '/user/wallet/balance';
  static const String walletTopUp = '/user/wallet/top-up';
  static const String walletTransactions = '/user/wallet/transactions';
}
```

### AI Chat

```dart
abstract class ApiEndpoints {
  static const String aiChatSessions = '/ai/chat/sessions';
  static const String aiChatMessages = '/ai/chat/{sessionId}/messages';
  static const String aiChatSend = '/ai/chat/{sessionId}/send';
  static const String aiChatWebSocket = '/ws/ai/chat';
}
```

### Support

```dart
abstract class ApiEndpoints {
  static const String supportTickets = '/support/tickets';
  static const String supportTicketDetail = '/support/tickets/{id}';
  static const String supportMessages = '/support/tickets/{id}/messages';
  static const String supportSendMessage = '/support/tickets/{id}/messages/send';
}
```

### Notifications

```dart
abstract class ApiEndpoints {
  static const String notifications = '/user/notifications';
  static const String notificationDetail = '/user/notifications/{id}';
  static const String markAsRead = '/user/notifications/{id}/read';
  static const String markAllAsRead = '/user/notifications/read-all';
}
```

## External API Requests

For third-party APIs (e.g., geocoding services like OpenStreetMap/Nominatim), use the `externalRequest()` method:

```dart
// Geocoding example with Nominatim
final response = await _apiClient.externalRequest<Map<String, dynamic>>(
  'https://nominatim.openstreetmap.org/reverse',
  queryParameters: {
    'format': 'jsonv2',
    'lat': position.latitude,
    'lon': position.longitude,
    'addressdetails': 1,
  },
  options: Options(
    headers: {'User-Agent': 'FreshLeaf/1.0'},
  ),
);
```

Key differences from standard requests:
- Takes full URL instead of path
- Supports custom HTTP methods
- No automatic base URL prefixing
- Uses same Dio instance for consistency

## Error Handling

### Error Response Format

```json
{
  "success": false,
  "message": "Error message",
  "status": {
    "code": 422,
    "message": "Validation failed"
  },
  "errors": {
    "phone": ["Invalid phone number"],
    "password": ["Password is required"]
  }
}
```

### Parsing Errors

```dart
// lib/core/services/api_client.dart
String parseErrorMessage(DioException error) {
  if (error.response?.data != null) {
    final data = error.response!.data;
    
    if (data is Map) {
      return data['message'] ?? 
             data['status']['message'] ?? 
             'Unknown error';
    }
  }
  
  return error.message ?? 'Connection error';
}
```

### Error Handling in Controllers

```dart
Future<void> fetchProducts() async {
  try {
    isLoading.value = true;
    
    final response = await Get.find<ApiClient>().getRequest(
      ApiEndpoints.products,
      queryParameters: {'page': 1, 'limit': 20},
    );
    
    if (response.statusCode == 200) {
      final products = (response.data['data'] as List)
          .map((p) => Product.fromMap(p))
          .toList();
    }
  } on DioException catch (e) {
    if (e.type == DioExceptionType.connectionTimeout) {
      Get.snackbar('Error', 'Connection timeout');
    } else if (e.response?.statusCode == 401) {
      Get.offAllNamed(AppRoutes.login);
    } else {
      Get.snackbar('Error', parseErrorMessage(e));
    }
  } finally {
    isLoading.value = false;
  }
}
```

## Pagination

```dart
class PaginatedResponse<T> {
  final List<T> items;
  final int currentPage;
  final int totalPages;
  final int totalItems;
  final bool hasMore;

  PaginatedResponse({
    required this.items,
    required this.currentPage,
    required this.totalPages,
    required this.totalItems,
  }) : hasMore = currentPage < totalPages;
}

Future<PaginatedResponse<Product>> getProducts({int page = 1}) async {
  final response = await _apiClient.getRequest(
    ApiEndpoints.products,
    queryParameters: {'page': page, 'limit': 20},
  );
  
  final data = response.data['data'];
  
  return PaginatedResponse(
    items: (data['items'] as List).map((p) => Product.fromMap(p)).toList(),
    currentPage: data['current_page'],
    totalPages: data['total_pages'],
    totalItems: data['total_items'],
  );
}
```

## Offline Handling

```dart
class NetworkInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    if (!await hasConnection()) {
      return handler.reject(
        DioException(
          requestOptions: options,
          error: 'No internet connection',
          type: DioExceptionType.connectionError,
        ),
      );
    }
    handler.next(options);
  }
  
  Future<bool> hasConnection() async {
    final connectivityResult = await Connectivity().checkConnectivity();
    return connectivityResult.contains(ConnectivityResult.none) == false;
  }
}
```

---

## Related Files

- `lib/core/services/api_client.dart` - Main API client
- `lib/core/constants/api_endpoints.dart` - All endpoints
- `lib/core/interceptors/` - Interceptors
- `lib/core/models/api_response.dart` - Response parsing