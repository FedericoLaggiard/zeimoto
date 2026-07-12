import 'package:flutter/material.dart';

import '../core/design/zeimoto_theme.dart';
import '../l10n/app_localizations.dart';

/// Agent bar component — pinned at the bottom of the app shell.
///
/// Displays a non-interactive "Cosa vuoi fare oggi?" affordance field.
/// The action to add a plant is exposed via the FAB on [Home],
/// not inside this bar (see ADR-0004 for the routing policy).
///
/// The text field is wrapped in [AbsorbPointer] to prevent focus and keyboard:
/// free-text intent detection is deferred to a future slice.
class AgentBar extends StatelessWidget {
  const AgentBar({super.key, this.height = ZeimotoSpacing.agentBarHeight});

  final double height;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Container(
      height: height,
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        border: Border(
          top: BorderSide(
            color: Theme.of(
              context,
            ).colorScheme.onSurface.withValues(alpha: 0.1),
            width: 1,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: ZeimotoSpacing.agentBarShadowColor,
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: AbsorbPointer(
        child: TextField(
          decoration: InputDecoration(
            hintText: l10n.agent_bar_hint_text,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: Theme.of(
                  context,
                ).colorScheme.onSurface.withValues(alpha: 0.2),
              ),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 10,
            ),
            isDense: true,
          ),
        ),
      ),
    );
  }
}
