import 'package:flutter/material.dart';
import 'package:fresh_leaf/app/modules/ai_assistant/controllers/ai_assistant_controller.dart';
import 'package:get/get.dart';

class AiAssistantComposer extends StatelessWidget {
  const AiAssistantComposer({
    required this.controller,
    super.key,
  });

  final AiAssistantController controller;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Obx(
        () => Row(
          children: [
            Expanded(
              child: TextField(
                controller: controller.inputController,
                enabled:
                    controller.isAiServiceAvailable.value &&
                    !controller.isLoading.value,
                minLines: 1,
                maxLines: 4,
                decoration: InputDecoration(
                  hintText: controller.isAiServiceAvailable.value
                      ? 'ai_prompt_hint'.tr
                      : 'ai_service_unavailable'.tr,
                  filled: true,
                  fillColor: scheme.surfaceContainerHighest,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            SizedBox(
              height: 48,
              width: 48,
              child: ElevatedButton(
                onPressed:
                    (controller.isAiServiceAvailable.value &&
                        !controller.isLoading.value)
                    ? controller.sendMessage
                    : null,
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.zero,
                  shape: const CircleBorder(),
                  backgroundColor: scheme.primary,
                  elevation: 0,
                ),
                child: controller.isLoading.value
                    ? SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: scheme.onPrimary,
                        ),
                      )
                    : Icon(
                        Icons.send,
                        color: scheme.onPrimary,
                        size: 20,
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
