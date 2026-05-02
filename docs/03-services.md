# Services

## Overview

Core services in FreshLeaf handle HTTP communication, local storage, real-time connections, and business logic. All services follow the GetX service pattern.

## Service Architecture

```
lib/core/
├── services/                          # Core services
│   ├── api_client.dart                # HTTP client (Dio)
│   ├── storage_service.dart           # Token & preferences
│   ├── product_service.dart           # Product API
│   ├── payment_session_service.dart   # Checkout payment
│   ├── notification_service.dart      # FCM notifications
│   ├── ai_assistant_api_service.dart # AI chat REST
│   ├── ai_assistant_realtime_service.dart # AI WebSocket
│   ├── support_realtime_service.dart # Support WebSocket
│   ├── pin_security_service.dart      # PIN verification
│   ├── network_service.dart           # Connectivity
│   └── permission_service.dart        # Runtime permissions
└── repositories/                      # Data access layer
    ├── home_repository.dart           # Home data (categories, products)
    ├── product_repository.dart        # Product CRUD, search, wishlist
    └── location_repository.dart       # Geocoding & location services
```

> **Note**: The repository layer abstracts API calls from controllers, providing a clean data access pattern with mock data fallback for development.

## API Client

The main HTTP client using Dio with interceptors for authentication.

**Key Features:**
- Automatic token injection via interceptor
- Multipart file upload support
- External request support for third-party APIs
- Detailed debug logging for FCM token operations

```dart
// lib/core/services/api_client.dart
class ApiClient extends GetxService {
  late final Dio _dio;
  final StorageService storageService;

  ApiClient({required this.storageService}) {
    _dio = Dio(BaseOptions(
      baseUrl: AppConfig.apiUrl,
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 20),
      sendTimeout: const Duration(seconds: 20),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
    ));

    _setupInterceptors();
  }

  void _setupInterceptors() {
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        // Auto-inject auth token from storage
        final token = storageService.token;
        final languageCode = storageService.languageCode ?? 'km';
        options.headers['Accept-Language'] = _toApiLanguage(languageCode);

        if (token != null && token.isNotEmpty) {
          options.headers['Authorization'] = 'Bearer $token';
        } else {
          options.headers.remove('Authorization');
        }

        return handler.next(options);
      },
      onError: (error, handler) {
        debugPrint('[ApiClient] Error: ${error.message}');
        return handler.next(error);
      },
    ));
  }

  // Standard HTTP methods
  Future<Response<Map<String, dynamic>>> getRequest(String path, {...});
  Future<Response<Map<String, dynamic>>> postRequest(String path, {...});
  Future<Response<Map<String, dynamic>>> putRequest(String path, {...});
  Future<Response<Map<String, dynamic>>> patchRequest(String path, {...});
  Future<Response<Map<String, dynamic>>> deleteRequest(String path, {...});

  // File upload
  Future<Response<Map<String, dynamic>>> postMultipart(
    String path, {
    required FormData data,
    ProgressCallback? onSendProgress,
  });

  // Third-party API calls (e.g., geocoding)
  Future<Response<T>> externalRequest<T>(
    String url, {
    String method = 'GET',
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  });
}
```

## Storage Service

Manages token storage, user preferences, and local data using GetStorage.

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
  
  bool get hasToken => token != null && token!.isNotEmpty;
  
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
  
  Future<void> clearUserProfile() async {
    await _storage.remove('user_profile');
  }
  
  // Onboarding
  bool get hasSeenOnboarding => _storage.read('onboarding_seen') ?? false;
  
  Future<void> setOnboardingSeen() async {
    await _storage.write('onboarding_seen', true);
  }
  
  // Locale
  String? get locale => _storage.read('locale');
  
  Future<void> setLocale(String locale) async {
    await _storage.write('locale', locale);
  }
  
  // Theme
  bool get isDarkMode => _storage.read('dark_mode') ?? false;
  
  Future<void> setDarkMode(bool isDark) async {
    await _storage.write('dark_mode', isDark);
  }
  
  // PIN order verification
  bool get pinOrderVerified => _storage.read('pin_order_verified') ?? false;
  
  Future<void> setPinOrderVerified(bool verified) async {
    await _storage.write('pin_order_verified', verified);
  }
  
  // Clear all
  Future<void> clearAll() async {
    await _storage.erase();
  }
}
```

## Product Service

Handles product-related API calls.

```dart
// lib/core/services/product_service.dart
class ProductService extends GetxService {
  final ApiClient _apiClient = Get.find<ApiClient>();
  
