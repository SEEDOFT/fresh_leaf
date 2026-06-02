import 'package:fresh_leaf/core/services/notification_service.dart';
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
  ProfileHelpCenterController();
  final RxList<HelpArticle> articles = <HelpArticle>[].obs;
  RxInt get unreadSupportCount =>
      Get.find<NotificationService>().unreadChatCount;

  @override
  void onInit() {
    super.onInit();
    _seedArticles();
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
}
