import 'dart:async';

import 'package:fresh_leaf/core/constants/api_endpoints.dart';
import 'package:fresh_leaf/core/services/api_client.dart';
import 'package:get/get.dart';

class HelpArticle {
  const HelpArticle({
    required this.title,
    required this.subtitle,
    required this.category,
  });

  final String title;
  final String subtitle;
  final String category;
}

class ProfileHelpCenterController extends GetxController {
  final RxList<HelpArticle> articles = <HelpArticle>[].obs;
  final RxInt unreadSupportCount = 0.obs;
  final ApiClient _apiClient = Get.find<ApiClient>();

  @override
  void onInit() {
    super.onInit();
    _seedArticles();
    unawaited(_fetchUnreadCount());
  }

  void _seedArticles() {
    articles.assignAll(<HelpArticle>[
      HelpArticle(
        title: 'help_article_ordering_title'.tr,
        subtitle: 'help_article_ordering_subtitle'.tr,
        category: 'orders',
      ),
      HelpArticle(
        title: 'help_article_payments_title'.tr,
        subtitle: 'help_article_payments_subtitle'.tr,
        category: 'payments',
      ),
      HelpArticle(
        title: 'help_article_account_title'.tr,
        subtitle: 'help_article_account_subtitle'.tr,
        category: 'account',
      ),
      HelpArticle(
        title: 'help_article_addresses_title'.tr,
        subtitle: 'help_article_addresses_subtitle'.tr,
        category: 'addresses',
      ),
      HelpArticle(
        title: 'help_article_ai_title'.tr,
        subtitle: 'help_article_ai_subtitle'.tr,
        category: 'ai',
      ),
    ]);
  }

  Future<void> _fetchUnreadCount() async {
    try {
      final response = await _apiClient.getRequest(
        ApiEndpoints.chatUnreadCount,
      );
      final data = response.data;
      if (data is Map<String, dynamic> && data['count'] != null) {
        unreadSupportCount.value = data['count'] as int;
      }
    } on Exception {
      //
    }
  }

  Future<void> refreshUnreadCount() async {
    await _fetchUnreadCount();
  }
}
