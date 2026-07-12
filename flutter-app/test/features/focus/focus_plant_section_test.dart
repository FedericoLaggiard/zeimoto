import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:zeimoto/core/design/zeimoto_theme.dart';
import 'package:zeimoto/domain/plants.dart';
import 'package:zeimoto/features/focus/focus_plant_section.dart';
import 'package:zeimoto/l10n/app_localizations.dart';

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
    throw UnimplementedError('Test fixture only');
  }

  Plant addWithTime({
    required String species,
    required String nickname,
    required PlaceholderPhoto cover,
    required DateTime createdAt,
  }) {
    final plant = Plant(
      id: 'fake-${_plants.length}',
      species: species,
      nickname: nickname,
      cover: cover,
      createdAt: createdAt,
    );
    _plants.add(plant);
    return plant;
  }
}

void main() {
  Widget buildHarness({
    required PlantRepository repository,
    required ValueChanged<Plant> onTapPlant,
    int Function(int max)? randomIndex,
  }) {
    return MaterialApp(
      theme: ZeimotoTheme.light,
      locale: const Locale('it'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: Scaffold(
        body: RepositoryProvider<PlantRepository>.value(
          value: repository,
          child: FocusPlantSection(
            onTapPlant: onTapPlant,
            randomIndex: randomIndex,
          ),
        ),
      ),
    );
  }

  group('FocusPlantSection widget', () {
    testWidgets('shows one random plant from repository', (
      WidgetTester tester,
    ) async {
      final repo = _FakeRepo();
      repo.addWithTime(
        species: 'Acer palmatum',
        nickname: 'acero_01',
        cover: PlaceholderPhoto.palette[0],
        createdAt: DateTime(2026, 1, 10),
      );
      repo.addWithTime(
        species: 'Juniperus chinensis',
        nickname: 'ginepro_01',
        cover: PlaceholderPhoto.palette[1],
        createdAt: DateTime(2026, 1, 9),
      );

      await tester.pumpWidget(
        buildHarness(
          repository: repo,
          onTapPlant: (_) {},
          randomIndex: (_) => 1,
        ),
      );

      expect(find.text('ginepro_01'), findsOneWidget);
      expect(find.text('Juniperus chinensis'), findsOneWidget);
      expect(find.text('acero_01'), findsNothing);
    });

    testWidgets('selection happens once and does not change on rebuild', (
      WidgetTester tester,
    ) async {
      final repo = _FakeRepo();
      repo.addWithTime(
        species: 'Acer palmatum',
        nickname: 'acero_01',
        cover: PlaceholderPhoto.palette[0],
        createdAt: DateTime(2026, 1, 10),
      );
      repo.addWithTime(
        species: 'Juniperus chinensis',
        nickname: 'ginepro_01',
        cover: PlaceholderPhoto.palette[1],
        createdAt: DateTime(2026, 1, 9),
      );

      var calls = 0;
      int changingIndex(int max) {
        final next = calls % max;
        calls += 1;
        return next;
      }

      await tester.pumpWidget(
        buildHarness(
          repository: repo,
          onTapPlant: (_) {},
          randomIndex: changingIndex,
        ),
      );

      expect(find.text('acero_01'), findsOneWidget);
      expect(calls, 1);

      await tester.pump();
      await tester.pumpAndSettle();

      expect(find.text('acero_01'), findsOneWidget);
      expect(find.text('ginepro_01'), findsNothing);
      expect(calls, 1);
    });

    testWidgets('tapping the card calls onTapPlant for selected plant', (
      WidgetTester tester,
    ) async {
      final repo = _FakeRepo();
      final selected = repo.addWithTime(
        species: 'Acer palmatum',
        nickname: 'acero_01',
        cover: PlaceholderPhoto.palette[0],
        createdAt: DateTime(2026, 1, 10),
      );

      Plant? tappedPlant;
      await tester.pumpWidget(
        buildHarness(
          repository: repo,
          onTapPlant: (plant) => tappedPlant = plant,
          randomIndex: (_) => 0,
        ),
      );

      await tester.tap(find.text('acero_01'));
      await tester.pumpAndSettle();

      expect(tappedPlant, isNotNull);
      expect(tappedPlant?.id, selected.id);
    });

    testWidgets('shows empty state when repository has no plants', (
      WidgetTester tester,
    ) async {
      final repo = _FakeRepo();

      await tester.pumpWidget(
        buildHarness(repository: repo, onTapPlant: (_) {}),
      );

      final l10n = lookupAppLocalizations(const Locale('it'));
      expect(find.text(l10n.focus_plant_empty), findsOneWidget);
      expect(find.byType(GestureDetector), findsNothing);
    });
  });
}
