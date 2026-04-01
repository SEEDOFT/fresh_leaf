import 'package:fresh_leaf/shared/helpers/helper.dart';

class ProductInfo {
  const ProductInfo({
    required this.title,
    required this.subtitle,
    required this.description,
    required this.imageUrl,
    required this.tags,
    required this.price,
    required this.origin,
    required this.harvest,
    required this.storage,
  });

  factory ProductInfo.fromMap(Map<String, dynamic> map) {
    return ProductInfo(
      title: formatToString(map['title']),
      subtitle: formatToString(map['subtitle']),
      description: formatToString(map['description']),
      imageUrl: formatToString(map['imageUrl']),
      tags: List<String>.from((map['tags'] as List<dynamic>?) ?? const []),
      price: toDouble(map['price']),
      origin: formatToString(map['origin']),
      harvest: formatToString(map['harvest']),
      storage: formatToString(map['storage']),
    );
  }

  final String title;
  final String subtitle;
  final String description;
  final String imageUrl;
  final List<String> tags;
  final double price;
  final String origin;
  final String harvest;
  final String storage;

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'subtitle': subtitle,
      'description': description,
      'imageUrl': imageUrl,
      'tags': tags,
      'price': price,
      'origin': origin,
      'harvest': harvest,
      'storage': storage,
    };
  }
}
