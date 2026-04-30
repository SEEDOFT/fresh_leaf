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
  });

  final HomeCategoryIcon icon;
  final String titleKey;

  HomeCategory copyWith({
    HomeCategoryIcon? icon,
    String? titleKey,
  }) {
    return HomeCategory(
      icon: icon ?? this.icon,
      titleKey: titleKey ?? this.titleKey,
    );
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
