import 'package:flutter/material.dart';
import 'package:fresh_leaf/app/modules/ai_assistant/widgets/ai_assistant_widget.dart';
import 'package:fresh_leaf/shared/widgets/ai_assistant_app_bar.dart';
import 'package:get/get.dart';
import '../controllers/ai_assistant_controller.dart';

class AiAssistantView extends GetView<AiAssistantController> {
  const AiAssistantView({super.key});

  @override
  Widget build(BuildContext context) {
    final scaffoldBg = Theme.of(context).scaffoldBackgroundColor;
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        backgroundColor: scaffoldBg,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Column(
              children: [
                const AiAssistantAppBar(),
                Expanded(
                  child: Obx(
                    () {
                      if (controller.messages.isEmpty) {
                        return const AiAssistantEmptyState();
                      }

                      return ListView(
                        padding: const EdgeInsets.only(
                          left: 20,
                          right: 20,
                          top: 16,
                          bottom: 120,
                        ),
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              for (final message in controller.messages)
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 16),
                                  child: message.isUser
                                      ? AiAssistantUserMessage(
                                          controller: controller,
                                          text: message.text,
                                        )
                                      : AiAssistantMessage(
                                          controller: controller,
                                          text: message.text,
                                          isStreaming: message.isStreaming,
                                          highlightImportant: true,
                                        ),
                                ),
                            ],
                          ),
                        ],
                      );
                    },
                  ),
                ),
                AiAssistantComposer(controller: controller),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
