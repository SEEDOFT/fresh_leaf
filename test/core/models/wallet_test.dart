import 'package:flutter_test/flutter_test.dart';
import 'package:fresh_leaf/core/models/wallet.dart';

void main() {
  group('WalletCurrency', () {
    test('parses from map', () {
      final currency = WalletCurrency.fromMap(<String, dynamic>{
        'id': 1,
        'code': 'USD',
        'name': 'US Dollar',
        'symbol': r'$',
      });

      expect(currency.id, 1);
      expect(currency.code, 'USD');
      expect(currency.name, 'US Dollar');
      expect(currency.symbol, r'$');
    });

    test('handles empty values', () {
      final currency = WalletCurrency.fromMap(<String, dynamic>{
        'id': null,
        'code': null,
        'name': null,
        'symbol': null,
      });

      expect(currency.id, 0);
      expect(currency.code, '');
      expect(currency.name, '');
      expect(currency.symbol, '');
    });

    test('toMap and copyWith round-trip', () {
      final currency = WalletCurrency.fromMap(<String, dynamic>{
        'id': 2,
        'code': 'KHR',
        'name': 'Cambodian Riel',
        'symbol': '៛',
      });

      expect(currency.toMap()['code'], 'KHR');
      final copy = currency.copyWith(code: 'USD');
      expect(copy.code, 'USD');
      expect(copy.id, 2);
    });
  });

  group('Wallet', () {
    test('parses from map with minimum fields', () {
      final wallet = Wallet.fromMap(<String, dynamic>{
        'id': 1,
        'balance': '100.50',
        'currency': <String, dynamic>{
          'id': 1,
          'code': 'USD',
          'name': 'US Dollar',
          'symbol': r'$',
        },
        'created_at': '2026-06-01T10:00:00Z',
        'updated_at': '2026-06-01T11:00:00Z',
      });

      expect(wallet.id, 1);
      expect(wallet.balance, 100.5);
      expect(wallet.currency.code, 'USD');
      expect(wallet.createdAt, isNotNull);
      expect(wallet.updatedAt, isNotNull);
    });

    test('parses with zero balance and absent currency', () {
      final wallet = Wallet.fromMap(<String, dynamic>{
        'id': 0,
        'balance': '0',
        'currency': null,
        'created_at': '2026-06-01T10:00:00Z',
        'updated_at': '2026-06-01T11:00:00Z',
      });

      expect(wallet.id, 0);
      expect(wallet.balance, 0.0);
      expect(wallet.currency.code, '');
    });

    test('toMap round-trip', () {
      final wallet = Wallet.fromMap(<String, dynamic>{
        'id': 1,
        'balance': '200.00',
        'currency': <String, dynamic>{
          'id': 2,
          'code': 'KHR',
          'name': 'Cambodian Riel',
          'symbol': '៛',
        },
        'created_at': '2026-06-01T10:00:00Z',
        'updated_at': '2026-06-01T11:00:00Z',
      });

      final map = wallet.toMap();
      expect(map['id'], 1);
      expect(map['balance'], 200.0);
      expect((map['currency'] as Map)['code'], 'KHR');
    });

    test('copyWith overrides specified fields', () {
      final wallet = Wallet.fromMap(<String, dynamic>{
        'id': 1,
        'balance': '50.00',
        'currency': <String, dynamic>{
          'id': 1,
          'code': 'USD',
          'name': 'US Dollar',
          'symbol': r'$',
        },
        'created_at': '2026-06-01T10:00:00Z',
        'updated_at': '2026-06-01T11:00:00Z',
      });

      final copy = wallet.copyWith(balance: 75.0);
      expect(copy.balance, 75.0);
      expect(copy.id, 1);
    });
  });

  group('Wallet.listFromDynamic', () {
    test('parses list from data array', () {
      final wallets = Wallet.listFromDynamic(<String, dynamic>{
        'data': <dynamic>[
          <String, dynamic>{
            'id': 1,
            'balance': '100.00',
            'currency': <String, dynamic>{
              'id': 1,
              'code': 'USD',
              'name': 'US Dollar',
              'symbol': r'$',
            },
            'created_at': '2026-06-01T10:00:00Z',
            'updated_at': '2026-06-01T11:00:00Z',
          },
        ],
      });

      expect(wallets.length, 1);
      expect(wallets.first.id, 1);
      expect(wallets.first.balance, 100.0);
    });

    test('parses list directly from array', () {
      final wallets = Wallet.listFromDynamic(<dynamic>[
        <String, dynamic>{
          'id': 1,
          'balance': '50.00',
          'currency': <String, dynamic>{
            'id': 1,
            'code': 'USD',
            'name': 'US Dollar',
            'symbol': r'$',
          },
          'created_at': '2026-06-01T10:00:00Z',
          'updated_at': '2026-06-01T11:00:00Z',
        },
      ]);

      expect(wallets.length, 1);
    });

    test('returns empty list when value is neither list nor map', () {
      final wallets = Wallet.listFromDynamic('invalid');
      expect(wallets, isEmpty);
    });

    test('returns empty list when data key is not a list', () {
      final wallets = Wallet.listFromDynamic(<String, dynamic>{
        'data': 'not-a-list',
      });
      expect(wallets, isEmpty);
    });
  });
}
