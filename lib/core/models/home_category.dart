enum HomeCategoryIcon {
  leaf,
  fruit,
  rootAndTuber,
  bulmAndStem,
  legume,
  indigenousAndWild,
}

class HomeCategory {
  const HomeCategory({
    required this.icon,
    required this.titleKey,
    this.imageUrl,
    this.slug,
  });

  factory HomeCategory.fromMap(Map<String, dynamic> map) {
    final iconValue = map['icon']?.toString() ?? '';
    return HomeCategory(
      icon: HomeCategory.fromStringUpdate(iconValue),
      titleKey: map['title_key']?.toString() ?? map['title']?.toString() ?? '',
      imageUrl: map['image_url'] as String?,
      slug: map['slug'] as String?,
    );
  }

  final HomeCategoryIcon icon;
  final String titleKey;
  final String? imageUrl;
  final String? slug;

  HomeCategory copyWith({
    HomeCategoryIcon? icon,
    String? titleKey,
    String? imageUrl,
    String? slug,
  }) {
    return HomeCategory(
      icon: icon ?? this.icon,
      titleKey: titleKey ?? this.titleKey,
      imageUrl: imageUrl ?? this.imageUrl,
      slug: slug ?? this.slug,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'icon': icon.name,
      'title_key': titleKey,
      'image_url': imageUrl,
      'slug': slug,
    };
  }

  static HomeCategoryIcon fromStringUpdate(String value) {
    switch (value) {
      case 'fruit':
        return HomeCategoryIcon.fruit;
      case 'rootAndTuber':
        return HomeCategoryIcon.rootAndTuber;
      case 'bulmAndStem':
        return HomeCategoryIcon.bulmAndStem;
      case 'legume':
        return HomeCategoryIcon.legume;
      case 'indigenousAndWild':
        return HomeCategoryIcon.indigenousAndWild;
      case 'leaf':
      default:
        return HomeCategoryIcon.leaf;
    }
  }
}
