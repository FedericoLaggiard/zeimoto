import 'package:flutter/material.dart';

import '../../core/design/zeimoto_theme.dart';
import '../../l10n/app_localizations.dart';

/// Static AI assistant section for the home screen.
///
/// This widget intentionally has no interactive behavior in MVP slice A7.
class AiAssistantSection extends StatelessWidget {
  const AiAssistantSection({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.ai_assistant_section_title,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 12),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: ZeimotoColors.moss.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: ZeimotoColors.sage.withValues(alpha: 0.4),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: ZeimotoColors.moss.withValues(alpha: 0.15),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.wb_sunny_outlined,
                        color: ZeimotoColors.moss,
                        size: 18,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      l10n.ai_assistant_card_label,
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: ZeimotoColors.moss,
                        letterSpacing: 1.0,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                Text(
                  l10n.ai_assistant_card_message,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: ZeimotoColors.charcoal,
                    height: 1.55,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
