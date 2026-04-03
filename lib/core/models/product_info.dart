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

  ProductInfo copyWith({
    String? title,
    String? subtitle,
    String? description,
    String? imageUrl,
    List<String>? tags,
    double? price,
    String? origin,
    String? harvest,
    String? storage,
  }) {
    return ProductInfo(
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      tags: tags ?? this.tags,
      price: price ?? this.price,
      origin: origin ?? this.origin,
      harvest: harvest ?? this.harvest,
      storage: storage ?? this.storage,
    );
  }

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
