import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fresh_leaf/app/modules/onboarding/controllers/onboarding_controller.dart';
import 'package:fresh_leaf/core/services/storage_service.dart';
import 'package:get/get.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'onboarding_controller_test.mocks.dart';

@GenerateNiceMocks([MockSpec<StorageService>()])
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('OnboardingController', () {
    late MockStorageService mockStorage;
    late OnboardingController controller;

    setUp(() {
      mockStorage = MockStorageService();
      when(mockStorage.saveOnboardingSeen(seen: anyNamed('seen')))
          .thenAnswer((_) async {});
      controller = OnboardingController(storageService: mockStorage);
    });

    tearDown(() {
      Get.reset();
    });

    test('isLastPage is false by default', () {
      expect(controller.isLastPage, isFalse);
    });

    test('isLastPage is true when currentPage is 2', () {
      controller.currentPage.value = 2;
      expect(controller.isLastPage, isTrue);
    });

    test('onInit marks onboarding as seen', () async {
      await controller.onInit();
      verify(mockStorage.saveOnboardingSeen(seen: true)).called(1);
    });

    test('skip marks onboarding as seen even if navigation fails', () async {
      when(mockStorage.token).thenReturn(null);
      try {
        await controller.skip();
      } catch (_) {
        // _goForward calls Get.offAllNamed which fails without a running app
      }
      verify(mockStorage.saveOnboardingSeen(seen: true)).called(1);
    });
  });
}
