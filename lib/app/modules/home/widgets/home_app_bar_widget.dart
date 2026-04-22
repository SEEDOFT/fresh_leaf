import 'package:flutter/material.dart';
import 'package:fresh_leaf/app/modules/home/controllers/home_controller.dart';
import 'package:fresh_leaf/app/routes/app_routes.dart';
import 'package:fresh_leaf/shared/helpers/responsive_helper.dart';
import 'package:get/get.dart';

class HomeAppBarWidget extends GetView<HomeController> {
  const HomeAppBarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.scaled),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Obx(
            () => InkWell(
              borderRadius: BorderRadius.circular(12.scaled),
              onTap: controller.fetchCurrentLocation,
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 4.scaled,
                  vertical: 2.scaled,
                ),
                child: Row(
                  children: [
                    if (controller.isResolvingLocation.value)
                      SizedBox(
                        width: 20.scaled,
                        height: 20.scaled,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: scheme.onSurface,
                        ),
                      )
                    else
                      Icon(
                        Icons.location_on,
                        color: scheme.onSurface,
                        size: 20.scaled,
                      ),
                    SizedBox(width: 8.scaled),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 110.scaled,
                          child: Text(
                            controller.locationName.value.isEmpty
                                ? 'home_location_name'.tr
                                : controller.locationName.value,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 12.scaled,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 110.scaled,
                          child: Text(
                            controller.locationRegion.value.isEmpty
                                ? 'home_location_region'.tr
                                : controller.locationRegion.value,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 12.scaled,
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
                  fontSize: 16.scaled,
                  fontWeight: FontWeight.w900,
                  color: scheme.onSurface,
                ),
              ),
              Text(
                'home_brand_subtitle'.tr,
                style: TextStyle(
                  fontSize: 14.scaled,
                  fontWeight: FontWeight.w600,
                  color: scheme.onSurface,
                ),
              ),
            ],
          ),
          IconButton(
            padding: EdgeInsets.zero,
            constraints: BoxConstraints(
              minWidth: 40.scaled,
              minHeight: 40.scaled,
            ),
            icon: Icon(
              Icons.notifications_outlined,
              size: 22.scaled,
              color: scheme.onSurface,
            ),
            onPressed: () async => await Get.toNamed(AppRoutes.notifications),
          ),
        ],
      ),
    );
  }
}
