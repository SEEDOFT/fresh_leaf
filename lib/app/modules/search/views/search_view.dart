import 'package:flutter/material.dart' hide SearchController;
import 'package:fresh_leaf/app/modules/search/widgets/search_widget.dart';
import 'package:get/get.dart';
import '../controllers/search_controller.dart';

class SearchView extends GetView<SearchController> {
  const SearchView({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final scaffoldBg = Theme.of(context).scaffoldBackgroundColor;
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        backgroundColor: scaffoldBg,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Search',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w900,
                    color: scheme.onSurface,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Find fresh products quickly',
                  style: TextStyle(
                    color: scheme.onSurfaceVariant,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 14),
                Obx(
                  () => SearchSearchFieldWidget(
                    controller: controller.textController,
                    query: controller.query.value,
                    onChanged: controller.updateQuery,
                    onClear: controller.clearQuery,
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  height: 36,
                  child: Obx(() {
                    final activeTag = controller.activeTag.value;
                    return ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: controller.quickTags.length,
                      separatorBuilder: (_, _) => const SizedBox(width: 8),
                      itemBuilder: (context, index) {
                        final label = controller.quickTags[index];
                        return SearchFilterChipWidget(
                          label: label,
                          isSelected: activeTag == label,
                          onTap: () => controller.changeTag(label),
                        );
                      },
                    );
                  }),
                ),
                const SizedBox(height: 14),
                Obx(
                  () => Text(
                    '${controller.results.length} result${controller.results.length == 1 ? '' : 's'}',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: scheme.onSurfaceVariant,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: Obx(() {
                    final items = controller.results;
                    if (items.isEmpty) {
                      return const SearchEmptyWidget();
                    }

                    return ListView.separated(
                      padding: const EdgeInsets.only(bottom: 20),
                      itemCount: items.length,
                      separatorBuilder: (_, _) => const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final item = items[index];
                        return SearchProductCardWidget(
                          item: item,
                          onTap: () => controller.openProduct(item),
                        );
                      },
                    );
                  }),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
