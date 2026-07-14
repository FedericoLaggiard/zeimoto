import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/plants.dart';
import 'collection_state.dart';

/// Cubit that manages the collection section state.
///
/// Loads plants from [PlantRepository] on creation, sorts them by
/// [Plant.createdAt] descending (most recent first), and re-loads
/// automatically whenever the repository emits a [PlantRepository.changes]
/// event (e.g. after a plant is created via the wizard).
///
/// Emits:
/// - [CollectionLoading] initially
/// - [CollectionLoaded] if plants exist
/// - [CollectionEmpty] if repository is empty
class CollectionCubit extends Cubit<CollectionState> {
  CollectionCubit(this._repository) : super(const CollectionLoading()) {
    _loadPlants();
    _subscription = _repository.changes.listen((_) => _loadPlants());
  }

  final PlantRepository _repository;
  late final StreamSubscription<void> _subscription;

  Future<void> _loadPlants() async {
    final plants = List<Plant>.of(await _repository.getAll())
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));

    if (plants.isEmpty) {
      emit(const CollectionEmpty());
    } else {
      emit(CollectionLoaded(plants: plants));
    }
  }

  @override
  Future<void> close() {
    _subscription.cancel();
    return super.close();
  }
}
