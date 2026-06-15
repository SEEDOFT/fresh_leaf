import 'package:flutter/material.dart';
import 'package:fresh_leaf/app/modules/orders/controllers/orders_controller.dart';
import 'package:fresh_leaf/app/modules/orders/widgets/orders_widget.dart';
import 'package:fresh_leaf/app/routes/app_routes.dart';
import 'package:fresh_leaf/shared/widgets/app_scaffold.dart';
import 'package:fresh_leaf/shared/widgets/custom_app_bar.dart';
import 'package:get/get.dart';

class OrdersView extends GetView<OrdersController> {
  const OrdersView({super.key});

  @override
  Widget build(BuildContext context) {
    final showAppBar = _showAppBarFromArgs();
    final scheme = Theme.of(context).colorScheme;

    return AppScaffold(
      appBar: showAppBar
          ? CustomAppBar(
              title: 'orders'.tr,
              showChatButton: true,
            )
          : null,
      safeAreaTop: !showAppBar,
      scrollable: false,
      padding: EdgeInsets.zero,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!showAppBar) const OrdersTabTitleWidget(),
          if (!showAppBar) const SizedBox(height: 10),
          const SizedBox(height: 20),
          Obx(
            () => OrdersControlsWidget(
              controller: controller,
              selectedStatusId: controller.selectedStatusId,
              statusCounts: Map.from(controller.statusCounts),
              onStatusChanged: (statusId) =>
                  controller.selectedStatusId = statusId,
              scheme: scheme,
            ),
          ),
          const SizedBox(height: 10),
          Obx(
            () => OrdersSortSummaryChipWidget(
              label: _sortLabel(controller.selectedSort),
              selectedSort: controller.selectedSort,
              onSortChanged: (sort) => controller.selectedSort = sort,
              scheme: scheme,
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: Obx(
              () => RefreshIndicator(
                onRefresh: controller.refreshList,
                child: controller.isLoading.value
                    ? const OrdersLoadingWidget()
                    : controller.items.isEmpty
                    ? ListView(
                        physics: const AlwaysScrollableScrollPhysics(
                          parent: BouncingScrollPhysics(),
                        ),
                        children: [
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.6,
                            child: const OrdersEmptyStateWidget(),
                          ),
                        ],
                      )
                    : PageView.builder(
                        controller: controller.pageController,
                        onPageChanged: controller.onPageChanged,
                        itemCount: controller.statusFilters.length,
                        itemBuilder: (context, index) {
                          final statusId =
                              controller.statusFilters[index]['id'] as int;
                          final list = controller.getOrdersForStatus(statusId);
                          final grouped = controller.getGroupedOrdersForStatus(
                            list,
                          );

                          if (list.isEmpty) {
                            return ListView(
                              physics: const AlwaysScrollableScrollPhysics(
                                parent: BouncingScrollPhysics(),
                              ),
                              children: [
                                SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * 0.6,
                                  child: const OrdersEmptyStateWidget(
                                    filtered: true,
                                  ),
                                ),
                              ],
                            );
                          }

                          return OrdersListWidget(
                            key: ValueKey<String>(
                              '$statusId'
                              '-${controller.selectedSort.name}'
                              '-${list.length}',
                            ),
                            groupedOrders: grouped,
                            scheme: scheme,
                            onLoadMore: controller.loadMore,
                            isLoadingMore: controller.isLoadingMore,
                            hasMore: controller.hasMore,
                            onOrderTap: (order) async {
                              final detailedOrder = await controller
                                  .preloadOrderDetail(order);
                              if (detailedOrder == null) {
                                Get.snackbar(
                                  'fetch_failed'.tr,
                                  'order_not_found'.tr,
                                );
                                return;
                              }
                              await Get.toNamed<void>(
                                AppRoutes.orderDetail,
                                arguments: detailedOrder,
                              );
                            },
                          );
                        },
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  bool _showAppBarFromArgs() {
    final args = Get.arguments;
    if (args is Map<String, dynamic>) {
      return args['show_app_bar'] == true;
    }
    if (args is Map) {
      return args['show_app_bar'] == true;
    }
    return false;
  }

  String _sortLabel(OrderSortType sortType) {
    switch (sortType) {
      case OrderSortType.newest:
        return 'orders_sort_newest'.tr;
      case OrderSortType.oldest:
        return 'orders_sort_oldest'.tr;
      case OrderSortType.highestTotal:
        return 'orders_sort_highest_total'.tr;
    }
  }
}
