import 'package:get/get.dart';

class OrganicCategory {
  OrganicCategory({
    required this.id,
    required this.nameEn,
    required this.nameKm,
    required this.slug,
    required this.isActive,
    this.descriptionEn,
    this.descriptionKm,
    this.imageUrl,
  });

  factory OrganicCategory.fromMap(Map<String, dynamic> map) {
    return OrganicCategory(
      id: map['id'] as int,
      nameEn: map['name_en'] as String,
      nameKm: map['name_km'] as String,
      slug: map['slug'] as String,
      isActive: (map['is_active'] is bool)
          ? map['is_active'] as bool
          : (map['is_active'] == 1),
      descriptionEn: map['description_en'] as String?,
      descriptionKm: map['description_km'] as String?,
      imageUrl: map['image_url'] as String?,
    );
  }

  final int id;
  final String nameEn;
  final String nameKm;
  final String slug;
  final bool isActive;
  final String? descriptionEn;
  final String? descriptionKm;
  final String? imageUrl;

  String get localizedName =>
      Get.locale?.languageCode == 'km' ? nameKm : nameEn;

  String get localizedDescription {
    if (Get.locale?.languageCode == 'km') {
      return descriptionKm ?? descriptionEn ?? '';
    }
    return descriptionEn ?? '';
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name_en': nameEn,
      'name_km': nameKm,
      'description_en': descriptionEn,
      'description_km': descriptionKm,
      'slug': slug,
      'image_url': imageUrl,
      'is_active': isActive,
    };
  }
}
