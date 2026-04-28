import 'package:fresh_leaf/core/models/organic_category.dart';
import 'package:fresh_leaf/shared/helpers/helper.dart';
import 'package:get/get.dart';

class OrganicProduct {
  OrganicProduct({
    required this.id,
    required this.nameEn,
    required this.slug,
    required this.availableStock,
    required this.isActive,
    required this.isOrganic,
    this.nameKm,
    this.descriptionEn,
    this.descriptionKm,
    this.sellingUnit,
    this.pricePerUnit,
    this.farmNameLocation,
    this.farmingMethod,
    this.harvestDate,
    this.organicCategoryId,
    this.organicCategory,
    this.productCategoryId,
    this.nutritionData,
    this.shelfLifeDays,
  });

  factory OrganicProduct.fromMap(Map<String, dynamic> map) {
    return OrganicProduct(
      id: map['id'] as int,
      nameEn: formatToString(map['name_en']),
      slug: formatToString(map['slug']),
      availableStock: toDouble(map['available_stock']),
      isActive: (map['is_active'] is bool)
          ? map['is_active'] as bool
          : (map['is_active'] == 1),
      isOrganic: (map['is_organic'] is bool)
          ? map['is_organic'] as bool
          : (map['is_organic'] == 1),
      nameKm: formatToString(map['name_km']),
      descriptionEn: formatToString(map['description_en']),
      descriptionKm: formatToString(map['description_km']),
      sellingUnit: formatToString(map['selling_unit']),
      pricePerUnit: toDouble(map['price_per_unit']),
      farmNameLocation: formatToString(map['farm_name_location']),
      farmingMethod: formatToString(map['farming_method']),
      harvestDate: map['harvest_date'] != null
          ? DateTime.tryParse(map['harvest_date'].toString())
          : null,
      organicCategoryId: map['organic_category_id'] as int?,
      organicCategory: map['organic_category'] != null
          ? OrganicCategory.fromMap(
              map['organic_category'] as Map<String, dynamic>,
            )
          : null,
      productCategoryId: map['product_category_id'] as int?,
      nutritionData: map['nutrition_data'] as Map<String, dynamic>?,
      shelfLifeDays: map['shelf_life_days'] as int?,
    );
  }

  final int id;
  final String nameEn;
  final String slug;
  final double availableStock;
  final bool isActive;
  final bool isOrganic;
  final String? nameKm;
  final String? descriptionEn;
  final String? descriptionKm;
  final String? sellingUnit;
  final double? pricePerUnit;
  final String? farmNameLocation;
  final String? farmingMethod;
  final DateTime? harvestDate;
  final int? organicCategoryId;
  final OrganicCategory? organicCategory;
  final int? productCategoryId;
  final Map<String, dynamic>? nutritionData;
  final int? shelfLifeDays;

  String get localizedName =>
      Get.locale?.languageCode == 'km' ? (nameKm ?? nameEn) : nameEn;

  String get localizedDescription => (Get.locale?.languageCode == 'km'
          ? (descriptionKm ?? descriptionEn)
          : descriptionEn) ??
      '';

  String get farmingMethodLabel {
    switch (farmingMethod) {
      case 'certified_organic':
        return 'certified_organic'.tr;
      case 'pesticide_free':
        return 'pesticide_free'.tr;
      case 'naturally_grown':
        return 'naturally_grown'.tr;
      default:
        return farmingMethod ?? '';
    }
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name_en': nameEn,
      'name_km': nameKm,
      'slug': slug,
      'description_en': descriptionEn,
      'description_km': descriptionKm,
      'selling_unit': sellingUnit,
      'price_per_unit': pricePerUnit,
      'available_stock': availableStock,
      'farm_name_location': farmNameLocation,
      'farming_method': farmingMethod,
      'harvest_date': harvestDate?.toIso8601String(),
      'is_active': isActive,
      'is_organic': isOrganic,
      'organic_category_id': organicCategoryId,
      'organic_category': organicCategory?.toMap(),
      'product_category_id': productCategoryId,
      'nutrition_data': nutritionData,
      'shelf_life_days': shelfLifeDays,
    };
  }
}
