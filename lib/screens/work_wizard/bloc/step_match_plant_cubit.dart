import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:zeimoto/services/plant_repository.dart';
import 'step_match_plant_state.dart';

class StepMatchPlantCubit extends Cubit<StepMatchPlantState> {
  final PlantRepository _plantRepo = PlantRepository();

  StepMatchPlantCubit() : super(const StepMatchPlantState()) {
    _initCamera();
    _loadPlants();
  }

  Future<void> _initCamera() async {
    try {
      final cameras = await availableCameras();
      if (cameras.isNotEmpty) {
        final controller = CameraController(
          cameras[0],
          ResolutionPreset.medium,
          enableAudio: false,
        );
        await controller.initialize();
        emit(
          state.copyWith(
            cameraController: controller,
            isCameraInitialized: true,
          ),
        );
      }
    } catch (e) {
      debugPrint('Camera init error: $e');
      // Even if camera fails, we might want to update state to stop loading or show error
      emit(state.copyWith(isCameraInitialized: false));
    }
  }

  Future<void> _loadPlants() async {
    emit(state.copyWith(isLoadingPlants: true));
    try {
      // Simulate async if needed, or just fetch
      final plants = _plantRepo.all().toList();
      emit(state.copyWith(plants: plants, isLoadingPlants: false));
    } catch (e) {
      debugPrint('Error loading plants: $e');
      emit(state.copyWith(isLoadingPlants: false));
    }
  }

  Future<XFile?> takePicture() async {
    final controller = state.cameraController;
    if (controller == null || !controller.value.isInitialized) {
      return pickFromGallery();
    }

    try {
      final image = await controller.takePicture();
      return image;
    } catch (e) {
      debugPrint('Error taking picture: $e');
      return pickFromGallery();
    }
  }

  Future<XFile?> pickFromGallery() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    return image;
  }

  @override
  Future<void> close() {
    state.cameraController?.dispose();
    return super.close();
  }
}
