import 'package:equatable/equatable.dart';
import 'package:image_picker/image_picker.dart';
import 'package:zeimoto/models/enums.dart';
import 'package:zeimoto/models/plant.dart';

class WorkEntry extends Equatable {
  final String id;
  final InterventionType type;
  final String notes;
  final List<XFile> detailPhotos;

  const WorkEntry({
    required this.id,
    required this.type,
    this.notes = '',
    this.detailPhotos = const [],
  });

  WorkEntry copyWith({
    String? id,
    InterventionType? type,
    String? notes,
    List<XFile>? detailPhotos,
  }) {
    return WorkEntry(
      id: id ?? this.id,
      type: type ?? this.type,
      notes: notes ?? this.notes,
      detailPhotos: detailPhotos ?? this.detailPhotos,
    );
  }

  @override
  List<Object?> get props => [id, type, notes, detailPhotos];
}

class WizardState extends Equatable {
  final int currentStep;
  final Plant? selectedPlant;
  final XFile? initialPhoto;
  final List<WorkEntry> workEntries;
  final XFile? finalPhoto;

  const WizardState({
    this.currentStep = 0,
    this.selectedPlant,
    this.initialPhoto,
    this.workEntries = const [],
    this.finalPhoto,
  });

  WizardState copyWith({
    int? currentStep,
    Plant? selectedPlant,
    XFile? initialPhoto,
    List<WorkEntry>? workEntries,
    XFile? finalPhoto,
  }) {
    return WizardState(
      currentStep: currentStep ?? this.currentStep,
      selectedPlant: selectedPlant ?? this.selectedPlant,
      initialPhoto: initialPhoto ?? this.initialPhoto,
      workEntries: workEntries ?? this.workEntries,
      finalPhoto: finalPhoto ?? this.finalPhoto,
    );
  }

  @override
  List<Object?> get props => [
    currentStep,
    selectedPlant,
    initialPhoto,
    workEntries,
    finalPhoto,
  ];
}
