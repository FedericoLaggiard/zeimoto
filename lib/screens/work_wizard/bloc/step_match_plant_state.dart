import 'package:camera/camera.dart';
import 'package:equatable/equatable.dart';
import 'package:zeimoto/models/plant.dart';

class StepMatchPlantState extends Equatable {
  final List<Plant> plants;
  final bool isLoadingPlants;
  final CameraController? cameraController;
  final bool isCameraInitialized;

  const StepMatchPlantState({
    this.plants = const [],
    this.isLoadingPlants = true,
    this.cameraController,
    this.isCameraInitialized = false,
  });

  StepMatchPlantState copyWith({
    List<Plant>? plants,
    bool? isLoadingPlants,
    CameraController? cameraController,
    bool? isCameraInitialized,
  }) {
    return StepMatchPlantState(
      plants: plants ?? this.plants,
      isLoadingPlants: isLoadingPlants ?? this.isLoadingPlants,
      cameraController: cameraController ?? this.cameraController,
      isCameraInitialized: isCameraInitialized ?? this.isCameraInitialized,
    );
  }

  @override
  List<Object?> get props => [
        plants,
        isLoadingPlants,
        cameraController,
        isCameraInitialized,
      ];
}
