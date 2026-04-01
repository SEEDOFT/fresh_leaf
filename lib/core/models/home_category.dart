enum HomeCategoryIcon { leaf, apple, mushroom, lemon }

class HomeCategory {
  const HomeCategory({
    required this.icon,
    required this.titleKey,
  });

  final HomeCategoryIcon icon;
  final String titleKey;

  static HomeCategoryIcon fromString(String value) {
    switch (value) {
      case 'apple':
        return HomeCategoryIcon.apple;
      case 'mushroom':
        return HomeCategoryIcon.mushroom;
      case 'lemon':
        return HomeCategoryIcon.lemon;
      case 'leaf':
      default:
        return HomeCategoryIcon.leaf;
    }
  }
}
