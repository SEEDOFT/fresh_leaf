import 'dart:async';
import 'package:flutter/material.dart';
import 'package:fresh_leaf/app/routes/app_routes.dart';
import 'package:fresh_leaf/core/models/vendor_inventory.dart';
import 'package:get/get.dart';

class ProductDetailVendorCard extends StatelessWidget {
  const ProductDetailVendorCard({
    required this.product,
    super.key,
  });

  final VendorInventory product;

  @override
  Widget build(BuildContext context) {
    if (product.vendorId == null) {
      return const SizedBox.shrink();
    }

    final scheme = Theme.of(context).colorScheme;
    final businessName =
        product.vendorBusinessName ?? product.vendorName ?? 'unknown_vendor'.tr;
    final isVerified = product.vendorIsVerified;
    final province = product.vendorProvince ?? product.provinceOfOrigin ?? '';
    final shopDescription = product.vendorShopDescription ?? '';

    return InkWell(
      onTap: () {
        unawaited(
          Get.toNamed<void>(
            AppRoutes.vendorProfile,
            arguments: product.vendorId,
          ),
        );
      },
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: scheme.surfaceContainerLow,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: scheme.outlineVariant.withValues(alpha: 0.5),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            // Store Avatar/Profile
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [
                    scheme.primaryContainer,
                    scheme.tertiaryContainer,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                image:
                    product.vendorStoreFrontImage != null &&
                        product.vendorStoreFrontImage!.isNotEmpty
                    ? DecorationImage(
                        image: NetworkImage(product.vendorStoreFrontImage!),
                        fit: BoxFit.cover,
                      )
                    : null,
              ),
              child:
                  product.vendorStoreFrontImage == null ||
                      product.vendorStoreFrontImage!.isEmpty
                  ? Center(
                      child: Text(
                        businessName.isNotEmpty
                            ? businessName[0].toUpperCase()
                            : 'V',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: scheme.onPrimaryContainer,
                        ),
                      ),
                    )
                  : null,
            ),
            const SizedBox(width: 14),
            // Vendor Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          businessName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                            color: scheme.onSurface,
                          ),
                        ),
                      ),
                      if (isVerified) ...[
                        const SizedBox(width: 4),
                        Icon(
                          Icons.verified,
                          size: 16,
                          color: scheme.primary,
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(
                        Icons.location_on_rounded,
                        size: 13,
                        color: scheme.onSurfaceVariant.withValues(
                          alpha: 0.7,
                        ),
                      ),
                      const SizedBox(width: 3),
                      Text(
                        province,
                        style: TextStyle(
                          fontSize: 12,
                          color: scheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                  if (shopDescription.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      shopDescription,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 12,
                        color: scheme.onSurfaceVariant.withValues(
                          alpha: 0.8,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(width: 8),
            // View Shop Chevron
            Icon(
              Icons.chevron_right_rounded,
              color: scheme.onSurfaceVariant,
            ),
          ],
        ),
      ),
    );
  }
}
