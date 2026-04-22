import 'package:fresh_leaf/shared/helpers/helper.dart';

class Wallet {
  const Wallet({
    required this.id,
    required this.balance,
    required this.currency,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Wallet.fromMap(Map<String, dynamic> map) {
    return Wallet(
      id: toInt(map['id']),
      balance: toDouble(map['balance']),
      currency: WalletCurrency.fromMap(
        map['currency'] as Map<String, dynamic>? ?? {},
      ),
      createdAt: toDateTime(map['created_at']),
      updatedAt: toDateTime(map['updated_at']),
    );
  }

  static List<Wallet> listFromDynamic(dynamic value) {
    if (value is! List) return <Wallet>[];

    return value
        .whereType<Map<dynamic, dynamic>>()
        .map<Map<String, dynamic>>(
          (item) => item.map<String, dynamic>(
            (dynamic key, dynamic data) =>
                MapEntry<String, dynamic>(key.toString(), data),
          ),
        )
        .map(Wallet.fromMap)
        .toList();
  }

  final int id;
  final double balance;
  final WalletCurrency currency;
  final DateTime createdAt;
  final DateTime updatedAt;

  Wallet copyWith({
    int? id,
    double? balance,
    WalletCurrency? currency,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Wallet(
      id: id ?? this.id,
      balance: balance ?? this.balance,
      currency: currency ?? this.currency,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toMap() => {
    'id': id,
    'balance': balance,
    'currency': currency.toMap(),
    'created_at': createdAt.toIso8601String(),
    'updated_at': updatedAt.toIso8601String(),
  };
}

class WalletCurrency {
  const WalletCurrency({
    required this.id,
    required this.code,
    required this.name,
    required this.symbol,
  });

  factory WalletCurrency.fromMap(Map<String, dynamic> map) {
    return WalletCurrency(
      id: toInt(map['id']),
      code: formatToString(map['code']),
      name: formatToString(map['name']),
      symbol: formatToString(map['symbol']),
    );
  }

  final int id;
  final String code;
  final String name;
  final String symbol;

  WalletCurrency copyWith({
    int? id,
    String? code,
    String? name,
    String? symbol,
  }) {
    return WalletCurrency(
      id: id ?? this.id,
      code: code ?? this.code,
      name: name ?? this.name,
      symbol: symbol ?? this.symbol,
    );
  }

  Map<String, dynamic> toMap() => {
    'id': id,
    'code': code,
    'name': name,
    'symbol': symbol,
  };
}
