# Testing

## Overview

FreshLeaf follows testing best practices with unit tests for controllers/services and widget tests for UI components.

## Test Structure

```
test/
├── unit/                    # Unit tests
│   ├── controllers/        # Controller tests
│   ├── services/           # Service tests
│   └── models/             # Model tests
├── widget/                 # Widget tests
├── helpers/                # Test helpers
└── mocks/                  # Mock classes
```

## Running Tests

```bash
# Run all tests
flutter test

# Run specific test file
flutter test test/unit/controllers/login_controller_test.dart

# Run tests with coverage
flutter test --coverage
```

## Unit Tests

### Controller Test

```dart
// test/unit/controllers/login_controller_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'package:fresh_leaf/app/modules/login/controllers/login_controller.dart';
import 'package:fresh_leaf/core/services/api_client.dart';
import 'package:fresh_leaf/core/services/storage_service.dart';

@GenerateMocks([ApiClient, StorageService])
import 'login_controller_test.mocks.dart';

void main() {
  late LoginController controller;
  late MockApiClient mockApiClient;
  late MockStorageService mockStorageService;

  setUp(() {
    Get.testMode = true;
    mockApiClient = MockApiClient();
    mockStorageService = MockStorageService();
    
    Get.put<ApiClient>(mockApiClient);
    Get.put<StorageService>(mockStorageService);
    
    controller = LoginController();
  });

  tearDown(() {
    Get.reset();
  });

  group('LoginController', () {
    test('should show error when phone is empty', () async {
      controller.phoneController.text = '';
      controller.passwordController.text = 'password123';

      await controller.login();

      verifyNever(mockApiClient.postRequest(any, data: anyNamed('data')));
    });

    test('should show error when password is empty', () async {
      controller.phoneController.text = '12345678';
      controller.passwordController.text = '';

      await controller.login();

      verifyNever(mockApiClient.postRequest(any, data: anyNamed('data')));
    });

    test('should call API when credentials are valid', () async {
      controller.phoneController.text = '12345678';
      controller.passwordController.text = 'password123';

      when(mockApiClient.postRequest(
        any,
        data: anyNamed('data'),
      )).thenAnswer((_) async => Response(
        statusCode: 200,
        data: {
          'success': true,
          'data': {'token': 'test_token'},
        },
      ));

      when(mockStorageService.saveToken(any)).thenAnswer((_) async {});
      when(mockApiClient.getRequest(any)).thenAnswer((_) async => Response(
        statusCode: 200,
        data: {
          'id': 1,
          'first_name': 'John',
          'last_name': 'Doe',
          'phone': '12345678',
        },
      ));
      when(mockStorageService.setUserProfile(any)).thenAnswer((_) async {});

      await controller.login();

      verify(mockApiClient.postRequest(
        ApiEndpoints.login,
        data: anyNamed('data'),
      )).called(1);
    });
  });
}
```

### Service Test

```dart
// test/unit/services/storage_service_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:get_storage/get_storage.dart';

import 'package:fresh_leaf/core/services/storage_service.dart';

void main() {
  late StorageService storageService;

  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    await GetStorage.init();
  });

  setUp(() {
    final storage = GetStorage();
    storage.erase();
    storageService = StorageService();
    storageService.init();
  });

  group('StorageService', () {
    test('should save and retrieve token', () async {
      await storageService.saveToken('test_token');

      expect(storageService.hasToken, true);
      expect(storageService.token, 'test_token');
    });

    test('should clear token', () async {
      await storageService.saveToken('test_token');
      await storageService.clearToken();

      expect(storageService.hasToken, false);
      expect(storageService.token, null);
    });

    test('should save user profile', () async {
      final profile = UserProfile(
        id: 1,
        firstName: 'John',
        lastName: 'Doe',
        phone: '12345678',
      );

      await storageService.setUserProfile(profile);

      expect(storageService.userProfile, isNotNull);
      expect(storageService.userProfile!.firstName, 'John');
    });
  });
}
```

## Widget Tests

### Basic Widget Test

