import 'package:flutter/material.dart';

class ChatBubble extends StatelessWidget {
  final bool isAi;
  final String text;

  const ChatBubble({super.key, required this.isAi, required this.text});

  @override
  Widget build(BuildContext context) {
    final bg = isAi
        ? Colors.grey.shade200
        : Theme.of(context).colorScheme.primary.withOpacity(0.15);
    final align = isAi ? CrossAxisAlignment.start : CrossAxisAlignment.end;
    return Column(
      crossAxisAlignment: align,
      children: [
        Container(
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.all(12),
          child: Text(text),
        ),
      ],
    );
  }
}
