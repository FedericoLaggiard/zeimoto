import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:zeimoto/core/design/zeimoto_theme.dart';
import 'package:zeimoto/domain/plants.dart';
import 'package:zeimoto/features/focus/focus_plant_section.dart';
import 'package:zeimoto/l10n/app_localizations.dart';

// ---------------------------------------------------------------------------
// Test double
// ---------------------------------------------------------------------------

class _FakeRepo extends Fake implements PlantRepository {
  final List<Plant> _plants = [];

  @override
  Future<List<Plant>> getAll() async => List.unmodifiable(_plants);

  @override
  Stream<void> get changes => Stream.empty();

  @override
  Future<Plant> add({
    required String species,
    String? nickname,
    required String sourcePhotoPath,
  }) {
    throw UnimplementedError('Test fixture only');
  }

  Plant addPlant({required String species, required String nickname}) {
    final plant = Plant(
      id: 'fake-${_plants.length}',
      species: species,
      nickname: nickname,
      coverPhotoPath: PhotoPath('/fake/photo_${_plants.length}.jpg'),
      createdAt: DateTime(2026, 1, 10 - _plants.length),
    );
    _plants.add(plant);
    return plant;
  }
}

// ---------------------------------------------------------------------------
// Harness
// ---------------------------------------------------------------------------

Widget buildHarness({
  required PlantRepository repository,
  required ValueChanged<Plant> onTapPlant,
}) {
  return MaterialApp(
    theme: ZeimotoTheme.light,
    locale: const Locale('it'),
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    home: Scaffold(
      body: RepositoryProvider<PlantRepository>.value(
        value: repository,
        child: FocusPlantSection(onTapPlant: onTapPlant),
      ),
    ),
  );
}

// ---------------------------------------------------------------------------
// Tests
// ---------------------------------------------------------------------------

void main() {
  group('FocusPlantSection widget', () {
    testWidgets('shows the plant from a single-plant repository', (
      WidgetTester tester,
    ) async {
      final repo = _FakeRepo();
      repo.addPlant(species: 'Juniperus chinensis', nickname: 'ginepro_01');

      await tester.pumpWidget(
        buildHarness(repository: repo, onTapPlant: (_) {}),
      );
      await tester.pump(); // allow async getAll() to complete

      expect(find.text('ginepro_01'), findsOneWidget);
      expect(find.text('Juniperus chinensis'), findsOneWidget);
    });

    testWidgets('tapping the card calls onTapPlant with the displayed plant', (
      WidgetTester tester,
    ) async {
      final repo = _FakeRepo();
      final plant = repo.addPlant(
        species: 'Acer palmatum',
        nickname: 'acero_01',
      );

      Plant? tapped;
      await tester.pumpWidget(
        buildHarness(repository: repo, onTapPlant: (p) => tapped = p),
      );
      await tester.pump();

      await tester.tap(find.text('acero_01'));
      await tester.pumpAndSettle();

      expect(tapped, isNotNull);
      expect(tapped?.id, plant.id);
    });

    testWidgets('shows empty state when repository has no plants', (
      WidgetTester tester,
    ) async {
      final repo = _FakeRepo();

      await tester.pumpWidget(
        buildHarness(repository: repo, onTapPlant: (_) {}),
      );
      await tester.pump();

      final l10n = lookupAppLocalizations(const Locale('it'));
      expect(find.text(l10n.focus_plant_empty), findsOneWidget);
      expect(find.byType(GestureDetector), findsNothing);
    });

    testWidgets('card shows nickname and species', (WidgetTester tester) async {
      final repo = _FakeRepo();
      repo.addPlant(species: 'Pinus parviflora', nickname: 'pino_01');

      await tester.pumpWidget(
        buildHarness(repository: repo, onTapPlant: (_) {}),
      );
      await tester.pump();

      expect(find.text('pino_01'), findsOneWidget);
      expect(find.text('Pinus parviflora'), findsOneWidget);
    });
  });
}
