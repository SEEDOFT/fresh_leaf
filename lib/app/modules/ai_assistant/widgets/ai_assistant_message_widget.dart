import 'package:flutter/material.dart';
import 'package:fresh_leaf/app/modules/ai_assistant/controllers/ai_assistant_controller.dart';
import 'package:fresh_leaf/core/theme/app_colors.dart';

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
    final scheme = Theme.of(context).colorScheme;
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
            decoration: BoxDecoration(
              color: scheme.surfaceContainerHighest,
              borderRadius: const BorderRadius.only(
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
                              style: TextStyle(
                                fontSize: 16,
                                color: scheme.onSurfaceVariant,
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
      color: isImportant
          ? AppColors.primaryDarkGreen
          : Theme.of(context).colorScheme.onSurfaceVariant,
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