  Future<List<HomeProduct>> getHomeProducts() async {
    final response = await _apiClient.getRequest(
      ApiEndpoints.products,
      queryParameters: {'limit': 20},
    );
    
    final apiResponse = ApiResponse.parseList(response.data);
    return apiResponse.data.map((e) => HomeProduct.fromMap(e)).toList();
  }
  
  Future<OrganicProduct> getProductDetail(int productId) async {
    final response = await _apiClient.getRequest(
      ApiEndpoints.productById.replaceAll('{id}', productId.toString()),
    );
    
    return OrganicProduct.fromMap(response.data);
  }
  
  Future<List<HomeProduct>> searchProducts(String query) async {
    final response = await _apiClient.getRequest(
      ApiEndpoints.productSearch,
      queryParameters: {'q': query},
    );
    
    final apiResponse = ApiResponse.parseList(response.data);
    return apiResponse.data.map((e) => HomeProduct.fromMap(e)).toList();
  }
}
```

## AI Assistant Services

### API Service

```dart
// lib/core/services/ai_assistant_api_service.dart
class AiAssistantApiService extends GetxService {
  final ApiClient _apiClient = Get.find<ApiClient>();
  
  Future<AiChatSession> createSession() async {
    final response = await _apiClient.postRequest(
      ApiEndpoints.aiChatSessions,
    );
    
    return AiChatSession.fromMap(response.data);
  }
  
  Future<AiChatSendMessageResult> sendMessage({
    required String sessionId,
    required String message,
  }) async {
    final response = await _apiClient.postRequest(
      ApiEndpoints.aiChatMessages,
      data: {
        'session_id': sessionId,
        'message': message,
      },
    );
    
    return AiChatSendMessageResult.fromMap(response.data);
  }
  
  Future<List<AiChatMessage>> getHistory(String sessionId) async {
    final response = await _apiClient.postRequest(
      ApiEndpoints.aiChatHistory,
      data: {'session_id': sessionId},
    );
    
    final apiResponse = ApiResponse.parseList(response.data);
    return apiResponse.data.map((e) => AiChatMessage.fromMap(e)).toList();
  }
}
```

### Realtime Service (WebSocket)

```dart
// lib/core/services/ai_assistant_realtime_service.dart
class AiAssistantRealtimeService extends GetxService {
  WebSocketChannel? _socketChannel;
  StreamSubscription? _subscription;
  
  final _messageController = StreamController<AiChatRealtimeEvent>.broadcast();
  Stream<AiChatRealtimeEvent> get messages => _messageController.stream;
  
  Future<void> connect(int userId, String sessionId) async {
    final uri = Uri.parse(
      '${AppConfig.reverbWsScheme}://${AppConfig.reverbWsHost}:${AppConfig.reverbWsPort}'
      '/app/${AppConfig.reverbAppKey}'
      '?protocol=7&client=flutter&version=1.0',
    );
    
    _socketChannel = WebSocketChannel.connect(uri);
    
    _subscription = _socketChannel!.stream.listen(_handleMessage);
  }
  
  void _handleMessage(dynamic data) {
    final json = jsonDecode(data as String);
    final event = json['event'] as String;
    final eventData = jsonDecode(json['data'] as String);
    
    switch (event) {
      case 'AiMessageStarted':
        _messageController.add(AiMessageStarted.fromMap(eventData));
        break;
      case 'AiMessageChunk':
        _messageController.add(AiMessageChunk.fromMap(eventData));
        break;
      case 'AiMessageCompleted':
        _messageController.add(AiMessageCompleted.fromMap(eventData));
        break;
      case 'AiMessageFailed':
        _messageController.add(AiMessageFailed.fromMap(eventData));
        break;
    }
  }
  
