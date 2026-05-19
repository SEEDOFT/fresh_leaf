import 'package:fresh_leaf/app/routes/app_routes.dart';
import 'package:fresh_leaf/core/constants/api_endpoints.dart';
import 'package:fresh_leaf/core/models/api_response.dart';
import 'package:fresh_leaf/core/models/support_ticket.dart';
import 'package:fresh_leaf/core/services/api_client.dart';
import 'package:get/get.dart';

class SupportTicketsController extends GetxController {
  final ApiClient _apiClient = Get.find<ApiClient>();

  final RxList<SupportTicket> tickets = <SupportTicket>[].obs;
  final RxBool isLoading = false.obs;

  @override
  Future<void> onInit() async {
    super.onInit();
    await loadTickets();
  }

  Future<void> loadTickets() async {
    isLoading.value = true;
    try {
      final response = await _apiClient.getRequest(
        ApiEndpoints.supportTickets,
      );
      final apiResponse = ApiResponse.parseList(response.data);

      if (apiResponse.isSuccess) {
        tickets.assignAll(
          apiResponse.data.map(SupportTicket.fromMap),
        );
      }
    } on Exception {
      Get.snackbar('Error', 'Failed to load tickets');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> createNewTicket() async {
    isLoading.value = true;
    try {
      final response = await _apiClient.postRequest(
        ApiEndpoints.supportTicket,
      );
      final apiResponse = ApiResponse.parseMap(response.data);

      if (apiResponse.isSuccess) {
        final newTicket = SupportTicket.fromMap(apiResponse.data);
        await Get.toNamed<void>(
          AppRoutes.supportChat,
          arguments: {'ticket': newTicket},
        );
        await loadTickets();
      }
    } on Exception {
      Get.snackbar('Error', 'Failed to create ticket');
    } finally {
      isLoading.value = false;
    }
  }
}
