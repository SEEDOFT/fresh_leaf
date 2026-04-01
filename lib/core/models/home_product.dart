import 'package:fresh_leaf/shared/helpers/helper.dart';

class HomeProduct {
  const HomeProduct({
    required this.image,
    required this.title,
    required this.subtitle,
    required this.priceText,
    required this.badge,
    this.description = '',
    this.tags = const [],
    this.origin = '',
    this.harvest = '',
    this.storage = '',
  });

  factory HomeProduct.fromMap(Map<String, dynamic> map) {
    List<String> safeList(dynamic value) {
      if (value is List) {
        return List<String>.from(value);
      }
      return const [];
    }

    return HomeProduct(
      image: formatToString(map['image']),
      title: formatToString(map['title']),
      subtitle: formatToString(map['subtitle']),
      priceText: formatToString(map['price']),
      badge: formatToString(map['badge']),
      description: formatToString(map['description']),
      tags: safeList(map['tags']),
      origin: formatToString(map['origin']),
      harvest: formatToString(map['harvest']),
      storage: formatToString(map['storage']),
    );
  }

  final String image;
  final String title;
  final String subtitle;
  final String priceText;
  final String badge;
  final String description;
  final List<String> tags;
  final String origin;
  final String harvest;
  final String storage;

  double get priceValue {
    try {
      final cleaned = priceText.replaceAll(RegExp(r'[^0-9\.]'), '');
      return toDouble(cleaned);
    } on Exception catch (_) {
      return 0;
    }
  }

  Map<String, dynamic> toMap() {
    return {
      'image': image,
      'title': title,
      'subtitle': subtitle,
      'price': priceText,
      'badge': badge,
      'description': description,
      'tags': tags,
      'origin': origin,
      'harvest': harvest,
      'storage': storage,
    };
  }
}
