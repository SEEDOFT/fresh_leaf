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
    _fetchUnreadCount();
  }

  void _seedArticles() {
    articles.assignAll(<HelpArticle>[
      const HelpArticle(
        title: 'Ordering & delivery',
        subtitle: 'How delivery windows work, contactless drop-off, delays.',
        category: 'orders',
      ),
      const HelpArticle(
        title: 'Payments & refunds',
        subtitle: 'Payment methods, charges, refunds, and failed payments.',
        category: 'payments',
      ),
      const HelpArticle(
        title: 'Account & security',
        subtitle: 'Reset password, PIN security, updating phone/email.',
        category: 'account',
      ),
      const HelpArticle(
        title: 'Addresses & map',
        subtitle: 'How to pin your location and manage saved addresses.',
        category: 'addresses',
      ),
      const HelpArticle(
        title: 'AI assistant',
        subtitle: 'What data is used and how responses are generated.',
        category: 'ai',
      ),
    ]);
  }

  Future<void> _fetchUnreadCount() async {
    try {
      final response = await _apiClient.getRequest(
        ApiEndpoints.supportUnreadCount,
      );
      final data = response.data;
      if (data is Map<String, dynamic> && data['count'] != null) {
        unreadSupportCount.value = data['count'] as int;
      }
    } on Exception {
      // Ignore errors for unread count
    }
  }

  void refreshUnreadCount() {
    _fetchUnreadCount();
  }
}
