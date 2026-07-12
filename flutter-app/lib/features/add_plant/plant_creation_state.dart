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
    this.selectedPhoto,
    this.species = '',
    this.nickname = '',
  });

  final WizardStep step;
  final PlaceholderPhoto? selectedPhoto;
  final String species;
  final String nickname;

  /// Whether the primary action button ("Avanti" or "Salva") should be active
  /// for the current step.
  bool get canAdvance => switch (step) {
    WizardStep.foto => selectedPhoto != null,
    WizardStep.specie => species.trim().isNotEmpty,
    WizardStep.nickname => true,
  };

  PlantCreationCollecting copyWith({
    WizardStep? step,
    PlaceholderPhoto? selectedPhoto,
    bool clearPhoto = false,
    String? species,
    String? nickname,
  }) => PlantCreationCollecting(
    step: step ?? this.step,
    selectedPhoto: clearPhoto ? null : (selectedPhoto ?? this.selectedPhoto),
    species: species ?? this.species,
    nickname: nickname ?? this.nickname,
  );
}

/// The plant was created and persisted successfully.
final class PlantCreationSaved extends PlantCreationState {
  const PlantCreationSaved(this.plant);
  final Plant plant;
}
