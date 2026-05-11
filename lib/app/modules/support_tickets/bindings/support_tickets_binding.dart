import 'package:fresh_leaf/app/modules/support_tickets/controllers/support_tickets_controller.dart';
import 'package:get/get.dart';

class SupportTicketsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SupportTicketsController>(SupportTicketsController.new);
  }
}
