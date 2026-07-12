import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zeimoto/app/add_plant_wizard.dart';
import 'package:zeimoto/domain/plant_creation_flow.dart';
import 'package:zeimoto/domain/plants.dart';
import 'package:zeimoto/l10n/app_localizations.dart';

// ---------------------------------------------------------------------------
// Test double
// ---------------------------------------------------------------------------
class _FakeRepo implements PlantRepository {
  final List<Plant> _plants = [];

  @override
  List<Plant> get plants => List.unmodifiable(_plants);

  @override
  Plant add({
    required String species,
    String? nickname,
    required PlaceholderPhoto cover,
  }) {
    final plant = Plant(
      id: 'fake-${_plants.length}',
      species: species,
      nickname: nickname ?? defaultNickname(species, _plants.length),
      cover: cover,
      createdAt: DateTime.now(),
    );
    _plants.insert(0, plant);
    return plant;
  }
}

// ---------------------------------------------------------------------------
// Helpers
// ---------------------------------------------------------------------------
Widget _buildSubject(AddPlantWizard wizard) {
  return MaterialApp(
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    locale: const Locale('it'),
    home: wizard,
  );
}

void main() {
  late _FakeRepo repo;
  late PlantCreationFlow flow;

  setUp(() {
    repo = _FakeRepo();
    flow = PlantCreationFlow(repo);
  });

  // -------------------------------------------------------------------------
  // Cycle 1 — tracer bullet: wizard opens on step Foto
  // -------------------------------------------------------------------------
  group('step Foto', () {
    testWidgets('wizard opens showing the photo grid', (tester) async {
      await tester.pumpWidget(_buildSubject(AddPlantWizard(flow: flow)));
      await tester.pump();

      expect(find.byKey(const Key('wizard_photo_grid')), findsOneWidget);
    });

    // -----------------------------------------------------------------------
    // Cycle 2 — Avanti disabled with no photo selected
    // -----------------------------------------------------------------------
    testWidgets('"Avanti" is disabled when no photo is selected', (
      tester,
    ) async {
      await tester.pumpWidget(_buildSubject(AddPlantWizard(flow: flow)));
      await tester.pump();

      final btn = tester.widget<ElevatedButton>(
        find.byKey(const Key('wizard_next_button')),
      );
      expect(btn.onPressed, isNull);
    });

    // -----------------------------------------------------------------------
    // Cycle 3 — select photo → Avanti enabled → advances to step Specie
    // -----------------------------------------------------------------------
    testWidgets(
      'selecting a photo enables "Avanti" and advances to step Specie',
      (tester) async {
        await tester.pumpWidget(_buildSubject(AddPlantWizard(flow: flow)));
        await tester.pump();

        await tester.tap(find.byKey(const Key('wizard_photo_item_0')));
        await tester.pump();

        final btn = tester.widget<ElevatedButton>(
          find.byKey(const Key('wizard_next_button')),
        );
        expect(btn.onPressed, isNotNull);

        await tester.tap(find.byKey(const Key('wizard_next_button')));
        await tester.pump();

        expect(find.byKey(const Key('wizard_species_field')), findsOneWidget);
      },
    );
  });

  // -------------------------------------------------------------------------
  // Cycle 4 — step Specie: Avanti disabled when species is empty
  // -------------------------------------------------------------------------
  group('step Specie', () {
    Future<void> _advanceToStepSpecie(WidgetTester tester) async {
      await tester.pumpWidget(_buildSubject(AddPlantWizard(flow: flow)));
      await tester.pump();
      await tester.tap(find.byKey(const Key('wizard_photo_item_0')));
      await tester.pump();
      await tester.tap(find.byKey(const Key('wizard_next_button')));
      await tester.pump();
    }

    testWidgets('"Avanti" is disabled when species is empty', (tester) async {
      await _advanceToStepSpecie(tester);

      final btn = tester.widget<ElevatedButton>(
        find.byKey(const Key('wizard_next_button')),
      );
      expect(btn.onPressed, isNull);
    });

    // -----------------------------------------------------------------------
    // Cycle 5 — typing species enables Avanti
    // -----------------------------------------------------------------------
    testWidgets('typing a species enables "Avanti"', (tester) async {
      await _advanceToStepSpecie(tester);

      await tester.enterText(
        find.byKey(const Key('wizard_species_field')),
        'Ficus carica',
      );
      await tester.pump();

      final btn = tester.widget<ElevatedButton>(
        find.byKey(const Key('wizard_next_button')),
      );
      expect(btn.onPressed, isNotNull);
    });

    // -----------------------------------------------------------------------
    // Cycle 6 — tapping a seed species enables Avanti
    // -----------------------------------------------------------------------
    testWidgets('tapping a seed species from the list enables "Avanti"', (
      tester,
    ) async {
      await _advanceToStepSpecie(tester);

      await tester.tap(find.byKey(const Key('wizard_species_item_0')));
      await tester.pump();

      final btn = tester.widget<ElevatedButton>(
        find.byKey(const Key('wizard_next_button')),
      );
      expect(btn.onPressed, isNotNull);
    });
  });

  // -------------------------------------------------------------------------
  // Cycle 7 — step Nickname: Salva always enabled
  // -------------------------------------------------------------------------
  group('step Nickname', () {
    Future<void> _advanceToStepNickname(WidgetTester tester) async {
      await tester.pumpWidget(_buildSubject(AddPlantWizard(flow: flow)));
      await tester.pump();
      await tester.tap(find.byKey(const Key('wizard_photo_item_0')));
      await tester.pump();
      await tester.tap(find.byKey(const Key('wizard_next_button')));
      await tester.pump();
      await tester.tap(find.byKey(const Key('wizard_species_item_0')));
      await tester.pump();
      await tester.tap(find.byKey(const Key('wizard_next_button')));
      await tester.pump();
    }

    testWidgets('"Salva" is enabled even with empty nickname', (tester) async {
      await _advanceToStepNickname(tester);

      final btn = tester.widget<ElevatedButton>(
        find.byKey(const Key('wizard_save_button')),
      );
      expect(btn.onPressed, isNotNull);
    });
  });

  // -------------------------------------------------------------------------
  // Cycle 8 — ✕ closes without saving
  // -------------------------------------------------------------------------
  testWidgets('closing the wizard does not save to the repository', (
    tester,
  ) async {
    // Wrap in a Navigator so pop() works in tests.
    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        locale: const Locale('it'),
        home: Builder(
          builder: (context) => ElevatedButton(
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => AddPlantWizard(flow: flow)),
            ),
            child: const Text('open'),
          ),
        ),
      ),
    );
    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('wizard_close_button')));
    await tester.pumpAndSettle();

    expect(repo.plants, isEmpty);
  });

  // -------------------------------------------------------------------------
  // Cycle 9 — happy path: plant appears in repository after save
  // -------------------------------------------------------------------------
  testWidgets('completing the wizard saves the plant to the repository', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        locale: const Locale('it'),
        home: Builder(
          builder: (context) => ElevatedButton(
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => AddPlantWizard(flow: flow)),
            ),
            child: const Text('open'),
          ),
        ),
      ),
    );
    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();

    // Step 1 — select first photo
    await tester.tap(find.byKey(const Key('wizard_photo_item_0')));
    await tester.pump();
    await tester.tap(find.byKey(const Key('wizard_next_button')));
    await tester.pump();

    // Step 2 — select first species from list
    await tester.tap(find.byKey(const Key('wizard_species_item_0')));
    await tester.pump();
    await tester.tap(find.byKey(const Key('wizard_next_button')));
    await tester.pump();

    // Step 3 — save with empty nickname
    await tester.tap(find.byKey(const Key('wizard_save_button')));
    await tester.pumpAndSettle();

    expect(repo.plants, hasLength(1));
    expect(repo.plants.first.species, kSeedSpecies.first);
  });
}
