import 'package:flutter/material.dart';

import '../../core/design/zeimoto_theme.dart';
import '../../l10n/app_localizations.dart';

/// Static Calendar section for home.
///
/// This MVP slice intentionally exposes two non-interactive blocks:
/// - past events (historical)
/// - AI suggested tasks (proposals only)
class CalendarSection extends StatelessWidget {
  const CalendarSection({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final pastEvents = [
      _CalendarEntry(
        title: l10n.calendar_past_event_1_title,
        dateLabel: l10n.calendar_past_event_1_date,
      ),
      _CalendarEntry(
        title: l10n.calendar_past_event_2_title,
        dateLabel: l10n.calendar_past_event_2_date,
      ),
      _CalendarEntry(
        title: l10n.calendar_past_event_3_title,
        dateLabel: l10n.calendar_past_event_3_date,
      ),
    ];

    final suggestedTasks = [
      _CalendarEntry(
        title: l10n.calendar_suggested_task_1_title,
        dateLabel: l10n.calendar_suggested_task_1_date,
      ),
      _CalendarEntry(
        title: l10n.calendar_suggested_task_2_title,
        dateLabel: l10n.calendar_suggested_task_2_date,
      ),
      _CalendarEntry(
        title: l10n.calendar_suggested_task_3_title,
        dateLabel: l10n.calendar_suggested_task_3_date,
      ),
    ];

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.calendar_section_title,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 12),
          _CalendarBlock(
            key: const Key('calendar_past_events_block'),
            title: l10n.calendar_past_events_title,
            accent: ZeimotoColors.sage,
            background: ZeimotoColors.washiDeep,
            border: ZeimotoColors.sage.withValues(alpha: 0.35),
            entries: pastEvents,
            showSuggestedBadge: false,
          ),
          const SizedBox(height: 10),
          _CalendarBlock(
            key: const Key('calendar_suggested_tasks_block'),
            title: l10n.calendar_suggested_tasks_title,
            accent: ZeimotoColors.cinnabar,
            background: ZeimotoColors.cinnabar.withValues(alpha: 0.08),
            border: ZeimotoColors.cinnabar.withValues(alpha: 0.32),
            entries: suggestedTasks,
            showSuggestedBadge: true,
          ),
        ],
      ),
    );
  }
}

class _CalendarBlock extends StatelessWidget {
  const _CalendarBlock({
    super.key,
    required this.title,
    required this.accent,
    required this.background,
    required this.border,
    required this.entries,
    required this.showSuggestedBadge,
  });

  final String title;
  final Color accent;
  final Color background;
  final Color border;
  final List<_CalendarEntry> entries;
  final bool showSuggestedBadge;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(color: ZeimotoColors.charcoal),
          ),
          const SizedBox(height: 10),
          for (var i = 0; i < entries.length; i++) ...[
            _CalendarRow(
              entry: entries[i],
              accent: accent,
              showSuggestedBadge: showSuggestedBadge,
              suggestedBadge: l10n.calendar_suggested_badge,
              index: i,
            ),
            if (i != entries.length - 1)
              Divider(
                height: 18,
                color: ZeimotoColors.charcoalSoft.withValues(alpha: 0.2),
              ),
          ],
        ],
      ),
    );
  }
}

class _CalendarRow extends StatelessWidget {
  const _CalendarRow({
    required this.entry,
    required this.accent,
    required this.showSuggestedBadge,
    required this.suggestedBadge,
    required this.index,
  });

  final _CalendarEntry entry;
  final Color accent;
  final bool showSuggestedBadge;
  final String suggestedBadge;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 3),
          child: Icon(Icons.fiber_manual_record, size: 10, color: accent),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                entry.title,
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(color: ZeimotoColors.charcoal),
              ),
              const SizedBox(height: 3),
              Row(
                children: [
                  Text(
                    entry.dateLabel,
                    style: Theme.of(context).textTheme.labelSmall,
                  ),
                  if (showSuggestedBadge) ...[
                    const SizedBox(width: 8),
                    Container(
                      key: Key('calendar_suggested_badge_$index'),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 7,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: ZeimotoColors.cinnabar.withValues(alpha: 0.14),
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Text(
                        suggestedBadge,
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: ZeimotoColors.cinnabar,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _CalendarEntry {
  const _CalendarEntry({required this.title, required this.dateLabel});

  final String title;
  final String dateLabel;
}