```dart
// test/widget/primary_button_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:fresh_leaf/shared/widgets/buttons/primary_button.dart';

void main() {
  group('PrimaryButton', () {
    testWidgets('should display text', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PrimaryButton(
              text: 'Click Me',
              onPressed: () {},
            ),
          ),
        ),
      );

      expect(find.text('Click Me'), findsOneWidget);
    });

    testWidgets('should call onPressed when tapped', (tester) async {
      var pressed = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PrimaryButton(
              text: 'Click Me',
              onPressed: () {
                pressed = true;
              },
            ),
          ),
        ),
      );

      await tester.tap(find.byType(ElevatedButton));
      await tester.pump();

      expect(pressed, true);
    });

    testWidgets('should show loading indicator when isLoading', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PrimaryButton(
              text: 'Click Me',
              isLoading: true,
              onPressed: () {},
            ),
          ),
        ),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.text('Click Me'), findsNothing);
    });

    testWidgets('should be disabled when onPressed is null', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: PrimaryButton(
              text: 'Click Me',
              onPressed: null,
            ),
          ),
        ),
      );

      final button = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
      expect(button.onPressed, isNull);
    });
  });
}
```

### Form Widget Test

```dart
// test/widget/app_text_field_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:fresh_leaf/shared/widgets/inputs/app_text_field.dart';

void main() {
  group('AppTextField', () {
    testWidgets('should display label and hint', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: AppTextField(
              labelText: 'Email',
              hintText: 'Enter your email',
            ),
          ),
        ),
      );

      expect(find.text('Email'), findsOneWidget);
      expect(find.text('Enter your email'), findsOneWidget);
    });

    testWidgets('should call onChanged when text changes', (tester) async {
      String? changedValue;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AppTextField(
              onChanged: (value) {
                changedValue = value;
              },
            ),
          ),
        ),
      );

      await tester.enterText(find.byType(TextFormField), 'test@test.com');
      await tester.pump();

      expect(changedValue, 'test@test.com');
    });

    testWidgets('should show error when validator fails', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AppTextField(
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Field is required';
                }
                return null;
              },
            ),
          ),
        ),
      );

      final form = tester.widget<TextFormField>(find.byType(TextFormField));
      form.controller!.text = '';
      
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Form(
              child: AppTextField(
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Field is required';
                  }
                  return null;
                },
              ),
            ),
          ),
        ),
      );

      await tester.pump();
      expect(find.text('Field is required'), findsOneWidget);
    });
  });
}
```

## Mock Classes

### API Client Mock

```dart
// test/mocks/mock_api_client.dart
class MockApiClient extends Mock implements ApiClient {
  @override
  Future<Response> getRequest(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    return super.noSuchMethod(
      Invocation.method(#getRequest, [path], {
        #queryParameters: queryParameters,
        #options: options,
      }),
    );
  }

  @override
  Future<Response> postRequest(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    return super.noSuchMethod(
      Invocation.method(#postRequest, [path], {
        #data: data,
        #queryParameters: queryParameters,
        #options: options,
      }),
    );
  }
}
```

### Repository Mock

```dart
// test/mocks/mock_product_repository.dart
class MockProductRepository extends Mock implements ProductRepository {
  @override
  Future<List<HomeProduct>> getHomeProducts() async {
    return [
      HomeProduct(
        id: 1,
        name: 'Test Product',
        priceUsd: 9.99,
        priceKhr: 40000,
      ),
    ];
  }

  @override
  Future<List<HomeCategory>> getHomeCategories() async {
    return [
      HomeCategory(id: 1, name: 'Vegetables', slug: 'vegetables'),
    ];
  }
}
```

## Integration Tests

```dart
// test/integration/login_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:fresh_leaf/app/app.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Login Flow', () {
    testWidgets('should login successfully with valid credentials', (tester) async {
      await tester.pumpWidget(const FreshLeafApp());
      await tester.pumpAndSettle();

      // Enter phone
      await tester.enterText(
        find.byType(TextFormField).first,
        '12345678',
      );
      await tester.pump();

      // Enter password
      await tester.enterText(
        find.byType(TextFormField).last,
        'password123',
      );
      await tester.pump();

      // Tap login button
      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();

      // Should navigate to dashboard
      expect(find.text('Dashboard'), findsOneWidget);
    });
  });
}
```

## Test Helpers

### Test Wrapper

```dart
// test/helpers/test_wrapper.dart
Widget testableWidget(Widget child) {
  return GetMaterialApp(
    home: child,
  );
}
```

### JSON Loader

```dart
// test/helpers/json_loader.dart
Map<String, dynamic> loadJson(String filename) {
  return json.decode(
    File('test/fixtures/$filename').readAsStringSync(),
  ) as Map<String, dynamic>;
}
```

---

## Related Files

- `pubspec.yaml` - Test dependencies
- `test/` - All test files