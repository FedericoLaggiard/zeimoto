import 'package:flutter/material.dart';

class SuggestionBanner extends StatelessWidget {
  final List<String> messages;
  const SuggestionBanner({super.key, required this.messages});
  @override
  Widget build(BuildContext context) {
    if (messages.isEmpty) return const SizedBox.shrink();
    return Container(
      color: Colors.green.shade50,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Suggerimenti stagionali'),
          const SizedBox(height: 6),
          ...messages.map((m) => Text('• $m')),
        ],
      ),
    );
  }
}