  Future<void> disconnect() async {
    await _subscription?.cancel();
    await _socketChannel?.sink.close();
  }
}
```

## Support Realtime Service

```dart
// lib/core/services/support_realtime_service.dart
class SupportRealtimeService extends GetxService {
  WebSocketChannel? _socketChannel;
  
  final _messageController = StreamController<SupportMessage>.broadcast();
  final _typingController = StreamController<String>.broadcast();
  
  Stream<SupportMessage> get messages => _messageController.stream;
  Stream<String> get typingEvents => _typingController.stream;
  
  bool get isConnected => _isConnected;
  
  Future<void> connect() async { ... }
  
  Future<void> subscribeToTicket(int ticketId) async { ... }
  
  void _handleMessage(dynamic payload) {
    final data = jsonDecode(payload as String);
    final event = data['event'];
    
    if (event == 'SupportMessageSent') {
      final messageData = jsonDecode(data['data']);
      _messageController.add(SupportMessage.fromMap(messageData));
    } else if (event == 'SupportTyping') {
      final typingData = jsonDecode(data['data']);
      _typingController.add(typingData['sender_type']);
    }
  }
  
  // Reconnection logic
  Timer? _reconnectTimer;
  void _scheduleReconnect() { ... }
  
  // Ping/pong heartbeat
  void _startPingTimer() { ... }
}
```

## Notification Service

Handles Firebase Cloud Messaging (FCM) for push notifications. Supports foreground, background, and terminated app states.

**Key Features:**
- FCM token management with automatic upload on login
- Local notifications for foreground messages
- Typing indicator updates for support chat
- Debug logging for troubleshooting token issues

```dart
// lib/core/services/notification_service.dart
class NotificationService extends GetxService {
  final ApiClient apiClient;
  final FirebaseMessaging _fcm = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotifications = FlutterLocalNotificationsPlugin();

  Future<NotificationService> init() async {
    await _initializeLocalNotifications();
    await _requestPermissions();
    _listenToMessages();
    _listenToTokenRefresh();
    await _handleInitialMessage();
    return this;
  }

  // Get FCM token (with debug logging)
  Future<String?> getToken() async {
    try {
      final token = await _fcm.getToken();
      debugPrint('[NotificationService] FCM Token: ${token?.substring(0, 15)}...');
      return token;
    } on Exception catch (e) {
      debugPrint('[NotificationService] Error getting FCM token: $e');
      return null;
    }
  }

  // Upload token to backend (with debug logging)
  Future<void> uploadToken() async {
    final token = await getToken();
    if (token != null) {
      debugPrint('[NotificationService] Uploading FCM token...');
      await _uploadTokenValue(token);
    }
  }

  // Handle foreground messages
  void _listenToMessages() {
    FirebaseMessaging.onMessage.listen((message) {
      final type = message.data['type'];

      if (type == 'support_chat') {
        // Show notification only if not on support chat screen
        if (Get.currentRoute != AppRoutes.supportChat) {
          _showLocalNotification(message);
        }
        // Refresh unread count if help center is open
        if (Get.isRegistered<ProfileHelpCenterController>()) {
          Get.find<ProfileHelpCenterController>().refreshUnreadCount();
        }
      }
    });
  }

  // Token refresh listener
  void _listenToTokenRefresh() {
    _fcm.onTokenRefresh.listen((token) {
      unawaited(_uploadTokenValue(token));
    });
  }
}

## Service Registration (Bootstrap)

```dart
// lib/core/bootstrap/app_bootstrap.dart
class AppBootstrap {
  static Future<void> init() async {
    // Register services
    Get.put(ApiClient());
    Get.put(StorageService());
    Get.put(ProductService());
    Get.put(CategoryService());
    Get.put(AiAssistantApiService());
    Get.put(NotificationService());

    // Initialize Firebase
    await Firebase.initializeApp();
    await Get.find<NotificationService>().initialize();
  }
}
```

