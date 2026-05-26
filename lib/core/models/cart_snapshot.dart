import 'package:fresh_leaf/core/models/cart_item.dart';
import 'package:fresh_leaf/core/models/money_display.dart';

class CartSnapshot {
  const CartSnapshot({
    required this.items,
    required this.totalDisplay,
  });

  static const empty = CartSnapshot(
    items: <CartItem>[],
    totalDisplay: MoneyDisplay.empty,
  );

  final List<CartItem> items;
  final MoneyDisplay totalDisplay;
}
