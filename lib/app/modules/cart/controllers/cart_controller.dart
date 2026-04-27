import 'package:get/get.dart';

class CartItem {
  const CartItem({
    required this.title,
    required this.subtitle,
    required this.imageUrl,
    required this.price,
    required this.quantity,
    this.originalPrice,
    this.priceKhr,
  });

  final String title;
  final String subtitle;
  final String imageUrl;
  final double price;
  final int quantity;
  final double? originalPrice;
  final double? priceKhr;

  CartItem copyWith({
    String? title,
    String? subtitle,
    String? imageUrl,
    double? price,
    int? quantity,
    double? originalPrice,
    double? priceKhr,
  }) {
    return CartItem(
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
      imageUrl: imageUrl ?? this.imageUrl,
      price: price ?? this.price,
      quantity: quantity ?? this.quantity,
      originalPrice: originalPrice ?? this.originalPrice,
      priceKhr: priceKhr ?? this.priceKhr,
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
      price: 8,
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

  void addOrIncrementItem({
    required String title,
    required String subtitle,
    required String imageUrl,
    required double price,
    double? originalPrice,
    double? priceKhr,
  }) {
    final index = items.indexWhere(
      (item) => item.title == title && item.subtitle == subtitle,
    );

    if (index >= 0) {
      final current = items[index];
      items[index] = current.copyWith(quantity: current.quantity + 1);
      return;
    }

    items.add(
      CartItem(
        title: title,
        subtitle: subtitle,
        imageUrl: imageUrl,
        price: price,
        quantity: 1,
        originalPrice: originalPrice,
        priceKhr: priceKhr,
      ),
    );
  }
}
