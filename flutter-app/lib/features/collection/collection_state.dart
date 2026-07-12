import 'package:zeimoto/domain/plants.dart';

/// All states emitted by [CollectionCubit].
sealed class CollectionState {
  const CollectionState();
}

/// The collection is being loaded from the repository.
final class CollectionLoading extends CollectionState {
  const CollectionLoading();
}

/// The collection has been loaded with plants.
final class CollectionLoaded extends CollectionState {
  const CollectionLoaded({required this.plants});

  final List<Plant> plants;
}

/// The repository is empty (no plants to display).
final class CollectionEmpty extends CollectionState {
  const CollectionEmpty();
}
