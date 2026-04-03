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

  @override
  void onInit() {
    super.onInit();
    _seedArticles();
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
}
