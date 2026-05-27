import 'package:fresh_leaf/core/models/money_display.dart';
import 'package:fresh_leaf/core/models/product.dart';
import 'package:fresh_leaf/shared/helpers/helper.dart';

class VendorInventory {
  VendorInventory({
    required this.id,
    required this.price,
    required this.stockQuantity,
    this.harvestDate,
    this.harvestDateHuman,
    this.farmLocation,
    this.provinceOfOrigin,
    this.certificationType,
    this.packagingTypeId,
    this.packagingTypeName,
    this.shelfLifeDays,
    this.batchImages,
    this.unitId,
    this.unitName,
    this.unitSymbol,
    this.vendorId,
    this.vendorName,
    this.vendorPhone,
    this.vendorEmail,
    this.vendorAddress,
    this.vendorBusinessName,
    this.vendorShopDescription,
    this.vendorStoreFrontImage,
    this.vendorProvince,
    this.vendorOpeningTime,
    this.vendorClosingTime,
    this.vendorIsOpen = false,
    this.vendorIsVerified = false,
    this.vendorProductCount = 0,
    this.statusId,
    this.statusName,
    this.currencyId,
    this.currencyCode,
    this.currencyName,
    this.currencySymbol,
    this.product,
    this.discountPercentage = 0.0,
    this.priceDisplay = MoneyDisplay.empty,
    this.discountedPriceDisplay = MoneyDisplay.empty,
  });

  factory VendorInventory.fromMap(Map<String, dynamic> map) {
    return VendorInventory(
      id: map['id'] as int,
      price: toDouble(map['price']),
      stockQuantity: toDouble(map['stock_quantity']),
      harvestDate: map['harvest_date'] != null
          ? DateTime.tryParse(map['harvest_date'].toString())
          : null,
      harvestDateHuman: map['harvest_date_human']?.toString(),
      farmLocation: formatToString(map['farm_location']),
      provinceOfOrigin: formatToString(map['province_of_origin']),
      certificationType: formatToString(map['certification_type']),
      packagingTypeId:
          (map['packaging_type'] as Map<String, dynamic>?)?['id'] as int?,
      packagingTypeName:
          (map['packaging_type'] as Map<String, dynamic>?)?['name'] as String?,
      shelfLifeDays: map['shelf_life_days'] as int?,
      batchImages: (map['batch_images'] as List<dynamic>?)
          ?.map((e) => e.toString())
          .toList(),
      unitId: (map['unit'] as Map<String, dynamic>?)?['id'] as int?,
      unitName: (map['unit'] as Map<String, dynamic>?)?['name'] as String?,
      unitSymbol: (map['unit'] as Map<String, dynamic>?)?['symbol'] as String?,
      vendorId: (map['vendor'] as Map<String, dynamic>?)?['id'] as int?,
      vendorName: (map['vendor'] as Map<String, dynamic>?)?['name'] as String?,
      vendorPhone:
          (map['vendor'] as Map<String, dynamic>?)?['phone'] as String?,
      vendorEmail:
          (map['vendor'] as Map<String, dynamic>?)?['email'] as String?,
      vendorAddress:
          (map['vendor'] as Map<String, dynamic>?)?['address'] as String?,
      vendorBusinessName:
          (map['vendor'] as Map<String, dynamic>?)?['business_name'] as String?,
      vendorShopDescription:
          (map['vendor'] as Map<String, dynamic>?)?['shop_description']
              as String?,
      vendorStoreFrontImage:
          (map['vendor'] as Map<String, dynamic>?)?['store_front_image']
              as String?,
      vendorProvince:
          (map['vendor'] as Map<String, dynamic>?)?['province'] as String?,
      vendorOpeningTime:
          (map['vendor'] as Map<String, dynamic>?)?['opening_time'] as String?,
      vendorClosingTime:
          (map['vendor'] as Map<String, dynamic>?)?['closing_time'] as String?,
      vendorIsOpen:
          (map['vendor'] as Map<String, dynamic>?)?['is_open'] as bool? ??
          false,
      vendorIsVerified:
          (map['vendor'] as Map<String, dynamic>?)?['is_verified'] as bool? ??
          false,
      vendorProductCount:
          (map['vendor'] as Map<String, dynamic>?)?['product_count'] as int? ??
          0,
      statusId: (map['status'] as Map<String, dynamic>?)?['id'] as int?,
      statusName: (map['status'] as Map<String, dynamic>?)?['name'] as String?,
      currencyId: (map['currency'] as Map<String, dynamic>?)?['id'] as int?,
      currencyCode:
          (map['currency'] as Map<String, dynamic>?)?['code'] as String?,
      currencyName:
          (map['currency'] as Map<String, dynamic>?)?['name'] as String?,
      currencySymbol:
          (map['currency'] as Map<String, dynamic>?)?['symbol'] as String?,
      product: map['product'] != null
          ? Product.fromMap(map['product'] as Map<String, dynamic>)
          : null,
      discountPercentage: toDouble(map['discount_percentage']),
      priceDisplay: MoneyDisplay.fromMap(map['price_display']),
      discountedPriceDisplay: MoneyDisplay.fromMap(
        map['discounted_price_display'],
      ),
    );
  }