## Repository Layer

The repository pattern provides an abstraction between controllers and API services. This separation ensures:
- Cleaner controller code
- Easier testing (mock repositories)
- Consistent data handling
- Mock data fallback for development

### Home Repository

```dart
// lib/core/repositories/home_repository.dart
class HomeRepository {
  final ApiClient _apiClient = Get.find<ApiClient>();

  // Fetch categories from API with fallback to mock data
  Future<List<HomeCategory>> getCategories() async {
    try {
      final response = await _apiClient.getRequest(ApiEndpoints.homeCategories);
      if (response.statusCode == 200 && response.data != null) {
        final data = response.data!['data'] as List?;
        return data?.map((json) => HomeCategory.fromMap(json)).toList() ?? [];
      }
      return getMockCategories();
    } catch (e) {
      return getMockCategories(); // Fallback for development
    }
  }

  // Mock data for development/offline
  List<HomeCategory> getMockCategories() {
    return const [
      HomeCategory(icon: HomeCategoryIcon.leaf, titleKey: 'leafy_greens'),
      HomeCategory(icon: HomeCategoryIcon.rootAndTuber, titleKey: 'root_veg'),
    ];
  }
}
```

### Product Repository

```dart
// lib/core/repositories/product_repository.dart
class ProductRepository {
  final ApiClient _apiClient = Get.find<ApiClient>();

  Future<List<OrganicProduct>> getOrganicProducts({
    int page = 1,
    int limit = 20,
    int? categoryId,
  }) async {
    final queryParams = <String, dynamic>{'page': page, 'limit': limit};
    if (categoryId != null) queryParams['category_id'] = categoryId;

    try {
      final response = await _apiClient.getRequest(
        ApiEndpoints.organicProducts,
        queryParameters: queryParams,
      );
      // Parse response...
    } catch (e) {
      return [];
    }
  }

  // Wishlist operations
  Future<bool> addToWishlist(int productId) async { ... }
  Future<bool> removeFromWishlist(int productId) async { ... }
}
```

### Location Repository

Handles external APIs (geocoding) through ApiClient's `externalRequest()` method:

```dart
// lib/core/repositories/location_repository.dart
class LocationRepository {
  final ApiClient _apiClient = Get.find<ApiClient>();

  Future<LocationResult> reverseGeocode(
    double latitude,
    double longitude, {
    String language = 'en',
  }) async {
    // Use externalRequest for third-party APIs
    final response = await _apiClient.externalRequest<Map<String, dynamic>>(
      'https://nominatim.openstreetmap.org/reverse',
      queryParameters: {...},
      options: Options(headers: {'User-Agent': 'FreshLeaf/1.0'}),
    );
    // Parse response...
  }
}
```

### Using Repositories in Controllers

```dart
// lib/app/modules/home/controllers/home_controller.dart
class HomeController extends GetxController {
  final HomeRepository _homeRepository = HomeRepository();
  final LocationRepository _locationRepository = LocationRepository();

  final RxList<HomeCategory> categories = <HomeCategory>[].obs;
  final RxList<HomeProduct> pickedThisMorning = <HomeProduct>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadHomeData();
    unawaited(fetchCurrentLocation());
  }

  Future<void> loadHomeData() async {
    try {
      final results = await Future.wait([
        _homeRepository.getCategories(),
        _homeRepository.getFeaturedProducts(),
      ]);
      categories.value = results[0];
      pickedThisMorning.value = results[1];
    } catch (e) {
      // Use fallback mock data
      categories.value = _homeRepository.getMockCategories();
      pickedThisMorning.value = _homeRepository.getMockProducts();
    }
  }
}
```

---

## Related Files

- `lib/core/config/app_config.dart` - Configuration
- `lib/core/constants/api_endpoints.dart` - API endpoints
- `lib/core/models/` - Data models