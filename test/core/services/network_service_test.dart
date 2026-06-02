import 'package:flutter_test/flutter_test.dart';
import 'package:fresh_leaf/core/services/network_service.dart';

void main() {
  group('NetworkService', () {
    test('hasInternetConnection returns true or false without crashing', () async {
      final result = await NetworkService.hasInternetConnection();
      expect(result, isA<bool>());
    });
  });
}
