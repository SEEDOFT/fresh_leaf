import 'package:flutter/material.dart';
import 'package:fresh_leaf/app/modules/ai_assistant/controllers/ai_assistant_controller.dart';
import 'package:fresh_leaf/core/theme/app_colors.dart';
import 'package:get/get.dart';

class AiAssistantAppBar extends StatelessWidget implements PreferredSizeWidget {
  const AiAssistantAppBar({super.key});

  AiAssistantController get _controller => Get.find<AiAssistantController>();

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return SafeArea(
      bottom: false,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: const BoxDecoration(
                    color: AppColors.accentBrown,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.auto_awesome,
                    size: 18,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'FreshLeaf AI',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                        color: scheme.onSurface,
                        letterSpacing: -0.3,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Produce-savvy assistant',
                      style: TextStyle(
                        fontSize: 12,
                        color: scheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Row(
              children: [
                IconButton(
                  tooltip: 'View history',
                  icon: Icon(Icons.history, color: scheme.onSurface),
                  onPressed: () => _showHistory(context),
                ),
                IconButton(
                  tooltip: 'Clear history',
                  icon: Icon(
                    Icons.delete_outline,
                    color: scheme.onSurface,
                  ),
                  onPressed: () async {
                    final confirmed = await _confirmClear(context);
                    if (confirmed) {
                      _controller.messages.clear();
                      _controller.clearHistory();
                    }
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Show Histories
  Future<void> _showHistory(BuildContext context) async {
    await showModalBottomSheet(
      context: context,
      showDragHandle: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) {
        final modalScheme = Theme.of(context).colorScheme;
        return Obx(
          () => SizedBox(
            height: 360,
            child: _controller.messages.isEmpty
                ? Center(
                    child: Text(
                      'No chat history yet',
                      style: TextStyle(color: modalScheme.onSurfaceVariant),
                    ),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemCount: _controller.messages.length,
                    separatorBuilder: (context, _) => const Divider(height: 16),
                    itemBuilder: (context, index) {
                      final msg = _controller.messages[index];
                      return ListTile(
                        leading: Icon(
                          msg.isUser ? Icons.person : Icons.auto_awesome,
                          color: msg.isUser
                              ? AppColors.primaryGreen
                              : AppColors.accentBrown,
                        ),
                        title: Text(
                          msg.text.isEmpty ? '(streaming...)' : msg.text,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: modalScheme.onSurface.withValues(
                              alpha: 0.85,
                            ),
                          ),
                        ),
                        subtitle: Text(
                          msg.isUser ? 'You' : 'AI',
                          style: TextStyle(color: modalScheme.onSurfaceVariant),
                        ),
                        onTap: msg.text.isEmpty
                            ? null
                            : () {
                                _controller.copyText(msg.text);
                                Navigator.pop(context);
                              },
                      );
                    },
                  ),
          ),
        );
      },
    );
  }

  // Confirm Clear
  Future<bool> _confirmClear(BuildContext context) async {
    return await showDialog<bool>(
          context: context,
          builder: (_) => AlertDialog(
            title: const Text('Clear chat history?'),
            content: const Text(
              'This will remove all stored AI and user messages.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text('Clear'),
              ),
            ],
          ),
        ) ??
        false;
  }

  @override
  Size get preferredSize => const Size.fromHeight(72);
}
