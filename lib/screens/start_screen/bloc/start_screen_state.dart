import 'package:equatable/equatable.dart';

class StartScreenState extends Equatable {
  final List<int> order;
  final bool reorderMode;

  const StartScreenState({
    this.order = const [0, 1, 2, 3, 4, 5, 6, 7],
    this.reorderMode = false,
  });

  StartScreenState copyWith({List<int>? order, bool? reorderMode}) {
    return StartScreenState(
      order: order ?? this.order,
      reorderMode: reorderMode ?? this.reorderMode,
    );
  }

  @override
  List<Object> get props => [order, reorderMode];
}
