import 'package:flutter_bloc/flutter_bloc.dart';
import 'start_screen_state.dart';

class StartScreenCubit extends Cubit<StartScreenState> {
  StartScreenCubit() : super(const StartScreenState());

  void reorderStarted() {
    emit(state.copyWith(reorderMode: true));
  }

  void reorderFinished() {
    emit(state.copyWith(reorderMode: false));
  }

  void itemReordered(int itemId, int targetIndex) {
    final currentOrder = List<int>.from(state.order);
    final fromIndex = currentOrder.indexOf(itemId);
    if (fromIndex == -1) return;
    
    final val = currentOrder.removeAt(fromIndex);
    currentOrder.insert(targetIndex, val);

    emit(state.copyWith(order: currentOrder));
  }
}