  final int id;
  final double price;
  final double stockQuantity;
  final DateTime? harvestDate;
  final String? harvestDateHuman;
  final String? farmLocation;
  final String? provinceOfOrigin;
  final String? certificationType;
  final int? packagingTypeId;
  final String? packagingTypeName;
  final int? shelfLifeDays;
  final List<String>? batchImages;
  final int? unitId;
  final String? unitName;
  final String? unitSymbol;
  final int? vendorId;
  final String? vendorName;
  final String? vendorPhone;
  final String? vendorEmail;
  final String? vendorAddress;
  final String? vendorBusinessName;
  final String? vendorShopDescription;
  final String? vendorStoreFrontImage;
  final String? vendorProvince;
  final String? vendorOpeningTime;
  final String? vendorClosingTime;
  final bool vendorIsOpen;
  final bool vendorIsVerified;
  final int vendorProductCount;
  final int? statusId;
  final String? statusName;
  final int? currencyId;
  final String? currencyCode;
  final String? currencyName;
  final String? currencySymbol;
  final Product? product;
  final double discountPercentage;
  final MoneyDisplay priceDisplay;
  final MoneyDisplay discountedPriceDisplay;

  double get finalPrice {
    final discount = discountPercentage.clamp(0.0, 100.0) / 100.0;
    return price * (1 - discount);
  }

  MoneyDisplay get resolvedPriceDisplay {
    if (!priceDisplay.isEmpty) return priceDisplay;
    return MoneyDisplay.fromCurrencyAmount(
      amount: price,
      currencyId: currencyId,
    );
  }

  MoneyDisplay get resolvedFinalPriceDisplay {
    if (!discountedPriceDisplay.isEmpty) return discountedPriceDisplay;
    if (!priceDisplay.isEmpty && discountPercentage > 0) {
      final discount = discountPercentage.clamp(0.0, 100.0) / 100.0;
      return priceDisplay.multiply(1 - discount);
    }
    if (!priceDisplay.isEmpty) return priceDisplay;
    return MoneyDisplay.fromCurrencyAmount(
      amount: finalPrice,
      currencyId: currencyId,
    );
  }

  // Helpers to map old ProductInfo properties to new VendorInventory structure
  String get displayTitle => product?.localizedName ?? '';
  String get displaySubtitle => packagingTypeName ?? '';
  String get displayDescription => product?.localizedDescription ?? '';
  String get displayImageUrl {
    if (batchImages != null && batchImages!.isNotEmpty) {
      return batchImages!.first;
    }
    return product?.imageUrl ?? '';
  }
}
