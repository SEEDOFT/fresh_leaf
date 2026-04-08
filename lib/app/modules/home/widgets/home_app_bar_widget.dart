import 'package:flutter/material.dart';
import 'package:fresh_leaf/app/modules/home/controllers/home_controller.dart';
import 'package:fresh_leaf/app/routes/app_routes.dart';
import 'package:get/get.dart';

class HomeAppBarWidget extends GetView<HomeController> {
  const HomeAppBarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Obx(
            () => InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: controller.fetchCurrentLocation,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 4,
                  vertical: 2,
                ),
                child: Row(
                  children: [
                    if (controller.isResolvingLocation.value)
                      SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: scheme.onSurface,
                        ),
                      )
                    else
                      Icon(
                        Icons.location_on,
                        color: scheme.onSurface,
                        size: 20,
                      ),
                    const SizedBox(width: 8),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 110,
                          child: Text(
                            controller.locationName.value.isEmpty
                                ? 'home_location_name'.tr
                                : controller.locationName.value,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 110,
                          child: Text(
                            controller.locationRegion.value.isEmpty
                                ? 'home_location_region'.tr
                                : controller.locationRegion.value,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 12,
                              color: scheme.onSurface.withValues(alpha: 0.7),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          Column(
            children: [
              Text(
                'FreshLeaf',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w900,
                  color: scheme.onSurface,
                ),
              ),
              Text(
                'home_brand_subtitle'.tr,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: scheme.onSurface,
                ),
              ),
            ],
          ),
          IconButton(
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(minWidth: 40, minHeight: 40),
            icon: Icon(
              Icons.notifications_outlined,
              size: 22,
              color: scheme.onSurface,
            ),
            onPressed: () async => await Get.toNamed(AppRoutes.notifications),
          ),
        ],
      ),
    );
  }
}
