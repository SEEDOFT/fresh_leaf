import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fresh_leaf/app/modules/ai_assistant/controllers/ai_assistant_controller.dart';
import 'package:fresh_leaf/core/services/ai_assistant_realtime_service.dart';
import 'package:get/get.dart';

class AiAssistantRealtimeDebugWidget extends StatelessWidget {
  const AiAssistantRealtimeDebugWidget({super.key});

  @override
  Widget build(BuildContext context) {
    if (!kDebugMode) {
      return const SizedBox.shrink();
    }

    final service = Get.find<AiAssistantRealtimeService>();
    final controller = Get.find<AiAssistantController>();
    final scheme = Theme.of(context).colorScheme;

    return Obx(
      () => Container(
        margin: const EdgeInsets.fromLTRB(20, 10, 20, 0),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: scheme.surfaceContainerHighest.withValues(alpha: 0.7),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: scheme.outline.withValues(alpha: 0.3),
          ),
        ),
        child: DefaultTextStyle(
          style: TextStyle(
            color: scheme.onSurfaceVariant,
            fontSize: 11,
            fontFamily: 'monospace',
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('state: ${service.connectionState.value}'),
              Text('auth: ${service.authState.value}'),
              Text('sub: ${service.subscriptionState.value}'),
              Text('channel: ${service.activeChannelName.value}'),
              Text('event: ${service.lastEventName.value}'),
              Text('error: ${service.lastError.value}'),
              Text('source: ${controller.responseSource.value}'),
            ],
          ),
        ),
      ),
    );
  }
}
