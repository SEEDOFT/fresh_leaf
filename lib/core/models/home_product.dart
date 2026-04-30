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
    this.shareSlug = '',
    this.shareDeepLink = '',
    this.activePrice = 0.0,
    this.activePriceKhr = 0.0,
    this.discountPercentage = 0,
    this.originalPrice = 0.0,
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
      shareSlug: formatToString(map['shareSlug']),
      shareDeepLink: formatToString(map['shareDeepLink']),
      activePrice: toDouble(map['activePrice']),
      activePriceKhr: toDouble(map['activePriceKhr']),
      discountPercentage: toInt(map['discountPercentage']),
      originalPrice: toDouble(map['originalPrice']),
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
  final String shareSlug;
  final String shareDeepLink;
  final double activePrice;
  final double activePriceKhr;
  final int discountPercentage;
  final double originalPrice;

  bool get hasDiscount => discountPercentage > 0;

  double get priceValue {
    try {
      final cleaned = priceText.replaceAll(RegExp(r'[^0-9\.]'), '');
      return toDouble(cleaned);
    } on Exception {
      return 0;
    }
  }

  HomeProduct copyWith({
    String? image,
    String? title,
    String? subtitle,
    String? priceText,
    String? badge,
    String? description,
    List<String>? tags,
    String? origin,
    String? harvest,
    String? storage,
    String? shareSlug,
    String? shareDeepLink,
    double? activePrice,
    double? activePriceKhr,
    int? discountPercentage,
    double? originalPrice,
  }) {
    return HomeProduct(
      image: image ?? this.image,
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
      priceText: priceText ?? this.priceText,
      badge: badge ?? this.badge,
      description: description ?? this.description,
      tags: tags ?? this.tags,
      origin: origin ?? this.origin,
      harvest: harvest ?? this.harvest,
      storage: storage ?? this.storage,
      shareSlug: shareSlug ?? this.shareSlug,
      shareDeepLink: shareDeepLink ?? this.shareDeepLink,
      activePrice: activePrice ?? this.activePrice,
      activePriceKhr: activePriceKhr ?? this.activePriceKhr,
      discountPercentage: discountPercentage ?? this.discountPercentage,
      originalPrice: originalPrice ?? this.originalPrice,
    );
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
      'shareSlug': shareSlug,
      'shareDeepLink': shareDeepLink,
      'activePrice': activePrice,
      'activePriceKhr': activePriceKhr,
      'discountPercentage': discountPercentage,
      'originalPrice': originalPrice,
    };
  }
}
