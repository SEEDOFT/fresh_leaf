import 'package:flutter_test/flutter_test.dart';
import 'package:fresh_leaf/core/models/api_response.dart';
import 'package:fresh_leaf/core/models/paginated_response.dart';

void main() {
  group('ApiStatus', () {
    test('parses status from map', () {
      final status = ApiStatus.fromMap(<String, dynamic>{
        'code': '200',
        'success': true,
        'message': 'OK',
      });

      expect(status.code, '200');
      expect(status.success, isTrue);
      expect(status.message, 'OK');
    });

    test('parses status with null values', () {
      final status = ApiStatus.fromMap(<String, dynamic>{
        'code': null,
        'success': null,
        'message': null,
      });

      expect(status.code, '');
      expect(status.success, isFalse);
      expect(status.message, '');
    });

    test('converts to map and copies correctly', () {
      final status = ApiStatus.fromMap(<String, dynamic>{
        'code': '200',
        'success': true,
        'message': 'OK',
      });

      final map = status.toMap();
      expect(map['code'], '200');
      expect(map['success'], true);
      expect(map['message'], 'OK');

      final copy = status.copyWith(message: 'Updated');
      expect(copy.code, '200');
      expect(copy.message, 'Updated');
    });
  });

  group('ApiResponse.parseMap', () {
    test('parses a successful map response', () {
      final response = ApiResponse.parseMap(<String, dynamic>{
        'status': <String, dynamic>{
          'code': '200',
          'success': true,
          'message': 'OK',
        },
        'data': <String, dynamic>{'key': 'value'},
      });

      expect(response.isSuccess, isTrue);
      expect(response.data['key'], 'value');
    });

    test('parses response with empty data', () {
      final response = ApiResponse.parseMap(<String, dynamic>{
        'status': <String, dynamic>{
          'code': '200',
          'success': true,
          'message': 'OK',
        },
      });

      expect(response.isSuccess, isTrue);
      expect(response.data, isEmpty);
    });
  });

  group('ApiResponse.parseList', () {
    test('parses a list response with items array', () {
      final response = ApiResponse.parseList(<String, dynamic>{
        'status': <String, dynamic>{
          'code': '200',
          'success': true,
          'message': 'OK',
        },
        'data': <dynamic>[
          <String, dynamic>{'id': 1},
          <String, dynamic>{'id': 2},
        ],
      });

      expect(response.isSuccess, isTrue);
      expect(response.data.length, 2);
      expect(response.data[0]['id'], 1);
    });

    test('parses list response with paginated data envelope', () {
      final response = ApiResponse.parseList(<String, dynamic>{
        'status': <String, dynamic>{
          'code': '200',
          'success': true,
          'message': 'OK',
        },
        'data': <String, dynamic>{
          'data': <dynamic>[
            <String, dynamic>{'id': 1},
          ],
          'current_page': 1,
        },
      });

      expect(response.isSuccess, isTrue);
      expect(response.data.length, 1);
    });

    test('returns empty list when data is not a list', () {
      final response = ApiResponse.parseList(<String, dynamic>{
        'status': <String, dynamic>{
          'code': '200',
          'success': true,
          'message': 'OK',
        },
        'data': 'not a list',
      });

      expect(response.data, isEmpty);
    });
  });

  group('ApiResponse.parseString', () {
    test('parses a string data response', () {
      final response = ApiResponse.parseString(<String, dynamic>{
        'status': <String, dynamic>{
          'code': '200',
          'success': true,
          'message': 'OK',
        },
        'data': 'some-string',
      });

      expect(response.data, 'some-string');
    });

    test('parses with null data', () {
      final response = ApiResponse.parseString(<String, dynamic>{
        'status': <String, dynamic>{
          'code': '200',
          'success': true,
          'message': 'OK',
        },
        'data': null,
      });

      expect(response.data, '');
    });
  });

  group('ApiResponse.parseBool', () {
    test('parses a boolean data response', () {
      final response = ApiResponse.parseBool(<String, dynamic>{
        'status': <String, dynamic>{
          'code': '200',
          'success': true,
          'message': 'OK',
        },
        'data': true,
      });

      expect(response.data, isTrue);
    });

    test('parses with falsy data', () {
      final response = ApiResponse.parseBool(<String, dynamic>{
        'status': <String, dynamic>{
          'code': '200',
          'success': true,
          'message': 'OK',
        },
        'data': false,
      });

      expect(response.data, isFalse);
    });
  });

  group('ApiResponse.parseDynamic', () {
    test('parses a dynamic data response', () {
      final response = ApiResponse.parseDynamic(<String, dynamic>{
        'status': <String, dynamic>{
          'code': '200',
          'success': true,
          'message': 'OK',
        },
        'data': <String, dynamic>{'any': 'thing'},
      });

      expect(response.data['any'], 'thing');
    });
  });

  group('ApiResponse.fromResponse', () {
    test('parses with a custom parser and handles non-Map error', () {
      final response = ApiResponse.fromResponse(
        <String, dynamic>{
          'status': <String, dynamic>{
            'code': '200',
            'success': true,
            'message': 'OK',
          },
          'data': <String, dynamic>{'id': 42},
        },
        (json) => (json as Map<String, dynamic>)['id'] as int,
      );

      expect(response.data, 42);
      expect(response.status.code, '200');
    });
  });

  group('ApiResponse.parsePaginated', () {
    test('parses paginated response with items', () {
      final response = ApiResponse.parsePaginated<int>(
        <String, dynamic>{
          'status': <String, dynamic>{
            'code': '200',
            'success': true,
            'message': 'OK',
          },
          'data': <String, dynamic>{
            'data': <dynamic>[
              <String, dynamic>{'id': 1},
              <String, dynamic>{'id': 2},
            ],
            'current_page': 1,
          },
        },
        (map) => map['id'] as int,
      );

      expect(response.isSuccess, isTrue);
      expect(response.data.items, [1, 2]);
      expect(response.data.currentPage, 1);
      expect(response.data.hasMore, isFalse);
    });

    test('parses paginated response with next page url', () {
      final response = ApiResponse.parsePaginated<int>(
        <String, dynamic>{
          'status': <String, dynamic>{
            'code': '200',
            'success': true,
            'message': 'OK',
          },
          'data': <String, dynamic>{
            'data': <dynamic>[],
            'current_page': 1,
            'next_page_url': 'http://example.test?page=2',
          },
        },
        (map) => map['id'] as int,
      );

      expect(response.data.hasMore, isTrue);
      expect(response.data.nextPageUrl, 'http://example.test?page=2');
    });
  });
}
