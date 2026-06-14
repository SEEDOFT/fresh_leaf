import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fresh_leaf/app/modules/cart/controllers/cart_controller.dart';
import 'package:fresh_leaf/app/modules/dashboard/controllers/dashboard_controller.dart';
import 'package:fresh_leaf/app/modules/home/controllers/home_controller.dart';
import 'package:fresh_leaf/app/modules/home/views/home_view.dart';
import 'package:fresh_leaf/app/modules/orders/controllers/orders_controller.dart';
import 'package:fresh_leaf/core/controllers/wishlist_controller.dart';
import 'package:fresh_leaf/core/models/cart_snapshot.dart';
import 'package:fresh_leaf/core/models/paginated_response.dart';
import 'package:fresh_leaf/core/models/product_category.dart';
import 'package:fresh_leaf/core/models/vendor_inventory.dart';
import 'package:fresh_leaf/core/repositories/home_repository.dart';
import 'package:fresh_leaf/core/repositories/location_repository.dart';
import 'package:fresh_leaf/core/services/cart_service.dart';
import 'package:fresh_leaf/core/services/notification_service.dart';
import 'package:fresh_leaf/core/services/order_service.dart';
import 'package:fresh_leaf/core/services/product_service.dart';
import 'package:fresh_leaf/core/services/wishlist_service.dart';
import 'package:fresh_leaf/app/routes/app_routes.dart';
import 'package:get/get.dart';
import 'package:get/get_instance/src/lifecycle.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'home_view_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<ProductService>(),
  MockSpec<NotificationService>(),
  MockSpec<HomeRepository>(),
  MockSpec<LocationRepository>(),
  MockSpec<CartService>(),
  MockSpec<OrderService>(),
  MockSpec<WishlistService>(),
])
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late MockProductService mockProductService;
  late MockNotificationService mockNotificationService;
  late MockHomeRepository mockHomeRepository;
  late MockLocationRepository mockLocationRepository;
  late MockOrderService mockOrderService;
  late MockCartService mockCartService;
  late MockWishlistService mockWishlistService;

  setUp(() {
    mockProductService = MockProductService();
    mockNotificationService = MockNotificationService();
    mockHomeRepository = MockHomeRepository();
    mockLocationRepository = MockLocationRepository();
    mockOrderService = MockOrderService();
    mockCartService = MockCartService();
    mockWishlistService = MockWishlistService();

    when(mockProductService.getProducts(
      categoryId: anyNamed('categoryId'),
      query: anyNamed('query'),
      province: anyNamed('province'),
      page: anyNamed('page'),
      perPage: anyNamed('perPage'),
    )).thenAnswer((_) async => PaginatedResponse.empty());

    when(mockHomeRepository.getCategories()).thenAnswer(
      (_) async => <ProductCategory>[],
    );

    when(mockOrderService.getOrders(
      page: anyNamed('page'),
    )).thenAnswer((_) async => PaginatedResponse.empty());

    when(mockLocationRepository.reverseGeocode(any, any)).thenAnswer(
      (_) async => LocationResult(),
    );

    when(mockCartService.getCartSnapshot()).thenAnswer(
      (_) async => CartSnapshot.empty,
    );

    when(mockWishlistService.getWishlist(page: anyNamed('page'))).thenAnswer(
      (_) async => PaginatedResponse<VendorInventory>.empty(),
    );

    when(mockNotificationService.onStart).thenReturn(
      InternalFinalCallback<void>(callback: () {}),
    );
    when(mockNotificationService.unreadCount).thenReturn(0.obs);
    when(mockNotificationService.unreadChatCount).thenReturn(0.obs);
  });

  setUpAll(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
      const MethodChannel('flutter.baseflow.com/geolocator'),
      (MethodCall methodCall) async {
        if (methodCall.method == 'isLocationServiceEnabled') {
          return true;
        }
        if (methodCall.method == 'getCurrentPosition') {
          return <dynamic>[
            11.55, // latitude
            104.91, // longitude
            0.0, // altitude
            0.0, // accuracy
            0.0, // heading
            0.0, // speed
            DateTime.now().millisecondsSinceEpoch.toDouble(),
          ];
        }
        return null;
      },
    );
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
      const MethodChannel('flutter.baseflow.com/permissions'),
      (MethodCall methodCall) async {
        if (methodCall.method == 'checkPermissionStatus') {
          return 4; // PermissionStatus.granted
        }
        if (methodCall.method == 'requestPermissions') {
          return {methodCall.arguments as String: 4};
        }
        if (methodCall.method == 'shouldShowRequestPermissionRationale') {
          return true;
        }
        return null;
      },
    );
  });

  tearDown(() {
    Get.reset();
  });

  void registerControllers() {
    Get.testMode = true;
    final homeController = HomeController(
      productService: mockProductService,
      notificationService: mockNotificationService,
      homeRepository: mockHomeRepository,
      locationRepository: mockLocationRepository,
    );
    Get.put<HomeController>(homeController);
    Get.put<DashboardController>(DashboardController());
    Get.put<OrdersController>(OrdersController(orderService: mockOrderService));
    Get.put<CartController>(CartController(cartService: mockCartService));
    Get.put<NotificationService>(mockNotificationService);
    Get.put<WishlistController>(
      WishlistController(wishlistService: mockWishlistService),
    );
  }

  Future<void> pumpHomeView(WidgetTester tester) async {
    await tester.pumpWidget(
      GetMaterialApp(
        getPages: [
          GetPage(name: AppRoutes.home, page: () => const HomeView()),
        ],
        initialRoute: AppRoutes.home,
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));
  }

  testWidgets('home view builds without error', (tester) async {
    registerControllers();
    await pumpHomeView(tester);

    expect(find.byType(HomeView), findsOneWidget);

    Get.delete<HomeController>();
  });

  testWidgets('home view has refresh indicator', (tester) async {
    registerControllers();
    await pumpHomeView(tester);

    expect(find.byType(RefreshIndicator), findsOneWidget);

    Get.delete<HomeController>();
  });

  testWidgets('home view renders footer branding text', (tester) async {
    registerControllers();
    await pumpHomeView(tester);

    await tester.drag(find.byType(CustomScrollView), const Offset(0, -1000));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    expect(
      find.text('app_description_footer'),
      findsOneWidget,
    );

    Get.delete<HomeController>();
  });
}
