import 'package:get/get.dart';

class PolicySection {
  const PolicySection({
    required this.heading,
    required this.body,
  });

  final String heading;
  final String body;
}

class ProfilePrivacyController extends GetxController {
  final RxList<PolicySection> sections = <PolicySection>[].obs;

  @override
  void onInit() {
    super.onInit();
    _seedPolicy();
  }

  void _seedPolicy() {
    sections.assignAll(<PolicySection>[
      const PolicySection(
        heading: 'Data we collect',
        body:
            'We store your name, email, phone, saved addresses,'
            ' and order history to deliver your purchases '
            'and improve recommendations.',
      ),
      const PolicySection(
        heading: 'How we use it',
        body:
            'Data is used for account access, payments,'
            ' delivery routing, AI assistant personalization,'
            ' and fraud prevention.',
      ),
      const PolicySection(
        heading: 'Sharing',
        body:
            'We share only what is needed with payment processors,'
            ' delivery partners, and analytics providers.'
            ' We do not sell personal data.',
      ),
      const PolicySection(
        heading: 'Security',
        body:
            'Tokens are stored securely; PIN protects'
            ' order access; all network calls go over HTTPS.',
      ),
      const PolicySection(
        heading: 'Your controls',
        body:
            'Update profile details, addresses, and PIN '
            'in the Profile tab. Contact support to'
            ' delete your account or export data.',
      ),
      const PolicySection(
        heading: 'Terms of service (summary)',
        body:
            'Use of FreshLeaf requires a valid account,'
            ' accurate delivery info, and compliance with'
            ' local regulations. Orders may be canceled if'
            ' payment fails or address is unreachable.',
      ),
    ]);
  }
}
