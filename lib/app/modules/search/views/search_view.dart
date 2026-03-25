import 'package:flutter/material.dart' hide SearchController;
import 'package:get/get.dart';
import '../controllers/search_controller.dart';

class SearchView extends GetView<SearchController> {
  const SearchView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('Search View'));
  }
}
