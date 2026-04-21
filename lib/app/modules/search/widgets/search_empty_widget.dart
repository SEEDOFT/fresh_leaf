import 'package:flutter/material.dart';
import 'package:fresh_leaf/shared/widgets/app_empty_state.dart';
import 'package:get/get.dart';

class SearchEmptyWidget extends StatelessWidget {
  const SearchEmptyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return AppEmptyState(
      icon: Icons.search_off_rounded,
      title: 'no_result_found'.tr,
      subtitle: 'try_another_keyword'.tr,
      containerWidth: MediaQuery.of(context).size.width * 0.82,
    );
  }
}
