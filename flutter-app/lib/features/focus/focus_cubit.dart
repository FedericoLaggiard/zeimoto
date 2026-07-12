import 'dart:math';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/plants.dart';
import 'focus_state.dart';

/// Cubit that selects a random plant from [PlantRepository] once and holds it
/// for the lifetime of the home session.
///
/// The random selection is performed in the constructor and never changes.
/// The [pickIndex] parameter is injectable for deterministic testing; in
/// production the default [Random.nextInt] is used.
///
/// Emits:
/// - [FocusLoading] initially
/// - [FocusLoaded] with the randomly selected plant
/// - [FocusEmpty] if the repository has no plants
class FocusCubit extends Cubit<FocusState> {
  FocusCubit(this._repository, {int Function(int max)? pickIndex})
    : _pickIndex = pickIndex ?? Random().nextInt,
      super(const FocusLoading()) {
    _selectPlant();
  }

  final PlantRepository _repository;
  final int Function(int max) _pickIndex;

  void _selectPlant() {
    final plants = _repository.plants;
    if (plants.isEmpty) {
      emit(const FocusEmpty());
      return;
    }
    final index = _pickIndex(plants.length);
    emit(FocusLoaded(plant: plants[index]));
  }
}
