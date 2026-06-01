import 'package:fresh_leaf/app/modules/support_tickets/controllers/support_tickets_controller.dart';
import 'package:fresh_leaf/core/services/api_client.dart';
import 'package:get/get.dart';

class SupportTicketsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SupportTicketsController>(
      () => SupportTicketsController(apiClient: Get.find<ApiClient>()),
    );
  }
}
