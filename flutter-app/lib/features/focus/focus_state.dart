import '../../domain/plants.dart';

/// All states emitted by [FocusCubit].
sealed class FocusState {
  const FocusState();
}

/// The focus plant is being selected.
final class FocusLoading extends FocusState {
  const FocusLoading();
}

/// A plant has been selected to display.
final class FocusLoaded extends FocusState {
  const FocusLoaded({required this.plant});

  final Plant plant;
}

/// The repository has no plants to display.
final class FocusEmpty extends FocusState {
  const FocusEmpty();
}
