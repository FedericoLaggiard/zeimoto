import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zeimoto/core/design/zeimoto_theme.dart';
import 'package:zeimoto/features/calendar/calendar_section.dart';
import 'package:zeimoto/l10n/app_localizations.dart';

void main() {
  group('CalendarSection', () {
    Widget buildTestApp() {
      return MaterialApp(
        theme: ZeimotoTheme.light,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        locale: const Locale('it'),
        home: const Scaffold(
          body: SingleChildScrollView(child: CalendarSection()),
        ),
      );
    }

    testWidgets('renders two static blocks with clear distinction', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(buildTestApp());

      final l10n = lookupAppLocalizations(const Locale('it'));

      expect(find.text(l10n.calendar_section_title), findsOneWidget);
      expect(
        find.byKey(const Key('calendar_past_events_block')),
        findsOneWidget,
      );
      expect(
        find.byKey(const Key('calendar_suggested_tasks_block')),
        findsOneWidget,
      );

      expect(find.text(l10n.calendar_past_events_title), findsOneWidget);
      expect(find.text(l10n.calendar_suggested_tasks_title), findsOneWidget);
      expect(find.text(l10n.calendar_suggested_badge), findsNWidgets(3));
    });

    testWidgets('uses only mock static entries', (WidgetTester tester) async {
      await tester.pumpWidget(buildTestApp());

      final l10n = lookupAppLocalizations(const Locale('it'));

      expect(find.text(l10n.calendar_past_event_1_title), findsOneWidget);
      expect(find.text(l10n.calendar_past_event_2_title), findsOneWidget);
      expect(find.text(l10n.calendar_past_event_3_title), findsOneWidget);

      expect(find.text(l10n.calendar_suggested_task_1_title), findsOneWidget);
      expect(find.text(l10n.calendar_suggested_task_2_title), findsOneWidget);
      expect(find.text(l10n.calendar_suggested_task_3_title), findsOneWidget);
    });
  });
}
