import 'package:fresh_leaf/shared/helpers/helper.dart';

class WishlistItem {
  const WishlistItem({
    required this.title,
    required this.subtitle,
    required this.imageUrl,
    required this.price,
    required this.tag,
  });

  factory WishlistItem.fromMap(Map<String, dynamic> map) {
    return WishlistItem(
      title: formatToString(map['title']),
      subtitle: formatToString(map['subtitle']),
      imageUrl: formatToString(map['image']),
      price: toDouble(map['price']),
      tag: formatToString(map['tag']),
    );
  }

  final String title;
  final String subtitle;
  final String imageUrl;
  final double price;
  final String tag;

  Map<String, dynamic> toMap() => {
    'title': title,
    'subtitle': subtitle,
    'image': imageUrl,
    'price': price,
    'tag': tag,
  };
}
