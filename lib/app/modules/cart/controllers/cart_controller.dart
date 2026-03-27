import 'package:get/get.dart';

class CartItem {
  const CartItem({
    required this.title,
    required this.subtitle,
    required this.imageUrl,
    required this.price,
    required this.quantity,
  });

  final String title;
  final String subtitle;
  final String imageUrl;
  final double price;
  final int quantity;

  CartItem copyWith({
    String? title,
    String? subtitle,
    String? imageUrl,
    double? price,
    int? quantity,
  }) {
    return CartItem(
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
      imageUrl: imageUrl ?? this.imageUrl,
      price: price ?? this.price,
      quantity: quantity ?? this.quantity,
    );
  }
}

class CartController extends GetxController {
  final RxList<CartItem> items = <CartItem>[
    const CartItem(
      title: 'Heritage Carrots',
      subtitle: 'Rainbow bunch, 500g',
      imageUrl:
          'https://images.unsplash.com/photo-1598170845058-32b9d6a5da37?q=80&w=600',
      price: 4.50,
      quantity: 2,
    ),
    const CartItem(
      title: 'Golden Oysters',
      subtitle: 'Wild harvested, 200g',
      imageUrl:
          'https://images.unsplash.com/photo-1604544025999-4c8d550e0d5a?q=80&w=600',
      price: 8.00,
      quantity: 1,
    ),
  ].obs;

  double get subtotal {
    return items.fold(
      0,
      (sum, item) => sum + (item.price * item.quantity),
    );
  }

  double get deliveryFee => items.isEmpty ? 0 : 1.75;

  double get total => subtotal + deliveryFee;

  void increaseQuantity(int index) {
    final current = items[index];
    items[index] = current.copyWith(quantity: current.quantity + 1);
  }

  void decreaseQuantity(int index) {
    final current = items[index];
    if (current.quantity <= 1) {
      items.removeAt(index);
      return;
    }
    items[index] = current.copyWith(quantity: current.quantity - 1);
  }

  void clearCart() {
    items.clear();
  }
}
