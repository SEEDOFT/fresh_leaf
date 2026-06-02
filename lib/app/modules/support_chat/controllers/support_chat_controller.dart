import 'dart:async';

import 'package:dio/dio.dart' as dio;
import 'package:flutter/material.dart';
import 'package:fresh_leaf/core/constants/api_endpoints.dart';
import 'package:fresh_leaf/core/models/api_response.dart';
import 'package:fresh_leaf/core/models/chat_conversation.dart';
import 'package:fresh_leaf/core/models/chat_message.dart';
import 'package:fresh_leaf/core/models/user_profile.dart';
import 'package:fresh_leaf/core/services/api_client.dart';
import 'package:fresh_leaf/core/services/chat_realtime_service.dart';
import 'package:fresh_leaf/core/services/notification_service.dart';
import 'package:fresh_leaf/core/services/storage_service.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class SupportChatController extends GetxController {
  SupportChatController({
    required ApiClient apiClient,
    required StorageService storageService,
    required ChatRealtimeService realtimeService,
  }) : _apiClient = apiClient,
       _storageService = storageService,
       _realtimeService = realtimeService;

  final ApiClient _apiClient;
  final StorageService _storageService;
  final ChatRealtimeService _realtimeService;
  final ImagePicker _imagePicker = ImagePicker();

  final RxList<ChatMessage> messages = <ChatMessage>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool isSending = false.obs;
  final RxBool isUploading = false.obs;
  final RxDouble uploadProgress = 0.0.obs;
  final RxBool isOtherTyping = false.obs;
  final Rxn<ChatConversation> activeConversation = Rxn<ChatConversation>();
  final messageController = TextEditingController();
  final ScrollController scrollController = ScrollController();
  UserProfile? get userProfile => _storageService.userProfile;

  static const int maxFileSizeBytes = 5 * 1024 * 1024;

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
      if (args != null) {
        if (args['conversation'] is ChatConversation) {
          activeConversation.value = args['conversation'] as ChatConversation;
        } else if (args['conversation_id'] != null) {
          final convId = args['conversation_id'].toString();
          final response = await _apiClient.getRequest(
            ApiEndpoints.chatConversation.replaceAll('{id}', convId),
          );
          final apiResponse = ApiResponse.parseMap(response.data);
          if (apiResponse.isSuccess) {
            activeConversation.value = ChatConversation.fromMap(
              apiResponse.data,
            );
          }
        }
      }

      if (activeConversation.value != null) {
        await _loadMessages();
        await _realtimeService.subscribeToConversation(
          activeConversation.value!.id,
        );

        _realtimeService.messages.listen((msg) {
          if (msg.conversationId == activeConversation.value?.id) {
            if (!messages.any((m) => m.id == msg.id)) {
              messages.add(msg);
              isOtherTyping.value = false;
              _scrollToBottom();
            }
          }
        });

        _realtimeService.typingEvents.listen((senderId) {
          if (senderId != userProfile?.id) {
            isOtherTyping.value = true;
            _typingTimer?.cancel();
            _typingTimer = Timer(const Duration(seconds: 3), () {
              isOtherTyping.value = false;
            });
          }
        });
      } else {
        Get
          ..snackbar('error'.tr, 'no_conversation_provided'.tr)
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
    if (activeConversation.value == null) return;

    try {
      final response = await _apiClient.getRequest(
        ApiEndpoints.chatMessages.replaceAll(
          '{id}',
          activeConversation.value!.id.toString(),
        ),
      );
      final apiResponse = ApiResponse.parseList(response.data);

      if (apiResponse.isSuccess) {
        messages.assignAll(
          apiResponse.data.map(ChatMessage.fromMap),
        );
      }
    } on Exception {
      Get.snackbar('error'.tr, 'failed_load_messages'.tr);
    }
  }

  void notifyTyping() {
    if (activeConversation.value == null) return;

    final now = DateTime.now();
    if (now.difference(_lastTypingSent).inSeconds > 2) {
      _lastTypingSent = now;
      try {
        unawaited(
          _apiClient.postRequest(
            ApiEndpoints.chatTyping,
            data: {'conversation_id': activeConversation.value!.id},
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
    if (text.isEmpty || activeConversation.value == null) return;

    isSending.value = true;
    messageController.clear();

    try {
      final formData = dio.FormData.fromMap({
        'message': text,
      });

      final response = await _apiClient.postRequest(
        ApiEndpoints.chatMessages.replaceAll(
          '{id}',
          activeConversation.value!.id.toString(),
        ),
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
        final newMsg = ChatMessage.fromMap(apiResponse.data);
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
    final context = Get.context!;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final scheme = Theme.of(context).colorScheme;

    final result = await Get.bottomSheet<String>(
      Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: scheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: isDark ? Colors.grey[600] : Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'select_attachment_source'.tr,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: isDark ? Colors.white : Colors.black87,
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
                  child: Icon(
                    Icons.camera_alt,
                    color: isDark ? Colors.blue[200] : Colors.blue,
                  ),
                ),
                title: Text(
                  'camera'.tr,
                  style: TextStyle(
                    color: isDark ? Colors.white : Colors.black87,
                  ),
                ),
                subtitle: Text(
                  'take_a_photo'.tr,
                  style: TextStyle(
                    color: isDark ? Colors.white54 : Colors.black54,
                  ),
                ),
                onTap: () => Get.back(result: 'camera'),
              ),
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.green.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    Icons.photo_library,
                    color: isDark ? Colors.green[200] : Colors.green,
                  ),
                ),
                title: Text(
                  'gallery'.tr,
                  style: TextStyle(
                    color: isDark ? Colors.white : Colors.black87,
                  ),
                ),
                subtitle: Text(
                  'choose_from_photos'.tr,
                  style: TextStyle(
                    color: isDark ? Colors.white54 : Colors.black54,
                  ),
                ),
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
        'message': '',
        'attachment': await dio.MultipartFile.fromFile(
          image.path,
          filename: image.name,
        ),
      });

      final response = await _apiClient.postMultipart(
        ApiEndpoints.chatMessages.replaceAll(
          '{id}',
          activeConversation.value!.id.toString(),
        ),
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
        final newMsg = ChatMessage.fromMap(apiResponse.data);
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
    if (Get.isRegistered<NotificationService>()) {
      unawaited(Get.find<NotificationService>().fetchUnreadChatCount());
    }
    super.onClose();
  }
}
