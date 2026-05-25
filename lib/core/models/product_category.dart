enum ProductCategoryIcon {
  leaf,
  fruit,
  rootAndTuber,
  bulbAndStem,
  legume,
  indigenousAndWild,
}

class ProductCategory {
  const ProductCategory({
    required this.id,
    required this.icon,
    required this.name,
    this.description,
    this.imageUrl,
    this.slug,
  });

  factory ProductCategory.fromMap(Map<String, dynamic> map) {
    final id = map['id'] as int;
    return ProductCategory(
      id: id,
      icon: ProductCategory.fromIdUpdate(id),
      name: map['name']?.toString() ?? '',
      description: map['description']?.toString(),
      imageUrl: map['image_url'] as String?,
      slug: map['slug'] as String?,
    );
  }

  final int id;
  final ProductCategoryIcon icon;
  final String name;
  final String? description;
  final String? imageUrl;
  final String? slug;

  ProductCategory copyWith({
    int? id,
    ProductCategoryIcon? icon,
    String? name,
    String? description,
    String? imageUrl,
    String? slug,
  }) {
    return ProductCategory(
      id: id ?? this.id,
      icon: icon ?? this.icon,
      name: name ?? this.name,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      slug: slug ?? this.slug,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'icon': icon.name,
      'name': name,
      'description': description,
      'image_url': imageUrl,
      'slug': slug,
    };
  }

  static ProductCategoryIcon fromIdUpdate(int id) {
    switch (id) {
      case 2:
        return ProductCategoryIcon.fruit;
      case 3:
        return ProductCategoryIcon.rootAndTuber;
      case 4:
        return ProductCategoryIcon.bulbAndStem;
      case 5:
        return ProductCategoryIcon.legume;
      case 6:
        return ProductCategoryIcon.indigenousAndWild;
      case 1:
      default:
        return ProductCategoryIcon.leaf;
    }
  }
}
