import 'dart:async';

import 'package:dio/dio.dart' as dio;
import 'package:flutter/material.dart';
import 'package:fresh_leaf/core/constants/api_endpoints.dart';
import 'package:fresh_leaf/core/models/api_response.dart';
import 'package:fresh_leaf/core/models/support_message.dart';
import 'package:fresh_leaf/core/models/support_ticket.dart';
import 'package:fresh_leaf/core/models/user_profile.dart';
import 'package:fresh_leaf/core/services/api_client.dart';
import 'package:fresh_leaf/core/services/storage_service.dart';
import 'package:fresh_leaf/core/services/support_realtime_service.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class SupportChatController extends GetxController {
  final ApiClient _apiClient = Get.find<ApiClient>();
  final SupportRealtimeService _realtimeService = Get.put(
    SupportRealtimeService(),
  );
  final ImagePicker _imagePicker = ImagePicker();

  final RxList<SupportMessage> messages = <SupportMessage>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool isSending = false.obs;
  final RxBool isUploading = false.obs;
  final RxDouble uploadProgress = 0.0.obs;
  final RxBool isAdminTyping = false.obs;
  final Rxn<SupportTicket> activeTicket = Rxn<SupportTicket>();
  final messageController = TextEditingController();
  final ScrollController scrollController = ScrollController();
  final UserProfile? userProfile = Get.find<StorageService>().userProfile;

  static const int maxFileSizeBytes = 5 * 1024 * 1024;
  static const String admin = 'admin';

  Timer? _typingTimer;
  DateTime _lastTypingSent = DateTime.now().subtract(
    const Duration(seconds: 10),
  );

  @override
  void onInit() {
    super.onInit();
    unawaited(_initializeChat());
  }

  Future<void> _initializeChat() async {
    isLoading.value = true;
    try {
      final args = Get.arguments as Map<String, dynamic>?;
      if (args != null && args['ticket'] is SupportTicket) {
        activeTicket.value = args['ticket'] as SupportTicket;
        await _loadMessages();
        await _realtimeService.subscribeToTicket(activeTicket.value!.id);

        _realtimeService.messages.listen((msg) {
          if (msg.supportTicketId == activeTicket.value?.id) {
            if (!messages.any((m) => m.id == msg.id)) {
              messages.add(msg);
              isAdminTyping.value = false;
              _scrollToBottom();
            }
          }
        });

        _realtimeService.typingEvents.listen((senderType) {
          if (senderType == admin) {
            isAdminTyping.value = true;
            _typingTimer?.cancel();
            _typingTimer = Timer(const Duration(seconds: 3), () {
              isAdminTyping.value = false;
            });
          }
        });
      } else {
        Get
          ..snackbar('error'.tr, 'no_ticket_provided'.tr)
          ..back<void>();
      }
    } on Exception {
      Get.snackbar('error'.tr, 'failed_init_chat'.tr);
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
      Get.snackbar('error'.tr, 'failed_load_messages'.tr);
    }
  }

  void notifyTyping() {
    if (activeTicket.value == null) return;

    final now = DateTime.now();
    if (now.difference(_lastTypingSent).inSeconds > 2) {
      _lastTypingSent = now;
      try {
        unawaited(
          _apiClient.postRequest(
            ApiEndpoints.supportTyping,
            data: {'ticket_id': activeTicket.value!.id},
            options: dio.Options(
              headers: {
                if (_realtimeService.socketId.isNotEmpty)
                  'X-Socket-ID': _realtimeService.socketId,
              },
            ),
          ),
        );
      } on Exception {
        //
      }
    }
  }

  Future<void> sendMessage() async {
    final text = messageController.text.trim();
    if (text.isEmpty || activeTicket.value == null) return;

    isSending.value = true;
    messageController.clear();

    try {
      final formData = dio.FormData.fromMap({
        'ticket_id': activeTicket.value!.id,
        'message': text,
      });

      final response = await _apiClient.postRequest(
        ApiEndpoints.supportMessage,
        data: formData,
        options: dio.Options(
          headers: {
            if (_realtimeService.socketId.isNotEmpty)
              'X-Socket-ID': _realtimeService.socketId,
          },
        ),
      );

      final apiResponse = ApiResponse.parseMap(response.data);

      if (apiResponse.isSuccess) {
        final newMsg = SupportMessage.fromMap(apiResponse.data);
        if (!messages.any((m) => m.id == newMsg.id)) {
          messages.add(newMsg);
        }
        _scrollToBottom();
      }
    } on Exception {
      Get.snackbar('error'.tr, 'failed_send_message'.tr);
    } finally {
      isSending.value = false;
    }
  }

  Future<void> pickFile() async {
    await _showFileSourcePicker();
  }

  Future<void> _showFileSourcePicker() async {
    final result = await Get.bottomSheet<String>(
      Container(
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'select_attachment_source'.tr,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 20),
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.blue.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.camera_alt, color: Colors.blue),
                ),
                title: Text('camera'.tr),
                subtitle: Text('take_a_photo'.tr),
                onTap: () => Get.back(result: 'camera'),
              ),
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.green.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.photo_library, color: Colors.green),
                ),
                title: Text('gallery'.tr),
                subtitle: Text('choose_from_photos'.tr),
                onTap: () => Get.back(result: 'gallery'),
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );

    if (result != null) {
      switch (result) {
        case 'camera':
          await _pickFromCamera();
        case 'gallery':
          await _pickFromGallery();
      }
    }
  }

  Future<void> _pickFromCamera() async {
    try {
      final image = await _imagePicker.pickImage(
        source: ImageSource.camera,
        maxWidth: 1920,
        maxHeight: 1080,
        imageQuality: 85,
      );

      if (image != null) {
        await _processAndSendImage(image);
      }
    } on Exception {
      Get.snackbar('error'.tr, 'failed_capture_image'.tr);
    }
  }

  Future<void> _pickFromGallery() async {
    try {
      final image = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1920,
        maxHeight: 1080,
        imageQuality: 85,
      );

      if (image != null) {
        await _processAndSendImage(image);
      }
    } on Exception {
      Get.snackbar('error'.tr, 'failed_select_image'.tr);
    }
  }

  Future<void> _processAndSendImage(XFile image) async {
    final fileSize = await image.length();
    if (fileSize > maxFileSizeBytes) {
      Get.snackbar('error'.tr, 'image_exceeds_limit'.tr);
      return;
    }

    isUploading.value = true;
    isSending.value = true;

    try {
      final formData = dio.FormData.fromMap({
        'ticket_id': activeTicket.value!.id,
        'message': '',
        'file': await dio.MultipartFile.fromFile(
          image.path,
          filename: image.name,
        ),
      });

      final response = await _apiClient.postMultipart(
        ApiEndpoints.supportMessage,
        data: formData,
        options: dio.Options(
          headers: {
            if (_realtimeService.socketId.isNotEmpty)
              'X-Socket-ID': _realtimeService.socketId,
          },
        ),
        onSendProgress: (sent, total) {
          uploadProgress.value = sent / total;
        },
      );

      final apiResponse = ApiResponse.parseMap(response.data);

      if (apiResponse.isSuccess) {
        final newMsg = SupportMessage.fromMap(apiResponse.data);
        if (!messages.any((m) => m.id == newMsg.id)) {
          messages.add(newMsg);
        }
        _scrollToBottom();
      }
    } on Exception {
      Get.snackbar('error'.tr, 'failed_send_image'.tr);
    } finally {
      isUploading.value = false;
      isSending.value = false;
      uploadProgress.value = 0.0;
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (scrollController.hasClients) {
        unawaited(
          scrollController.animateTo(
            scrollController.position.maxScrollExtent + 100,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
          ),
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
