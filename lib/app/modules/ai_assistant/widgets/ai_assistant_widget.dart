import 'package:flutter/material.dart';
import 'package:fresh_leaf/app/modules/ai_assistant/controllers/ai_assistant_controller.dart';
import 'package:fresh_leaf/core/theme/app_colors.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';

class AiAssistantWidget {
  AiAssistantWidget._();

  // Build user message
  static Widget buildUserMessage(
    AiAssistantController controller,
    String text,
  ) {
    return Padding(
      padding: const EdgeInsets.only(left: 40),
      child: Align(
        alignment: Alignment.centerRight,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            IconButton(
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
              iconSize: 16,
              onPressed: () => controller.copyText(text),
              icon: const Icon(Icons.copy, color: AppColors.textLight),
              tooltip: 'Copy',
            ),
            const SizedBox(width: 8),
            Flexible(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 16,
                ),
                decoration: const BoxDecoration(
                  color: AppColors.primaryGreen,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(24),
                    topRight: Radius.circular(24),
                    bottomLeft: Radius.circular(24),
                    bottomRight: Radius.circular(6),
                  ),
                ),
                child: Text(
                  text,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    height: 1.4,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  static Widget buildAIMessage(
    AiAssistantController controller,
    String text,
    bool isStreaming,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // AI Avatar
        Container(
          padding: const EdgeInsets.all(10),
          decoration: const BoxDecoration(
            color: AppColors.accentBrown,
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.auto_awesome, color: Colors.white, size: 20),
        ),
        const SizedBox(width: 12),

        // AI Content Box
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
              color: AppColors.cardLight,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(6),
                topRight: Radius.circular(24),
                bottomLeft: Radius.circular(24),
                bottomRight: Radius.circular(24),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Row(
                      children: [
                        Text(
                          'AI ANALYZING LARDER',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w900,
                            color: AppColors.accentBrown,
                            letterSpacing: 1.5,
                          ),
                        ),
                        SizedBox(width: 8),
                        Icon(
                          Icons.more_horiz,
                          color: AppColors.accentBrown,
                          size: 20,
                        ),
                      ],
                    ),
                    IconButton(
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(
                        minWidth: 32,
                        minHeight: 32,
                      ),
                      iconSize: 16,
                      onPressed: () => controller.copyText(text),
                      icon: const Icon(
                        Icons.copy,
                        color: AppColors.accentBrown,
                      ),
                      tooltip: 'Copy',
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Text Response
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (isStreaming)
                      const Padding(
                        padding: EdgeInsets.only(right: 8, top: 2),
                        child: SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                      ),
                    Expanded(
                      child: Text(
                        text.isEmpty && isStreaming ? 'Thinking…' : text,
                        style: const TextStyle(
                          fontSize: 16,
                          color: AppColors.textLight,
                          height: 1.5,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Horizontal Product List
                // SizedBox(
                //   height: 190,
                //   child: Obx(
                //     () => ListView.separated(
                //       scrollDirection: Axis.horizontal,
                //       itemCount: controller.suggestedBundles.length,
                //       separatorBuilder: (_, _) => const SizedBox(width: 12),
                //       itemBuilder: (context, index) {
                //         final bundle = controller.suggestedBundles[index];
                //         return buildProductCard(
                //           bundle['image']!,
                //           bundle['title']!,
                //           bundle['items']!,
                //         );
                //       },
                //     ),
                //   ),
                // ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  static Widget buildProductCard(String imageUrl, String title, String items) {
    return Container(
      width: 140,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
              imageUrl,
              height: 90,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.w800,
              fontSize: 13,
              color: AppColors.textDark,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            items,
            style: const TextStyle(
              fontSize: 11,
              color: AppColors.textLight,
              height: 1.3,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  static Widget buildComposer(AiAssistantController controller) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller.inputController,
              minLines: 1,
              maxLines: 4,
              decoration: InputDecoration(
                hintText: 'Ask FreshLeaf anything...',
                filled: true,
                fillColor: AppColors.cardLight,
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
          Obx(
            () => SizedBox(
              height: 48,
              width: 48,
              child: ElevatedButton(
                onPressed: controller.isLoading.value
                    ? null
                    : controller.sendMessage,
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.zero,
                  shape: const CircleBorder(),
                  backgroundColor: AppColors.primaryGreen,
                  elevation: 0,
                ),
                child: controller.isLoading.value
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Icon(Icons.send, color: Colors.white, size: 20),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
