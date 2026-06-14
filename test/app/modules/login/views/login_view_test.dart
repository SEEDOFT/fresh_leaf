import 'package:dio/dio.dart' as dio;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fresh_leaf/app/modules/login/controllers/login_controller.dart';
import 'package:fresh_leaf/app/modules/login/views/login_view.dart';
import 'package:fresh_leaf/app/modules/profile/controllers/profile_controller.dart';
import 'package:fresh_leaf/app/routes/app_routes.dart';
import 'package:fresh_leaf/core/controllers/app_settings_controller.dart';
import 'package:fresh_leaf/core/services/api_client.dart';
import 'package:fresh_leaf/core/services/notification_service.dart';
import 'package:fresh_leaf/core/services/storage_service.dart';
import 'package:get/get.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'login_view_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<ApiClient>(),
  MockSpec<StorageService>(),
  MockSpec<NotificationService>(),
  MockSpec<AppSettingsController>(),
  MockSpec<ProfileController>(),
])
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late MockApiClient mockApiClient;
  late MockStorageService mockStorageService;
  late MockNotificationService mockNotificationService;
  late MockAppSettingsController mockAppSettingsController;
  late LoginController loginController;
  late MockProfileController mockProfileController;

  setUp(() {
    mockApiClient = MockApiClient();
    mockStorageService = MockStorageService();
    mockNotificationService = MockNotificationService();
    mockAppSettingsController = MockAppSettingsController();
    mockProfileController = MockProfileController();

    loginController = LoginController(
      apiClient: mockApiClient,
      storageService: mockStorageService,
      notificationService: mockNotificationService,
      profileController: mockProfileController,
      appSettings: mockAppSettingsController,
    );
  });

  tearDown(() {
    Get.reset();
  });

  testWidgets('renders login form with all fields', (tester) async {
    Get.put(loginController);
    await tester.pumpWidget(
      GetMaterialApp(
        getPages: [
          GetPage(name: AppRoutes.login, page: () => const LoginView()),
        ],
        initialRoute: AppRoutes.login,
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    expect(find.text('login'.tr), findsOneWidget);
    expect(find.byType(TextField), findsNWidgets(2));
  });

  group('LoginController', () {
    test('login success calls proper methods', () async {
      Get.testMode = true;

      when(mockStorageService.saveToken(any)).thenAnswer((_) async {});
      when(mockStorageService.userProfile).thenReturn(null);
      when(mockNotificationService.uploadToken()).thenAnswer((_) async {});
      when(mockApiClient.postRequest(any, data: anyNamed('data'))).thenAnswer(
        (_) async => dio.Response<Map<String, dynamic>>(
          requestOptions: dio.RequestOptions(path: ''),
          statusCode: 200,
          data: <String, dynamic>{
            'status': <String, dynamic>{
              'code': '200',
              'success': true,
              'message': 'Success',
            },
            'data': <String, dynamic>{
              'access_token': 'test-token-123',
            },
          },
        ),
      );
      when(mockApiClient.getRequest(any)).thenAnswer(
        (_) async => dio.Response<Map<String, dynamic>>(
          requestOptions: dio.RequestOptions(path: ''),
          statusCode: 200,
          data: <String, dynamic>{
            'status': <String, dynamic>{
              'code': '200',
              'success': true,
              'message': 'Success',
            },
            'data': <String, dynamic>{
              'first_name': 'Test',
              'last_name': 'User',
              'email': 'test@example.com',
              'phone_number': '012345678',
            },
          },
        ),
      );

      loginController.phoneController.text = '012 345 678';
      loginController.passwordController.text = 'password123';

      await loginController.login();

      verify(mockApiClient.postRequest(any, data: anyNamed('data'))).called(1);
      verify(mockStorageService.saveToken('test-token-123')).called(1);
      verify(mockNotificationService.uploadToken()).called(1);
      expect(loginController.isLoading.value, isFalse);

      Get.testMode = false;
    });

    test('login failure does not save token', () async {
      when(mockApiClient.postRequest(any, data: anyNamed('data'))).thenAnswer(
        (_) async => dio.Response<Map<String, dynamic>>(
          requestOptions: dio.RequestOptions(path: ''),
          statusCode: 400,
          data: <String, dynamic>{
            'status': <String, dynamic>{
              'code': '400',
              'success': false,
              'message': 'Invalid credentials',
            },
          },
        ),
      );

      loginController.phoneController.text = '012 345 678';
      loginController.passwordController.text = 'wrong';

      await loginController.login();

      verifyNever(mockStorageService.saveToken(any));
      expect(loginController.isLoading.value, isFalse);
    });

    test('password visibility toggle works', () {
      expect(loginController.isPasswordVisible.value, isFalse);
      loginController.togglePasswordVisibility();
      expect(loginController.isPasswordVisible.value, isTrue);
      loginController.togglePasswordVisibility();
      expect(loginController.isPasswordVisible.value, isFalse);
    });

    test('empty fields shows validation', () async {
      await loginController.login();
      expect(loginController.isLoading.value, isFalse);
    });
  });
}
