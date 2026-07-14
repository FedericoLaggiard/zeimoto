import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import '../../domain/plants.dart';
import 'plant_creation_state.dart';

/// Cubit that drives the 3-step plant creation wizard.
///
/// Owns all business logic: photo selection, species validation, nickname
/// normalisation, and persistence via [PlantRepository].
///
/// Navigation (popping the route) is handled by the widget listening to
/// [PlantCreationSaved]; this cubit is navigation-agnostic.
///
/// No user-supplied data is ever included in error messages or logs.
class PlantCreationCubit extends Cubit<PlantCreationState> {
  PlantCreationCubit(this._repository, {ImagePicker? imagePicker})
    : _picker = imagePicker ?? ImagePicker(),
      super(const PlantCreationCollecting());

  final PlantRepository _repository;
  final ImagePicker _picker;

  static const _kNicknameMaxLength = 100;

  // ---------------------------------------------------------------------------
  // User actions
  // ---------------------------------------------------------------------------

  /// Opens the native image picker for [source] and emits the selected path.
  ///
  /// No-op if the user dismisses the picker without selecting an image.
  Future<void> pickPhoto(ImageSource source) async {
    final file = await _picker.pickImage(
      source: source,
      imageQuality: 80,
      maxWidth: 1600,
      maxHeight: 1600,
    );
    if (file == null) return;
    selectPhoto(file.path);
  }

  /// Directly sets the selected photo path — used internally and in tests.
  void selectPhoto(String path) {
    emit(_collecting.copyWith(selectedPhotoPath: path));
  }

  void changeSpecies(String value) {
    final current = _collecting;
    emit(current.copyWith(species: value));
  }

  void changeNickname(String value) {
    final current = _collecting;
    emit(current.copyWith(nickname: value));
  }

  /// Advances to the next step. No-op when [PlantCreationCollecting.canAdvance]
  /// is false or the wizard is already on the last step.
  void advance() {
    final current = _collecting;
    if (!current.canAdvance) return;
    final next = switch (current.step) {
      WizardStep.foto => WizardStep.specie,
      WizardStep.specie => WizardStep.nickname,
      WizardStep.nickname => WizardStep.nickname,
    };
    if (next == current.step) return;
    emit(current.copyWith(step: next));
  }

  /// Validates inputs, persists the plant, and emits [PlantCreationSaved].
  ///
  /// Throws [ArgumentError] if the nickname fails validation.
  /// Guards silently if called when cover or species are missing (cannot happen
  /// via the normal UI flow, but defensive programming applies at seam entry).
  Future<void> save() async {
    final current = _collecting;
    final photoPath = current.selectedPhotoPath;
    if (photoPath == null) return;
    if (current.species.trim().isEmpty) return;

    final normalisedNickname = _normaliseNickname(current.nickname);

    final plant = await _repository.add(
      species: current.species.trim(),
      nickname: normalisedNickname,
      sourcePhotoPath: photoPath,
    );

    emit(PlantCreationSaved(plant));
  }

  // ---------------------------------------------------------------------------
  // Private helpers
  // ---------------------------------------------------------------------------

  PlantCreationCollecting get _collecting => state as PlantCreationCollecting;

  /// Returns [null] when [raw] is absent or blank so the repository generates
  /// the default nickname. Non-blank values are trimmed, then validated.
  /// Error messages never include the raw value to avoid leaking user input.
  static String? _normaliseNickname(String raw) {
    if (raw.trim().isEmpty) return null;
    final trimmed = raw.trim();
    if (trimmed.length > _kNicknameMaxLength) {
      throw ArgumentError(
        'nickname must be at most $_kNicknameMaxLength characters',
      );
    }
    if (trimmed.contains(RegExp(r'[\x00-\x1F\x7F]'))) {
      throw ArgumentError('nickname must not contain control characters');
    }
    return trimmed;
  }
}
