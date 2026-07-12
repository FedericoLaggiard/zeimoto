import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

import 'package:zeimoto/domain/plants.dart';
import 'package:zeimoto/features/add_plant/add_plant_wizard.dart';
import 'package:zeimoto/l10n/app_localizations.dart';

// ---------------------------------------------------------------------------
// Test double
// ---------------------------------------------------------------------------
class _FakeRepo implements PlantRepository {
  final List<Plant> _plants = [];

  @override
  List<Plant> get plants => List.unmodifiable(_plants);

  @override
  Stream<void> get changes => Stream.empty();

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

/// Wraps [AddPlantWizard] as the MaterialApp home — for tests that don't
/// need a full navigator stack.
Widget _buildSubject(_FakeRepo repo) {
  return RepositoryProvider<PlantRepository>.value(
    value: repo,
    child: MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: const Locale('it'),
      home: const AddPlantWizard(),
    ),
  );
}

/// Wraps [AddPlantWizard] behind a GoRouter push — for tests that need
/// pop() to be observable (close / save).
Widget _buildNavigatorSubject(_FakeRepo repo) {
  final router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => Scaffold(
          body: ElevatedButton(
            onPressed: () => context.push('/wizard'),
            child: const Text('open'),
          ),
        ),
        routes: [
          GoRoute(
            path: 'wizard',
            pageBuilder: (context, state) => const MaterialPage(
              fullscreenDialog: true,
              child: AddPlantWizard(),
            ),
          ),
        ],
      ),
    ],
  );

  return RepositoryProvider<PlantRepository>.value(
    value: repo,
    child: MaterialApp.router(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: const Locale('it'),
      routerConfig: router,
    ),
  );
}

void main() {
  late _FakeRepo repo;

  setUp(() => repo = _FakeRepo());

  // -------------------------------------------------------------------------
  // Step Foto
  // -------------------------------------------------------------------------
  group('step Foto', () {
    testWidgets('wizard opens showing the photo grid', (tester) async {
      await tester.pumpWidget(_buildSubject(repo));
      await tester.pump();

      expect(find.byKey(const Key('wizard_photo_grid')), findsOneWidget);
    });

    testWidgets('"Avanti" is disabled when no photo is selected', (
      tester,
    ) async {
      await tester.pumpWidget(_buildSubject(repo));
      await tester.pump();

      final btn = tester.widget<ElevatedButton>(
        find.byKey(const Key('wizard_next_button')),
      );
      expect(btn.onPressed, isNull);
    });

    testWidgets(
      'selecting a photo enables "Avanti" and advances to step Specie',
      (tester) async {
        await tester.pumpWidget(_buildSubject(repo));
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
  // Step Specie
  // -------------------------------------------------------------------------
  group('step Specie', () {
    Future<void> advanceToStepSpecie(WidgetTester tester) async {
      await tester.pumpWidget(_buildSubject(repo));
      await tester.pump();
      await tester.tap(find.byKey(const Key('wizard_photo_item_0')));
      await tester.pump();
      await tester.tap(find.byKey(const Key('wizard_next_button')));
      await tester.pump();
    }

    testWidgets('"Avanti" is disabled when species is empty', (tester) async {
      await advanceToStepSpecie(tester);

      final btn = tester.widget<ElevatedButton>(
        find.byKey(const Key('wizard_next_button')),
      );
      expect(btn.onPressed, isNull);
    });

    testWidgets('typing a species enables "Avanti"', (tester) async {
      await advanceToStepSpecie(tester);

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

    testWidgets('tapping a seed species from the list enables "Avanti"', (
      tester,
    ) async {
      await advanceToStepSpecie(tester);

      await tester.tap(find.byKey(const Key('wizard_species_item_0')));
      await tester.pump();

      final btn = tester.widget<ElevatedButton>(
        find.byKey(const Key('wizard_next_button')),
      );
      expect(btn.onPressed, isNotNull);
    });
  });

  // -------------------------------------------------------------------------
  // Step Nickname
  // -------------------------------------------------------------------------
  group('step Nickname', () {
    Future<void> advanceToStepNickname(WidgetTester tester) async {
      await tester.pumpWidget(_buildSubject(repo));
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

    testWidgets('"Salva" is enabled even with an empty nickname', (
      tester,
    ) async {
      await advanceToStepNickname(tester);

      final btn = tester.widget<ElevatedButton>(
        find.byKey(const Key('wizard_save_button')),
      );
      expect(btn.onPressed, isNotNull);
    });
  });

  // -------------------------------------------------------------------------
  // Close without saving
  // -------------------------------------------------------------------------
  testWidgets('closing the wizard does not save to the repository', (
    tester,
  ) async {
    await tester.pumpWidget(_buildNavigatorSubject(repo));
    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('wizard_close_button')));
    await tester.pumpAndSettle();

    expect(repo.plants, isEmpty);
  });

  // -------------------------------------------------------------------------
  // Happy path
  // -------------------------------------------------------------------------
  testWidgets('completing the wizard saves the plant to the repository', (
    tester,
  ) async {
    await tester.pumpWidget(_buildNavigatorSubject(repo));
    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();

    // Step 1 — select first photo
    await tester.tap(find.byKey(const Key('wizard_photo_item_0')));
    await tester.pump();
    await tester.tap(find.byKey(const Key('wizard_next_button')));
    await tester.pump();

    // Step 2 — select first species from the seed list
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

  testWidgets('typed nickname is persisted instead of generated default', (
    tester,
  ) async {
    await tester.pumpWidget(_buildNavigatorSubject(repo));
    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('wizard_photo_item_0')));
    await tester.pump();
    await tester.tap(find.byKey(const Key('wizard_next_button')));
    await tester.pump();

    await tester.tap(find.byKey(const Key('wizard_species_item_0')));
    await tester.pump();
    await tester.tap(find.byKey(const Key('wizard_next_button')));
    await tester.pump();

    await tester.enterText(
      find.byKey(const Key('wizard_nickname_field')),
      'Momo',
    );
    await tester.pump();

    await tester.tap(find.byKey(const Key('wizard_save_button')));
    await tester.pumpAndSettle();

    expect(repo.plants, hasLength(1));
    expect(repo.plants.first.nickname, 'Momo');
  });

  testWidgets('completing wizard shows save feedback snackbar', (
    tester,
  ) async {
    await tester.pumpWidget(_buildNavigatorSubject(repo));
    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('wizard_photo_item_0')));
    await tester.pump();
    await tester.tap(find.byKey(const Key('wizard_next_button')));
    await tester.pump();

    await tester.tap(find.byKey(const Key('wizard_species_item_0')));
    await tester.pump();
    await tester.tap(find.byKey(const Key('wizard_next_button')));
    await tester.pump();

    await tester.tap(find.byKey(const Key('wizard_save_button')));
    await tester.pump(); // trigger listener, show snackbar

    expect(find.byType(SnackBar), findsAtLeastNWidgets(1));
  });
}
