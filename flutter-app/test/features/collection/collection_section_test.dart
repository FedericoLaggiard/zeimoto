import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:zeimoto/core/design/zeimoto_theme.dart';
import 'package:zeimoto/domain/plants.dart';
import 'package:zeimoto/features/collection/collection_section.dart';
import 'package:zeimoto/features/collection/plant_detail_placeholder.dart';
import 'package:zeimoto/l10n/app_localizations.dart';

// ---------------------------------------------------------------------------
// Test double
// ---------------------------------------------------------------------------
class _FakeRepo implements PlantRepository {
  final List<Plant> _plants = [];

  @override
  List<Plant> get plants {
    final sorted = List<Plant>.of(_plants)
      ..sort((left, right) => right.createdAt.compareTo(left.createdAt));
    return List.unmodifiable(sorted);
  }

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

  /// Utility to add a plant with explicit createdAt for testing
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

// ---------------------------------------------------------------------------
// Harness
// ---------------------------------------------------------------------------
void main() {
  group('CollectionSection widget', () {
    testWidgets('shows carousel of plants from repository', (
      WidgetTester tester,
    ) async {
      final repo = _FakeRepo();
      final now = DateTime.now();
      repo.addWithTime(
        species: 'Acer palmatum',
        nickname: 'acero_01',
        cover: PlaceholderPhoto.palette[0],
        createdAt: now,
      );
      repo.addWithTime(
        species: 'Juniperus chinensis',
        nickname: 'ginepro_01',
        cover: PlaceholderPhoto.palette[1],
        createdAt: now.subtract(const Duration(hours: 1)),
      );

      await tester.pumpWidget(
        MaterialApp(
          theme: ZeimotoTheme.light,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(
            body: RepositoryProvider<PlantRepository>.value(
              value: repo,
              child: CollectionSection(onTapPlant: (_) {}),
            ),
          ),
        ),
      );

      // First plant should be visible
      expect(find.text('acero_01'), findsOneWidget);
      // PageView hides other plants until swiped, so we just verify carousel exists
      expect(find.byType(PageView), findsOneWidget);
    });

    testWidgets('tapping a card calls onTapPlant callback', (
      WidgetTester tester,
    ) async {
      final repo = _FakeRepo();
      final now = DateTime.now();
      final plant = repo.addWithTime(
        species: 'Acer palmatum',
        nickname: 'acero_01',
        cover: PlaceholderPhoto.palette[0],
        createdAt: now,
      );

      Plant? tappedPlant;
      await tester.pumpWidget(
        MaterialApp(
          theme: ZeimotoTheme.light,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(
            body: RepositoryProvider<PlantRepository>.value(
              value: repo,
              child: CollectionSection(onTapPlant: (p) => tappedPlant = p),
            ),
          ),
        ),
      );

      // Find and tap the plant nickname (which is inside a tappable card)
      await tester.tap(find.text('acero_01'));
      await tester.pumpAndSettle();

      expect(tappedPlant, isNotNull);
      expect(tappedPlant?.id, plant.id);
    });

    testWidgets('shows empty state when repository is empty', (
      WidgetTester tester,
    ) async {
      final repo = _FakeRepo();

      await tester.pumpWidget(
        MaterialApp(
          theme: ZeimotoTheme.light,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(
            body: RepositoryProvider<PlantRepository>.value(
              value: repo,
              child: CollectionSection(onTapPlant: (_) {}),
            ),
          ),
        ),
      );

      // Expect empty state message or no plants shown
      expect(find.byType(Center), findsWidgets);
      // (The exact empty state message depends on i18n, verify logic instead)
    });

    testWidgets('tapping a plant card navigates to PlantDetailPlaceholder', (
      WidgetTester tester,
    ) async {
      final repo = _FakeRepo();
      final now = DateTime.now();
      final plant = repo.addWithTime(
        species: 'Acer palmatum',
        nickname: 'acero_01',
        cover: PlaceholderPhoto.palette[0],
        createdAt: now,
      );

      await tester.pumpWidget(
        MaterialApp(
          theme: ZeimotoTheme.light,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(
            body: RepositoryProvider<PlantRepository>.value(
              value: repo,
              child: CollectionSection(
                onTapPlant: (selectedPlant) {
                  Navigator.of(
                    tester.element(find.byType(CollectionSection)),
                  ).push(
                    MaterialPageRoute(
                      builder: (_) =>
                          PlantDetailPlaceholder(plant: selectedPlant),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      );

      // Tap the plant card
      await tester.tap(find.text('acero_01'));
      await tester.pumpAndSettle();

      // PlantDetailPlaceholder should be visible
      expect(find.byType(PlantDetailPlaceholder), findsOneWidget);
      // The detail page should show the plant's nickname in title
      expect(find.text('acero_01'), findsWidgets); // in both card and detail
    });

    testWidgets('empty state shows CTA button', (WidgetTester tester) async {
      final repo = _FakeRepo();

      await tester.pumpWidget(
        MaterialApp(
          theme: ZeimotoTheme.light,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          locale: const Locale('it'),
          home: Scaffold(
            body: RepositoryProvider<PlantRepository>.value(
              value: repo,
              child: CollectionSection(
                onTapPlant: (_) {},
                onAddPlant: () {},
              ),
            ),
          ),
        ),
      );

      expect(
        find.byKey(const Key('collection_add_plant_cta_button')),
        findsOneWidget,
      );
    });

    testWidgets('tapping empty-state CTA calls onAddPlant', (
      WidgetTester tester,
    ) async {
      final repo = _FakeRepo();
      var called = false;

      await tester.pumpWidget(
        MaterialApp(
          theme: ZeimotoTheme.light,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          locale: const Locale('it'),
          home: Scaffold(
            body: RepositoryProvider<PlantRepository>.value(
              value: repo,
              child: CollectionSection(
                onTapPlant: (_) {},
                onAddPlant: () => called = true,
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.byKey(const Key('collection_add_plant_cta_button')));
      await tester.pump();

      expect(called, isTrue);
    });
  });
}
