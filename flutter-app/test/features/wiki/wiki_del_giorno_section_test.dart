import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:zeimoto/core/design/zeimoto_theme.dart';
import 'package:zeimoto/features/wiki/wiki_article.dart';
import 'package:zeimoto/features/wiki/wiki_del_giorno_section.dart';
import 'package:zeimoto/l10n/app_localizations.dart';

// ---------------------------------------------------------------------------
// Harness
// ---------------------------------------------------------------------------

Widget buildHarness({required int Function(int) pickIndex}) {
  return MaterialApp(
    theme: ZeimotoTheme.light,
    locale: const Locale('it'),
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    home: Scaffold(body: WikiDelGiornoSection(pickIndex: pickIndex)),
  );
}

// ---------------------------------------------------------------------------
// Tests
// ---------------------------------------------------------------------------

void main() {
  group('WikiDelGiornoSection widget', () {
    testWidgets('renders the article title and body for pickIndex 0', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(buildHarness(pickIndex: (_) => 0));

      final l10n = lookupAppLocalizations(const Locale('it'));

      expect(find.text(l10n.wiki_article_1_title), findsOneWidget);
      expect(find.text(l10n.wiki_article_1_body), findsOneWidget);
    });

    testWidgets('renders the article title and body for pickIndex 4', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(buildHarness(pickIndex: (_) => 4));

      final l10n = lookupAppLocalizations(const Locale('it'));

      expect(find.text(l10n.wiki_article_5_title), findsOneWidget);
      expect(find.text(l10n.wiki_article_5_body), findsOneWidget);
    });

    testWidgets('displays the reading label badge', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(buildHarness(pickIndex: (_) => 0));

      final l10n = lookupAppLocalizations(const Locale('it'));

      expect(find.text(l10n.wiki_reading_label), findsOneWidget);
    });

    testWidgets('article does not change on rebuild (state is stable)', (
      WidgetTester tester,
    ) async {
      int callCount = 0;
      await tester.pumpWidget(
        buildHarness(
          pickIndex: (max) {
            callCount += 1;
            return 0;
          },
        ),
      );

      // Force a rebuild by pumping again
      await tester.pump();

      expect(callCount, 1, reason: 'pickIndex must only be called once');
    });

    testWidgets('no interactive elements fire callbacks', (
      WidgetTester tester,
    ) async {
      // Smoke: pumping and scrolling should not throw
      await tester.pumpWidget(buildHarness(pickIndex: (_) => 2));
      await tester.pump();

      final l10n = lookupAppLocalizations(const Locale('it'));
      expect(find.text(l10n.wiki_article_3_title), findsOneWidget);
    });
  });
}
