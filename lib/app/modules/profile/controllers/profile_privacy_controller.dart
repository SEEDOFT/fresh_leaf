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
      PolicySection(
        heading: 'privacy_data_collect_heading'.tr,
        body: 'privacy_data_collect_body'.tr,
      ),
      PolicySection(
        heading: 'privacy_how_we_use_heading'.tr,
        body: 'privacy_how_we_use_body'.tr,
      ),
      PolicySection(
        heading: 'privacy_sharing_heading'.tr,
        body: 'privacy_sharing_body'.tr,
      ),
      PolicySection(
        heading: 'privacy_security_heading'.tr,
        body: 'privacy_security_body'.tr,
      ),
      PolicySection(
        heading: 'privacy_controls_heading'.tr,
        body: 'privacy_controls_body'.tr,
      ),
      PolicySection(
        heading: 'privacy_tos_heading'.tr,
        body: 'privacy_tos_body'.tr,
      ),
    ]);
  }
}
