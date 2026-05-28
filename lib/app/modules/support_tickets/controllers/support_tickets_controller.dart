import 'package:fresh_leaf/app/routes/app_routes.dart';
import 'package:fresh_leaf/core/constants/api_endpoints.dart';
import 'package:fresh_leaf/core/mixins/paginated_list_mixin.dart';
import 'package:fresh_leaf/core/models/api_response.dart';
import 'package:fresh_leaf/core/models/paginated_response.dart';
import 'package:fresh_leaf/core/models/support_ticket.dart';
import 'package:fresh_leaf/core/services/api_client.dart';
import 'package:get/get.dart';

class SupportTicketsController extends GetxController
    with PaginatedListMixin<SupportTicket> {
  final ApiClient _apiClient = Get.find<ApiClient>();

  @override
  Future<void> onInit() async {
    super.onInit();
    await refreshList();
  }

  @override
  Future<PaginatedResponse<SupportTicket>> fetchPage(int page) async {
    try {
      final response = await _apiClient.getRequest(
        ApiEndpoints.supportTickets,
        queryParameters: {'page': page},
      );
      final apiResponse = ApiResponse.parsePaginated(
        response.data,
        SupportTicket.fromMap,
      );

      if (apiResponse.isSuccess) {
        return apiResponse.data;
      }
    } on Exception {
      Get.snackbar('error'.tr, 'failed_load_tickets'.tr);
    }
    return PaginatedResponse.empty();
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
        await refreshList();
      }
    } on Exception {
      Get.snackbar('error'.tr, 'failed_create_ticket'.tr);
    } finally {
      isLoading.value = false;
    }
  }
}
