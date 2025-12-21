import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:zeimoto/models/enums.dart';
import 'package:zeimoto/models/plant.dart';

class WorkEntry {
  String id;
  InterventionType type;
  String notes;
  List<XFile> detailPhotos;

  WorkEntry({
    required this.id,
    required this.type,
    this.notes = '',
    this.detailPhotos = const [],
  });
}

class WizardState extends ChangeNotifier {
  int _currentStep = 0;
  int get currentStep => _currentStep;

  Plant? _selectedPlant;
  Plant? get selectedPlant => _selectedPlant;

  XFile? _initialPhoto;
  XFile? get initialPhoto => _initialPhoto;

  final List<WorkEntry> _workEntries = [];
  List<WorkEntry> get workEntries => List.unmodifiable(_workEntries);

  XFile? _finalPhoto;
  XFile? get finalPhoto => _finalPhoto;

  void setStep(int step) {
    _currentStep = step;
    notifyListeners();
  }

  void nextStep() {
    if (_currentStep < 2) {
      _currentStep++;
      notifyListeners();
    }
  }

  void prevStep() {
    if (_currentStep > 0) {
      _currentStep--;
      notifyListeners();
    }
  }

  void setPlant(Plant plant) {
    if (_selectedPlant != null && _selectedPlant!.id != plant.id) {
      // If plant changes, we should probably clear entries, but the UI handles the confirmation.
      // Here we just set it. The UI logic calling this should handle the clearing if confirmed.
    }
    _selectedPlant = plant;
    notifyListeners();
  }

  void clearWorkEntries() {
    _workEntries.clear();
    notifyListeners();
  }

  void setInitialPhoto(XFile? photo) {
    _initialPhoto = photo;
    notifyListeners();
  }

  void addWorkEntry(WorkEntry entry) {
    _workEntries.add(entry);
    notifyListeners();
  }

  void removeWorkEntry(String id) {
    _workEntries.removeWhere((e) => e.id == id);
    notifyListeners();
  }

  void updateWorkEntry(WorkEntry entry) {
    final index = _workEntries.indexWhere((e) => e.id == entry.id);
    if (index != -1) {
      _workEntries[index] = entry;
      notifyListeners();
    }
  }

  void setFinalPhoto(XFile? photo) {
    _finalPhoto = photo;
    notifyListeners();
  }

  void reset() {
    _currentStep = 0;
    _selectedPlant = null;
    _initialPhoto = null;
    _workEntries.clear();
    _finalPhoto = null;
    notifyListeners();
  }
}
