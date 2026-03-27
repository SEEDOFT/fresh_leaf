class ProductInfo {
  final String title;
  final String subtitle;
  final String description;
  final String imageUrl;
  final List<String> tags;
  final double price;
  final String origin;
  final String harvest;
  final String storage;

  ProductInfo({
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
      title: map['title'] as String? ?? '',
      subtitle: map['subtitle'] as String? ?? '',
      description: map['description'] as String? ?? '',
      imageUrl: map['imageUrl'] as String? ?? '',
      tags: List<String>.from(map['tags'] ?? []),
      price: (map['price'] is num) ? (map['price'] as num).toDouble() : 0.0,
      origin: map['origin'] as String? ?? '',
      harvest: map['harvest'] as String? ?? '',
      storage: map['storage'] as String? ?? '',
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
