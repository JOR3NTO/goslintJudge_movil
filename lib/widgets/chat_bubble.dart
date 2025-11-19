import 'package:flutter/material.dart';

/// Bubble for a single user (or AI) message without structured bullets.
class ChatBubble extends StatelessWidget {
  final bool isAi;
  final String text;

  const ChatBubble({super.key, required this.isAi, required this.text});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    // Distinct backgrounds that adapt to light/dark themes.
    final background = isAi ? cs.surfaceContainerHighest : cs.primaryContainer;
    final textColor = isAi ? cs.onSurface : cs.onPrimaryContainer;
    final align = isAi ? CrossAxisAlignment.start : CrossAxisAlignment.end;
    return Column(
      crossAxisAlignment: align,
      children: [
        Container(
          decoration: BoxDecoration(
            color: background,
            borderRadius: BorderRadius.circular(14),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          child: Text(
            text,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: textColor),
          ),
        ),
      ],
    );
  }
}
