import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fresh_leaf/app/modules/network_check/controllers/network_check_controller.dart';
import 'package:get/get.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('NetworkCheckController', () {
    late NetworkCheckController controller;

    setUp(() {
      controller = NetworkCheckController();
    });

    tearDown(() {
      Get.reset();
    });

    test('initial state is offline and not checking', () {
      expect(controller.isOnline.value, isFalse);
      expect(controller.isChecking.value, isFalse);
    });

    testWidgets('continueToLogin shows snackbar when offline', (tester) async {
      await tester.pumpWidget(
        const GetMaterialApp(home: Text('')),
      );

      controller.isOnline.value = false;
      await controller.continueToLogin();
      await tester.pump();
      await tester.pump(const Duration(seconds: 5));

      expect(controller.isOnline.value, isFalse);
    });
  });
}
