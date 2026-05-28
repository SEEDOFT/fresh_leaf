import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PaginatedListView<T> extends StatelessWidget {
  const PaginatedListView({
    required this.items,
    required this.itemBuilder,
    required this.onLoadMore,
    required this.isLoadingMore,
    required this.hasMore,
    this.padding,
    this.separatorBuilder,
    this.emptyWidget,
    super.key,
  });

  final List<T> items;
  final Widget Function(BuildContext, int, T) itemBuilder;
  final VoidCallback onLoadMore;
  final RxBool isLoadingMore;
  final RxBool hasMore;
  final EdgeInsetsGeometry? padding;
  final Widget Function(BuildContext, int)? separatorBuilder;
  final Widget? emptyWidget;

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return emptyWidget ?? Center(child: Text('common_no_items_found'.tr));
    }

    return NotificationListener<ScrollNotification>(
      onNotification: (scrollInfo) {
        if (!isLoadingMore.value &&
            hasMore.value &&
            scrollInfo.metrics.pixels >=
                scrollInfo.metrics.maxScrollExtent - 200) {
          onLoadMore();
        }
        return false;
      },
      child: separatorBuilder != null
          ? ListView.separated(
              padding: padding,
              itemCount: items.length + 1,
              separatorBuilder: (context, index) {
                if (index == items.length) return const SizedBox.shrink();
                return separatorBuilder!(context, index);
              },
              itemBuilder: _buildItem,
            )
          : ListView.builder(
              padding: padding,
              itemCount: items.length + 1,
              itemBuilder: _buildItem,
            ),
    );
  }

  Widget _buildItem(BuildContext context, int index) {
    if (index == items.length) {
      return Obx(() {
        if (isLoadingMore.value) {
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: Center(child: CircularProgressIndicator()),
          );
        }
        return const SizedBox.shrink();
      });
    }
    return itemBuilder(context, index, items[index]);
  }
}

class PaginatedGridView<T> extends StatelessWidget {
  const PaginatedGridView({
    required this.items,
    required this.itemBuilder,
    required this.onLoadMore,
    required this.isLoadingMore,
    required this.hasMore,
    required this.gridDelegate,
    this.padding,
    this.emptyWidget,
    super.key,
  });

  final List<T> items;
  final Widget Function(BuildContext, int, T) itemBuilder;
  final VoidCallback onLoadMore;
  final RxBool isLoadingMore;
  final RxBool hasMore;
  final SliverGridDelegate gridDelegate;
  final EdgeInsetsGeometry? padding;
  final Widget? emptyWidget;

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return emptyWidget ?? Center(child: Text('common_no_items_found'.tr));
    }

    return NotificationListener<ScrollNotification>(
      onNotification: (scrollInfo) {
        if (!isLoadingMore.value &&
            hasMore.value &&
            scrollInfo.metrics.pixels >=
                scrollInfo.metrics.maxScrollExtent - 200) {
          onLoadMore();
        }
        return false;
      },
      child: CustomScrollView(
        slivers: [
          SliverPadding(
            padding: padding ?? EdgeInsets.zero,
            sliver: SliverGrid(
              gridDelegate: gridDelegate,
              delegate: SliverChildBuilderDelegate(
                (context, index) => itemBuilder(context, index, items[index]),
                childCount: items.length,
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Obx(() {
              if (isLoadingMore.value) {
                return const Padding(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  child: Center(child: CircularProgressIndicator()),
                );
              }
              return const SizedBox.shrink();
            }),
          ),
        ],
      ),
    );
  }
}
