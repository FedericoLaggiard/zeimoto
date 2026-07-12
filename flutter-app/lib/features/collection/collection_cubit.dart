import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/plants.dart';
import 'collection_state.dart';

/// Cubit that manages the collection section state.
///
/// Loads plants from [PlantRepository] on creation and emits:
/// - [CollectionLoading] initially
/// - [CollectionLoaded] if plants exist (already sorted by repository)
/// - [CollectionEmpty] if repository is empty
class CollectionCubit extends Cubit<CollectionState> {
  CollectionCubit(this._repository) : super(const CollectionLoading()) {
    _loadPlants();
  }

  final PlantRepository _repository;

  /// Load plants from repository and emit appropriate state
  void _loadPlants() {
    final plants = _repository.plants;

    if (plants.isEmpty) {
      emit(const CollectionEmpty());
    } else {
      emit(CollectionLoaded(plants: plants));
    }
  }
}
