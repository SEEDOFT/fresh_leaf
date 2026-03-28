import 'package:flutter/material.dart';
import 'package:fresh_leaf/app/modules/ai_assistant/controllers/ai_assistant_controller.dart';
import 'package:fresh_leaf/core/theme/app_colors.dart';
import 'package:get/get.dart';

class AiAssistantEmptyState extends StatelessWidget {
  const AiAssistantEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 28),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.auto_awesome,
              size: 44,
              color: AppColors.accentBrown,
            ),
            SizedBox(height: 14),
            Text(
              'Welcome to FreshLeaf AI',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w800,
                color: AppColors.textDark,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Ask about inventory, pricing, or product insights to get started.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15,
                height: 1.4,
                color: AppColors.textLight,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AiAssistantUserMessage extends StatelessWidget {
  const AiAssistantUserMessage({
    super.key,
    required this.controller,
    required this.text,
  });

  final AiAssistantController controller;
  final String text;

  @override
  Widget build(BuildContext context) {
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
}

class AiAssistantMessage extends StatelessWidget {
  const AiAssistantMessage({
    super.key,
    required this.controller,
    required this.text,
    required this.isStreaming,
    this.highlightImportant = false,
  });

  final AiAssistantController controller;
  final String text;
  final bool isStreaming;
  final bool highlightImportant;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: const BoxDecoration(
            color: AppColors.accentBrown,
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.auto_awesome, color: Colors.white, size: 20),
        ),
        const SizedBox(width: 12),
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
                      child: highlightImportant
                          ? _AiAssistantHighlightedText(
                              text: text.isEmpty && isStreaming
                                  ? 'Thinking…'
                                  : text,
                            )
                          : Text(
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
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _AiAssistantHighlightedText extends StatelessWidget {
  const _AiAssistantHighlightedText({required this.text});

  final String text;

  static final RegExp _importantPrefixRegex = RegExp(
    r'^\s*(important|note|warning|tip|action|summary|next steps?)\s*[:\-]',
    caseSensitive: false,
  );

  static final RegExp _boldRegex = RegExp(r'\*\*(.+?)\*\*');
  static final RegExp _valueRegex = RegExp(r'\$?\d+(?:[.,]\d+)?%?');

  @override
  Widget build(BuildContext context) {
    final lines = text.split('\n');

    return LayoutBuilder(
      builder: (context, constraints) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (var i = 0; i < lines.length; i++) ...[
            _HighlightedLine(
              text: lines[i],
              maxWidth: constraints.maxWidth,
            ),
            if (i < lines.length - 1) const SizedBox(height: 4),
          ],
        ],
      ),
    );
  }

  static List<InlineSpan> parseBoldSpans(String line, TextStyle baseStyle) {
    final spans = <InlineSpan>[];
    var start = 0;

    for (final match in _boldRegex.allMatches(line)) {
      if (match.start > start) {
        _appendValueAwareSpans(
          input: line.substring(start, match.start),
          baseStyle: baseStyle,
          spans: spans,
        );
      }

      final highlightedText = match.group(1) ?? '';
      _appendValueAwareSpans(
        input: highlightedText,
        baseStyle: baseStyle.copyWith(
          fontWeight: FontWeight.w800,
          color: AppColors.primaryDarkGreen,
        ),
        spans: spans,
      );
      start = match.end;
    }

    if (start < line.length) {
      _appendValueAwareSpans(
        input: line.substring(start),
        baseStyle: baseStyle,
        spans: spans,
      );
    }

    if (spans.isEmpty) {
      _appendValueAwareSpans(
        input: line,
        baseStyle: baseStyle,
        spans: spans,
      );
    }

    return spans;
  }

  static void _appendValueAwareSpans({
    required String input,
    required TextStyle baseStyle,
    required List<InlineSpan> spans,
  }) {
    var start = 0;

    for (final match in _valueRegex.allMatches(input)) {
      if (match.start > start) {
        spans.add(
          TextSpan(
            text: input.substring(start, match.start),
            style: baseStyle,
          ),
        );
      }

      final valueText = match.group(0) ?? '';
      spans.add(
        TextSpan(
          text: valueText,
          style: baseStyle.copyWith(
            color: AppColors.accentBrown,
            fontWeight: baseStyle.fontWeight == FontWeight.w800
                ? FontWeight.w800
                : FontWeight.w700,
          ),
        ),
      );
      start = match.end;
    }

    if (start < input.length) {
      spans.add(
        TextSpan(
          text: input.substring(start),
          style: baseStyle,
        ),
      );
    }
  }
}

class _HighlightedLine extends StatelessWidget {
  const _HighlightedLine({
    required this.text,
    required this.maxWidth,
  });

  final String text;
  final double maxWidth;

  @override
  Widget build(BuildContext context) {
    if (text.trim().isEmpty) {
      return const SizedBox(height: 8);
    }

    final isImportant = _AiAssistantHighlightedText._importantPrefixRegex
        .hasMatch(text.trim());

    final baseStyle = TextStyle(
      fontSize: 16,
      height: 1.5,
      color: isImportant ? AppColors.primaryDarkGreen : AppColors.textLight,
      fontWeight: isImportant ? FontWeight.w700 : FontWeight.w500,
    );

    final spans = _AiAssistantHighlightedText.parseBoldSpans(text, baseStyle);

    final richLine = RichText(text: TextSpan(children: spans));

    if (!isImportant) {
      return richLine;
    }

    return Container(
      width: maxWidth,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.accentLime.withValues(alpha: 0.22),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: AppColors.accentLime.withValues(alpha: 0.55),
        ),
      ),
      child: richLine,
    );
  }
}

class AiAssistantProductCard extends StatelessWidget {
  const AiAssistantProductCard({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.items,
  });

  final String imageUrl;
  final String title;
  final String items;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

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
              width: screenWidth,
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
}

class AiAssistantComposer extends StatelessWidget {
  const AiAssistantComposer({
    super.key,
    required this.controller,
  });

  final AiAssistantController controller;

  @override
  Widget build(BuildContext context) {
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
