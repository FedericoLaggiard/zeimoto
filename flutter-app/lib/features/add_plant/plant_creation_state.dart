import 'package:zeimoto/domain/plants.dart';

/// The three steps of the plant creation wizard, in order.
enum WizardStep { foto, specie, nickname }

/// All states emitted by [PlantCreationCubit].
sealed class PlantCreationState {
  const PlantCreationState();
}

/// The wizard is still collecting input from the user.
final class PlantCreationCollecting extends PlantCreationState {
  const PlantCreationCollecting({
    this.step = WizardStep.foto,
    this.selectedPhotoPath,
    this.species = '',
    this.nickname = '',
  });

  final WizardStep step;

  /// Absolute path of the selected cover photo, or null when none picked yet.
  final String? selectedPhotoPath;

  final String species;
  final String nickname;

  /// Whether the primary action button ("Avanti" or "Salva") should be active
  /// for the current step.
  bool get canAdvance => switch (step) {
    WizardStep.foto => selectedPhotoPath != null,
    WizardStep.specie => species.trim().isNotEmpty,
    WizardStep.nickname => true,
  };

  PlantCreationCollecting copyWith({
    WizardStep? step,
    String? selectedPhotoPath,
    bool clearPhoto = false,
    String? species,
    String? nickname,
  }) => PlantCreationCollecting(
    step: step ?? this.step,
    selectedPhotoPath:
        clearPhoto ? null : (selectedPhotoPath ?? this.selectedPhotoPath),
    species: species ?? this.species,
    nickname: nickname ?? this.nickname,
  );
}

/// The plant was created and persisted successfully.
final class PlantCreationSaved extends PlantCreationState {
  const PlantCreationSaved(this.plant);
  final Plant plant;
}
