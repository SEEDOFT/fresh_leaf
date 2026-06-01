import 'package:fresh_leaf/app/routes/app_routes.dart';
import 'package:fresh_leaf/core/constants/api_endpoints.dart';
import 'package:fresh_leaf/core/mixins/paginated_list_mixin.dart';
import 'package:fresh_leaf/core/models/api_response.dart';
import 'package:fresh_leaf/core/models/chat_conversation.dart';
import 'package:fresh_leaf/core/models/paginated_response.dart';
import 'package:fresh_leaf/core/services/api_client.dart';
import 'package:get/get.dart';

class SupportTicketsController extends GetxController
    with PaginatedListMixin<ChatConversation> {
  final ApiClient _apiClient = Get.find<ApiClient>();

  @override
  Future<void> onInit() async {
    super.onInit();
    await refreshList();
  }

  @override
  Future<PaginatedResponse<ChatConversation>> fetchPage(int page) async {
    try {
      final response = await _apiClient.getRequest(
        ApiEndpoints.chatConversations,
        queryParameters: {'page': page},
      );
      final apiResponse = ApiResponse.parsePaginated(
        response.data,
        ChatConversation.fromMap,
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
        ApiEndpoints.chatConversations,
        data: {'type': 'support'},
      );
      final apiResponse = ApiResponse.parseMap(response.data);

      if (apiResponse.isSuccess) {
        final newConversation = ChatConversation.fromMap(apiResponse.data);
        await Get.toNamed<void>(
          AppRoutes.supportChat,
          arguments: {'conversation': newConversation},
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
