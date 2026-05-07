import 'package:flutter/material.dart';
import 'package:fresh_leaf/app/modules/ai_assistant/controllers/ai_assistant_controller.dart';
import 'package:fresh_leaf/app/modules/ai_assistant/widgets/ai_assistant_widget.dart';
import 'package:fresh_leaf/shared/widgets/ai_assistant_app_bar.dart';
import 'package:fresh_leaf/shared/widgets/app_scaffold.dart';
import 'package:get/get.dart';

class AiAssistantView extends GetView<AiAssistantController> {
  const AiAssistantView({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: AppScaffold(
        scrollable: false,
        padding: const EdgeInsets.symmetric(vertical: 20),
        body: Column(
          children: [
            const AiAssistantAppBar(),
            Obx(
              () => controller.isAiServiceAvailable.value
                  ? const SizedBox.shrink()
                  : Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      color: Colors.red.shade100,
                      child: Row(
                        children: [
                          const Icon(Icons.error_outline, color: Colors.red),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'ai_service_unavailable_banner'.tr,
                              style: const TextStyle(color: Colors.red),
                            ),
                          ),
                        ],
                      ),
                    ),
            ),
            Expanded(
              child: Obx(
                () {
                  if (controller.messages.isEmpty) {
                    return const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: AiAssistantEmptyState(),
                    );
                  }

                  return ListView.separated(
                    controller: controller.chatScrollController,
                    padding: const EdgeInsets.only(
                      left: 20,
                      right: 20,
                      top: 16,
                      bottom: 120,
                    ),
                    itemCount: controller.messages.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 16),
                    itemBuilder: (context, index) {
                      final message = controller.messages[index];
                      return message.isUser
                          ? AiAssistantUserMessage(
                              controller: controller,
                              text: message.text,
                            )
                          : AiAssistantMessage(
                              controller: controller,
                              text: message.text,
                              isStreaming: message.isStreaming,
                              highlightImportant: true,
                            );
                    },
                  );
                },
              ),
            ),
            AiAssistantComposer(controller: controller),
          ],
        ),
      ),
    );
  }
}
