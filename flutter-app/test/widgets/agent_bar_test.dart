import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zeimoto/core/design/zeimoto_theme.dart';
import 'package:zeimoto/l10n/app_localizations.dart';
import 'package:zeimoto/widgets/agent_bar.dart';

void main() {
  group('AgentBar', () {
    /// Monta AgentBar in isolamento con localizzazione italiana.
    Widget buildWidget({double? height}) {
      return MaterialApp(
        theme: ZeimotoTheme.light,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        locale: const Locale('it'),
        home: Scaffold(
          body: height != null
              ? AgentBar(height: height)
              : const AgentBar(),
        ),
      );
    }

    testWidgets('mostra il testo hint localizzato', (tester) async {
      await tester.pumpWidget(buildWidget());
      final l10n = lookupAppLocalizations(const Locale('it'));
      expect(find.text(l10n.agent_bar_hint_text), findsOneWidget);
    });

    testWidgets('TextField è avvolto in AbsorbPointer (non interattivo)', (
      tester,
    ) async {
      await tester.pumpWidget(buildWidget());
      // Deve esistere un AbsorbPointer con absorbing:true che avvolge il TextField.
      expect(
        find.ancestor(
          of: find.byType(TextField),
          matching: find.byWidgetPredicate(
            (w) => w is AbsorbPointer && w.absorbing,
          ),
        ),
        findsOneWidget,
      );
    });

    testWidgets('rispetta il parametro height custom', (tester) async {
      const customHeight = 80.0;
      await tester.pumpWidget(buildWidget(height: customHeight));

      final container = tester.widget<Container>(
        find.ancestor(
          of: find.byType(TextField),
          matching: find.byType(Container),
        ).first,
      );
      expect(container.constraints?.maxHeight, customHeight);
    });
  });
}
