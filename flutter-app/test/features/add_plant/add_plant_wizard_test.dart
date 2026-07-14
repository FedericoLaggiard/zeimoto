import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mocktail/mocktail.dart';

import 'package:zeimoto/domain/plants.dart';
import 'package:zeimoto/features/add_plant/add_plant_wizard.dart';
import 'package:zeimoto/l10n/app_localizations.dart';

// ---------------------------------------------------------------------------
// Mocks & test doubles
// ---------------------------------------------------------------------------
class MockImagePicker extends Mock implements ImagePicker {}

class _FakeRepo extends Fake implements PlantRepository {
  final List<Plant> _plants = [];

  List<Plant> get plantsSync => List.unmodifiable(_plants);

  @override
  Future<List<Plant>> getAll() async => List.unmodifiable(_plants);

  @override
  Stream<void> get changes => Stream.empty();

  @override
  Future<Plant> add({
    required String species,
    String? nickname,
    required String sourcePhotoPath,
  }) async {
    final plant = Plant(
      id: 'fake-${_plants.length}',
      species: species,
      nickname: nickname ?? defaultNickname(species, _plants.length),
      coverPhotoPath: sourcePhotoPath,
      createdAt: DateTime.now(),
    );
    _plants.insert(0, plant);
    return plant;
  }
}

const _kFakePhotoPath = '/fake/cover.jpg';

// ---------------------------------------------------------------------------
// Helpers
// ---------------------------------------------------------------------------

Widget _buildSubject(_FakeRepo repo, MockImagePicker picker) {
  return RepositoryProvider<PlantRepository>.value(
    value: repo,
    child: MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: const Locale('it'),
      home: AddPlantWizard(imagePicker: picker),
    ),
  );
}

Widget _buildNavigatorSubject(_FakeRepo repo, MockImagePicker picker) {
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
            pageBuilder: (context, state) => MaterialPage(
              fullscreenDialog: true,
              child: AddPlantWizard(imagePicker: picker),
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

/// Configures [picker] to return [_kFakePhotoPath] for any [pickImage] call.
void _stubPickerSuccess(MockImagePicker picker) {
  when(
    () => picker.pickImage(
      source: any(named: 'source'),
      imageQuality: any(named: 'imageQuality'),
      maxWidth: any(named: 'maxWidth'),
      maxHeight: any(named: 'maxHeight'),
    ),
  ).thenAnswer((_) async => XFile(_kFakePhotoPath));
}

/// Advances the wizard to step Specie by "picking" a photo via the mock picker.
Future<void> _advanceToStepSpecie(
  WidgetTester tester,
  MockImagePicker picker,
) async {
  _stubPickerSuccess(picker);
  await tester.tap(find.byKey(const Key('wizard_pick_photo_gallery_button')));
  await tester.pumpAndSettle();
  await tester.tap(find.byKey(const Key('wizard_next_button')));
  await tester.pump();
}

void main() {
  setUpAll(() => registerFallbackValue(ImageSource.camera));

  late _FakeRepo repo;
  late MockImagePicker picker;

  setUp(() {
    repo = _FakeRepo();
    picker = MockImagePicker();
  });

  // -------------------------------------------------------------------------
  // Step Foto
  // -------------------------------------------------------------------------
  group('step Foto', () {
    testWidgets('wizard opens showing the photo picker area', (tester) async {
      await tester.pumpWidget(_buildSubject(repo, picker));
      await tester.pump();

      expect(
        find.byKey(const Key('wizard_pick_photo_camera_button')),
        findsOneWidget,
      );
      expect(
        find.byKey(const Key('wizard_pick_photo_gallery_button')),
        findsOneWidget,
      );
    });

    testWidgets('"Avanti" is disabled when no photo is selected', (
      tester,
    ) async {
      await tester.pumpWidget(_buildSubject(repo, picker));
      await tester.pump();

      final btn = tester.widget<ElevatedButton>(
        find.byKey(const Key('wizard_next_button')),
      );
      expect(btn.onPressed, isNull);
    });

    testWidgets(
      'picking a photo enables "Avanti" and advances to step Specie',
      (tester) async {
        _stubPickerSuccess(picker);
        await tester.pumpWidget(_buildSubject(repo, picker));
        await tester.pump();

        await tester.tap(
          find.byKey(const Key('wizard_pick_photo_gallery_button')),
        );
        await tester.pumpAndSettle();

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
    testWidgets('"Avanti" is disabled when species is empty', (tester) async {
      await tester.pumpWidget(_buildSubject(repo, picker));
      await _advanceToStepSpecie(tester, picker);

      final btn = tester.widget<ElevatedButton>(
        find.byKey(const Key('wizard_next_button')),
      );
      expect(btn.onPressed, isNull);
    });

    testWidgets('typing a species enables "Avanti"', (tester) async {
      await tester.pumpWidget(_buildSubject(repo, picker));
      await _advanceToStepSpecie(tester, picker);

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
      await tester.pumpWidget(_buildSubject(repo, picker));
      await _advanceToStepSpecie(tester, picker);

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
    testWidgets('"Salva" is enabled even with an empty nickname', (
      tester,
    ) async {
      await tester.pumpWidget(_buildSubject(repo, picker));
      await _advanceToStepSpecie(tester, picker);
      await tester.tap(find.byKey(const Key('wizard_species_item_0')));
      await tester.pump();
      await tester.tap(find.byKey(const Key('wizard_next_button')));
      await tester.pump();

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
    await tester.pumpWidget(_buildNavigatorSubject(repo, picker));
    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('wizard_close_button')));
    await tester.pumpAndSettle();

    expect(repo.plantsSync, isEmpty);
  });

  // -------------------------------------------------------------------------
  // Happy path
  // -------------------------------------------------------------------------
  testWidgets('completing the wizard saves the plant to the repository', (
    tester,
  ) async {
    _stubPickerSuccess(picker);
    await tester.pumpWidget(_buildNavigatorSubject(repo, picker));
    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();

    // Step 1 — pick photo from gallery
    await tester.tap(
      find.byKey(const Key('wizard_pick_photo_gallery_button')),
    );
    await tester.pumpAndSettle();
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

    expect(repo.plantsSync, hasLength(1));
    expect(repo.plantsSync.first.species, kSeedSpecies.first);
  });

  testWidgets('typed nickname is persisted instead of generated default', (
    tester,
  ) async {
    _stubPickerSuccess(picker);
    await tester.pumpWidget(_buildNavigatorSubject(repo, picker));
    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();

    await tester.tap(
      find.byKey(const Key('wizard_pick_photo_gallery_button')),
    );
    await tester.pumpAndSettle();
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

    expect(repo.plantsSync, hasLength(1));
    expect(repo.plantsSync.first.nickname, 'Momo');
  });

  testWidgets('completing wizard shows save feedback snackbar', (tester) async {
    _stubPickerSuccess(picker);
    await tester.pumpWidget(_buildNavigatorSubject(repo, picker));
    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();

    await tester.tap(
      find.byKey(const Key('wizard_pick_photo_gallery_button')),
    );
    await tester.pumpAndSettle();
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
