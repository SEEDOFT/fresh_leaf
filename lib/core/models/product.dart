import 'package:fresh_leaf/shared/helpers/helper.dart';

class Product {
  Product({
    required this.id,
    required this.name,
    required this.slug,
    required this.description,
    this.imageUrl,
    this.nutritionData,
    this.productCategoryId,
    this.productCategoryName,
    this.typeId,
    this.typeName,
    this.statusId,
    this.statusName,
  });

  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      id: map['id'] as int,
      name: formatToString(map['name']),
      slug: formatToString(map['slug']),
      description: formatToString(map['description']),
      imageUrl: formatToString(map['image_url']),
      nutritionData: map['nutrition_data'] as Map<String, dynamic>?,
      productCategoryId:
          (map['product_category'] as Map<String, dynamic>?)?['id'] as int?,
      productCategoryName:
          (map['product_category'] as Map<String, dynamic>?)?['name']
              as String?,
      typeId: (map['type'] as Map<String, dynamic>?)?['id'] as int?,
      typeName: (map['type'] as Map<String, dynamic>?)?['name'] as String?,
      statusId: (map['status'] as Map<String, dynamic>?)?['id'] as int?,
      statusName: (map['status'] as Map<String, dynamic>?)?['name'] as String?,
    );
  }

  final int id;
  final String name;
  final String slug;
  final String description;
  final String? imageUrl;
  final Map<String, dynamic>? nutritionData;
  final int? productCategoryId;
  final String? productCategoryName;
  final int? typeId;
  final String? typeName;
  final int? statusId;
  final String? statusName;

  String get localizedName => name;
  String get localizedDescription => description;
}
