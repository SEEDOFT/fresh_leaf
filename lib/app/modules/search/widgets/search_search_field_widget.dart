import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SearchSearchFieldWidget extends StatelessWidget {
  const SearchSearchFieldWidget({
    required this.controller,
    required this.onChanged,
    required this.onClear,
    required this.query,
    super.key,
  });

  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final VoidCallback onClear;
  final String query;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      decoration: BoxDecoration(
        color: scheme.surface,
        borderRadius: BorderRadius.circular(18),
      ),
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        textInputAction: TextInputAction.search,
        decoration: InputDecoration(
          hintText: 'search_hint'.tr,
          prefixIcon: Icon(
            Icons.search_rounded,
            color: scheme.onSurfaceVariant,
          ),
          suffixIcon: query.isEmpty
              ? const SizedBox.shrink()
              : IconButton(
                  onPressed: onClear,
                  icon: Icon(
                    Icons.close_rounded,
                    color: scheme.onSurfaceVariant,
                  ),
                ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(18),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
}
