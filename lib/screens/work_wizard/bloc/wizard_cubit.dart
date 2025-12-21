import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:zeimoto/models/plant.dart';
import 'wizard_state.dart';

class WizardCubit extends Cubit<WizardState> {
  WizardCubit() : super(const WizardState());

  void setStep(int step) {
    emit(state.copyWith(currentStep: step));
  }

  void nextStep() {
    if (state.currentStep < 2) {
      emit(state.copyWith(currentStep: state.currentStep + 1));
    }
  }

  void prevStep() {
    if (state.currentStep > 0) {
      emit(state.copyWith(currentStep: state.currentStep - 1));
    }
  }

  void setPlant(Plant plant) {
    // If plant changes, clearing entries is handled by UI confirmation logic calling clearWorkEntries
    emit(state.copyWith(selectedPlant: plant));
  }

  void clearWorkEntries() {
    emit(state.copyWith(workEntries: []));
  }

  void setInitialPhoto(XFile? photo) {
    emit(state.copyWith(initialPhoto: photo));
  }

  void addWorkEntry(WorkEntry entry) {
    final newEntries = List<WorkEntry>.from(state.workEntries)..add(entry);
    emit(state.copyWith(workEntries: newEntries));
  }

  void removeWorkEntry(String id) {
    final newEntries = List<WorkEntry>.from(state.workEntries)
      ..removeWhere((e) => e.id == id);
    emit(state.copyWith(workEntries: newEntries));
  }

  void updateWorkEntry(WorkEntry entry) {
    final index = state.workEntries.indexWhere((e) => e.id == entry.id);
    if (index != -1) {
      final newEntries = List<WorkEntry>.from(state.workEntries);
      newEntries[index] = entry;
      emit(state.copyWith(workEntries: newEntries));
    }
  }

  void setFinalPhoto(XFile? photo) {
    emit(state.copyWith(finalPhoto: photo));
  }

  void reset() {
    emit(const WizardState());
  }
}
