import 'package:flutter_test/flutter_test.dart';
import 'package:fresh_leaf/core/models/paginated_response.dart';

void main() {
  group('PaginatedResponse', () {
    test('parses list data directly', () {
      final response = PaginatedResponse.fromMap(
        <dynamic>[
          <String, dynamic>{'id': 1},
          <String, dynamic>{'id': 2},
        ],
        (map) => map['id'] as int,
      );

      expect(response.items, [1, 2]);
      expect(response.currentPage, 1);
      expect(response.hasMore, isFalse);
    });

    test('parses map data with data array', () {
      final response = PaginatedResponse.fromMap(
        <String, dynamic>{
          'data': <dynamic>[
            <String, dynamic>{'name': 'A'},
            <String, dynamic>{'name': 'B'},
          ],
          'current_page': 3,
          'next_page_url': 'http://example.test?page=4',
        },
        (map) => map['name'] as String,
      );

      expect(response.items, ['A', 'B']);
      expect(response.currentPage, 3);
      expect(response.hasMore, isTrue);
      expect(response.nextPageUrl, 'http://example.test?page=4');
    });

    test('handles empty list', () {
      final response = PaginatedResponse.fromMap(
        <dynamic>[],
        (map) => map['id'] as int,
      );

      expect(response.items, isEmpty);
      expect(response.hasMore, isFalse);
    });

    test('handles map without data key', () {
      final response = PaginatedResponse.fromMap(
        <String, dynamic>{'current_page': 1},
        (map) => map['id'] as int,
      );

      expect(response.items, isEmpty);
      expect(response.currentPage, 1);
    });

    test('PaginatedResponse.empty() creates empty response', () {
      final response = PaginatedResponse.empty();

      expect(response.items, isEmpty);
      expect(response.currentPage, 1);
      expect(response.hasMore, isFalse);
    });
  });
}
