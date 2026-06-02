import 'package:flutter/material.dart';
import 'package:fresh_leaf/app/modules/home/controllers/home_controller.dart';
import 'package:fresh_leaf/app/routes/app_routes.dart';
import 'package:fresh_leaf/core/constants/app_sizes.dart';
import 'package:fresh_leaf/core/controllers/wishlist_controller.dart';
import 'package:fresh_leaf/core/services/notification_service.dart';
import 'package:get/get.dart';

class HomeAppBarWidget extends GetView<HomeController> {
  const HomeAppBarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: AppSizes.s24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: Obx(
              () => InkWell(
                borderRadius: BorderRadius.circular(AppSizes.s12),
                onTap: controller.fetchCurrentLocation,
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: AppSizes.s4,
                    vertical: AppSizes.s2,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (controller.isResolvingLocation.value)
                        SizedBox(
                          width: AppSizes.s20,
                          height: AppSizes.s20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: scheme.onSurface,
                          ),
                        )
                      else
                        Icon(
                          Icons.location_on,
                          color: scheme.onSurface,
                          size: AppSizes.s20,
                        ),
                      SizedBox(width: AppSizes.s8),
                      Flexible(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ConstrainedBox(
                              constraints: BoxConstraints(
                                maxWidth: AppSizes.s110,
                              ),
                              child: Text(
                                controller.locationName.value.isEmpty
                                    ? 'home_location_name'.tr
                                    : controller.locationName.value,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: AppSizes.s12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            ConstrainedBox(
                              constraints: BoxConstraints(
                                maxWidth: AppSizes.s110,
                              ),
                              child: Text(
                                controller.locationRegion.value.isEmpty
                                    ? 'home_location_region'.tr
                                    : controller.locationRegion.value,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: AppSizes.s12,
                                  color: scheme.onSurface.withValues(
                                    alpha: 0.7,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Column(
            children: [
              Text(
                'FreshLeaf',
                style: TextStyle(
                  fontSize: AppSizes.s16,
                  fontWeight: FontWeight.w900,
                  color: scheme.onSurface,
                ),
              ),
              Text(
                'home_brand_subtitle'.tr,
                style: TextStyle(
                  fontSize: AppSizes.s14,
                  fontWeight: FontWeight.w600,
                  color: scheme.onSurface,
                ),
              ),
            ],
          ),
          Row(
            children: [
              Obx(() {
                final notificationService = Get.find<NotificationService>();
                final count = notificationService.unreadChatCount.value;

                return IconButton(
                  padding: EdgeInsets.zero,
                  constraints: BoxConstraints(
                    minWidth: AppSizes.s40,
                    minHeight: AppSizes.s40,
                  ),
                  icon: count > 0
                      ? Badge(
                          label: Text(count > 99 ? '99+' : count.toString()),
                          child: Icon(
                            Icons.chat_bubble_outline,
                            size: AppSizes.s22,
                            color: scheme.onSurface,
                          ),
                        )
                      : Icon(
                          Icons.chat_bubble_outline,
                          size: AppSizes.s22,
                          color: scheme.onSurface,
                        ),
                  onPressed: () async =>
                      await Get.toNamed(AppRoutes.supportTickets),
                );
              }),
              Obx(() {
                final wishlistController = Get.find<WishlistController>();
                final count = wishlistController.items.length;

                return IconButton(
                  padding: EdgeInsets.zero,
                  constraints: BoxConstraints(
                    minWidth: AppSizes.s40,
                    minHeight: AppSizes.s40,
                  ),
                  icon: count > 0
                      ? Badge(
                          label: Text(count > 99 ? '99+' : count.toString()),
                          child: Icon(
                            Icons.favorite_border_rounded,
                            size: AppSizes.s22,
                            color: scheme.onSurface,
                          ),
                        )
                      : Icon(
                          Icons.favorite_border_rounded,
                          size: AppSizes.s22,
                          color: scheme.onSurface,
                        ),
                  onPressed: () async => await Get.toNamed(AppRoutes.wishlist),
                );
              }),
              Obx(() {
                final notificationService = Get.find<NotificationService>();
                final count = notificationService.unreadCount.value;
                return IconButton(
                  padding: EdgeInsets.zero,
                  constraints: BoxConstraints(
                    minWidth: AppSizes.s40,
                    minHeight: AppSizes.s40,
                  ),
                  icon: count > 0
                      ? Badge(
                          label: Text(count > 99 ? '99+' : count.toString()),
                          child: Icon(
                            Icons.notifications_outlined,
                            size: AppSizes.s22,
                            color: scheme.onSurface,
                          ),
                        )
                      : Icon(
                          Icons.notifications_outlined,
                          size: AppSizes.s22,
                          color: scheme.onSurface,
                        ),
                  onPressed: () async =>
                      await Get.toNamed(AppRoutes.notifications),
                );
              }),
            ],
          ),
        ],
      ),
    );
  }
}
