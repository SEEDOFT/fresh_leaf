import 'dart:async';

import 'package:dio/dio.dart' as dio;
import 'package:file_picker/file_picker.dart' as fp;
import 'package:flutter/material.dart';
import 'package:fresh_leaf/core/constants/api_endpoints.dart';
import 'package:fresh_leaf/core/models/api_response.dart';
import 'package:fresh_leaf/core/models/support_message.dart';
import 'package:fresh_leaf/core/models/support_ticket.dart';
import 'package:fresh_leaf/core/services/api_client.dart';
import 'package:fresh_leaf/core/services/support_realtime_service.dart';
import 'package:get/get.dart';

class SupportChatController extends GetxController {
  final ApiClient _apiClient = Get.find<ApiClient>();
  final SupportRealtimeService _realtimeService = Get.put(
    SupportRealtimeService(),
  );

  final RxList<SupportMessage> messages = <SupportMessage>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool isSending = false.obs;
  final RxBool isAdminTyping = false.obs;
  final Rxn<SupportTicket> activeTicket = Rxn<SupportTicket>();
  final messageController = TextEditingController();
  final ScrollController scrollController = ScrollController();

  Timer? _typingTimer;
  DateTime _lastTypingSent = DateTime.now().subtract(
    const Duration(seconds: 10),
  );

  @override
  void onInit() {
    super.onInit();
    _initializeChat();
  }

  Future<void> _initializeChat() async {
    isLoading.value = true;
    try {
      final response = await _apiClient.getRequest(
        ApiEndpoints.supportTicket,
      );
      final apiResponse = ApiResponse.parseMap(response.data);

      if (apiResponse.isSuccess) {
        activeTicket.value = SupportTicket.fromMap(apiResponse.data);
        await _loadMessages();
        await _realtimeService.subscribeToTicket(activeTicket.value!.id);

        _realtimeService.messages.listen((msg) {
          if (msg.supportTicketId == activeTicket.value?.id) {
            messages.add(msg);
            isAdminTyping.value = false;
            _scrollToBottom();
          }
        });

        _realtimeService.typingEvents.listen((senderType) {
          if (senderType == 'admin') {
            isAdminTyping.value = true;
            _typingTimer?.cancel();
            _typingTimer = Timer(const Duration(seconds: 3), () {
              isAdminTyping.value = false;
            });
            _scrollToBottom();
          }
        });
      }
    } on Exception {
      Get.snackbar('Error', 'Failed to initialize support chat');
    } finally {
      isLoading.value = false;
      _scrollToBottom();
    }
  }

  Future<void> _loadMessages() async {
    if (activeTicket.value == null) return;

    try {
      final response = await _apiClient.getRequest(
        ApiEndpoints.supportMessages,
        queryParameters: {'ticket_id': activeTicket.value!.id},
      );
      final apiResponse = ApiResponse.parseList(response.data);

      if (apiResponse.isSuccess) {
        messages.assignAll(
          apiResponse.data.map(SupportMessage.fromMap),
        );
      }
    } on Exception {
      Get.snackbar('Error', 'Failed to load messages');
    }
  }

  void notifyTyping() {
    if (activeTicket.value == null) return;

    final now = DateTime.now();
    if (now.difference(_lastTypingSent).inSeconds > 2) {
      _lastTypingSent = now;
      try {
        _apiClient.postRequest(
          '${ApiEndpoints.supportMessages.replaceAll('/messages', '')}/typing',
          data: {'ticket_id': activeTicket.value!.id},
        );
      } on Exception {
        // ignore
      }
    }
  }

  Future<void> sendMessage({fp.PlatformFile? file}) async {
    final text = messageController.text.trim();
    if ((text.isEmpty && file == null) || activeTicket.value == null) return;

    isSending.value = true;
    messageController.clear();

    try {
      final formData = dio.FormData.fromMap({
        'ticket_id': activeTicket.value!.id,
        'message': text,
      });

      if (file != null && file.path != null) {
        formData.files.add(
          MapEntry(
            'file',
            await dio.MultipartFile.fromFile(file.path!, filename: file.name),
          ),
        );
      }

      final response = await _apiClient.postRequest(
        ApiEndpoints.supportMessages,
        data: formData,
      );
      final apiResponse = ApiResponse.parseMap(response.data);

      if (apiResponse.isSuccess) {
        messages.add(SupportMessage.fromMap(apiResponse.data));
        _scrollToBottom();
      }
    } on Exception {
      Get.snackbar('Error', 'Failed to send message');
    } finally {
      isSending.value = false;
    }
  }

  Future<void> pickFile() async {
    final result = await fp.FilePicker.pickFiles(
      type: fp.FileType.custom,
      allowedExtensions: ['jpg', 'jpeg', 'png', 'pdf', 'doc', 'docx'],
    );

    if (result != null && result.files.isNotEmpty) {
      await sendMessage(file: result.files.first);
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (scrollController.hasClients) {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent + 100,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  void onClose() {
    messageController.dispose();
    scrollController.dispose();
    _typingTimer?.cancel();
    super.onClose();
  }
}
