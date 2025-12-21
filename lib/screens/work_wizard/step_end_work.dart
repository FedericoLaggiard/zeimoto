import 'dart:convert';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:go_router/go_router.dart';
import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';
import 'package:zeimoto/models/enums.dart';
import 'package:zeimoto/models/photo.dart';
import 'package:zeimoto/screens/work_wizard/bloc/wizard_cubit.dart';
import 'package:zeimoto/screens/work_wizard/bloc/wizard_state.dart';
import 'package:zeimoto/services/intervention_repository.dart';

class StepEndWork extends StatefulWidget {
  const StepEndWork({super.key});

  @override
  State<StepEndWork> createState() => _StepEndWorkState();
}

class _StepEndWorkState extends State<StepEndWork> {
  CameraController? _cameraController;
  final InterventionRepository _interventionRepo = InterventionRepository();

  @override
  void initState() {
    super.initState();
    _initCamera();
  }

  Future<void> _initCamera() async {
    try {
      final cameras = await availableCameras();
      if (cameras.isNotEmpty) {
        _cameraController = CameraController(
          cameras[0],
          ResolutionPreset.medium,
          enableAudio: false,
        );
        await _cameraController!.initialize();
      }
    } catch (e) {
      debugPrint('Camera init error: $e');
    }
    // Update state to ensure UI reflects camera status (even if failed)
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    super.dispose();
  }

  Future<void> _takePicture() async {
    if (_cameraController == null || !_cameraController!.value.isInitialized) {
      _pickFromGallery();
      return;
    }
    try {
      final image = await _cameraController!.takePicture();
      if (mounted) {
        context.read<WizardCubit>().setFinalPhoto(image);
      }
    } catch (e) {
      debugPrint('Error taking picture: $e');
      _pickFromGallery();
    }
  }

  Future<void> _pickFromGallery() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null && mounted) {
      context.read<WizardCubit>().setFinalPhoto(image);
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<WizardCubit>().state;
    final size = MediaQuery.of(context).size;

    return Column(
      children: [
        // Camera Preview
        SizedBox(
          height: size.height * 0.4,
          width: double.infinity,
          child: Stack(
            fit: StackFit.expand,
            children: [
              if (_cameraController != null &&
                  _cameraController!.value.isInitialized)
                CameraPreview(_cameraController!)
              else
                Container(
                  color: Colors.black,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.camera_alt_outlined,
                          color: Colors.white54,
                          size: 48,
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Camera non disponibile',
                          style: TextStyle(color: Colors.white54),
                        ),
                        TextButton.icon(
                          onPressed: _pickFromGallery,
                          icon: const Icon(Icons.photo_library),
                          label: const Text('Scegli da Galleria'),
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

              if (state.finalPhoto != null)
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    color: Colors.black54,
                    child: const Icon(Icons.check_circle, color: Colors.green),
                  ),
                ),

              Positioned(
                bottom: 16,
                left: 0,
                right: 0,
                child: Center(
                  child: ElevatedButton(
                    onPressed: _takePicture,
                    child: const Icon(Icons.camera_alt),
                  ),
                ),
              ),
            ],
          ),
        ),

        // Summary
        Expanded(
          child: Container(
            color: Colors.white,
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Riepilogo Lavori',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Expanded(
                  child: ListView.builder(
                    itemCount: state.workEntries.length,
                    itemBuilder: (context, index) {
                      final entry = state.workEntries[index];
                      // Map InterventionType to label
                      final Map<InterventionType, String> typeLabels = {
                        InterventionType.pruning: 'Potatura',
                        InterventionType.repotting: 'Rinvaso',
                        InterventionType.fertilization: 'Concimazione',
                        InterventionType.phytosanitary: 'Trattamento',
                        InterventionType.wiring: 'Legatura',
                        InterventionType.cleaning: 'Pulizia',
                        InterventionType.deadwood: 'Legna secca',
                      };
                      return ListTile(
                        leading: const Icon(Icons.check),
                        title: Text(
                          typeLabels[entry.type] ?? entry.type.toString(),
                        ),
                        subtitle: Text(entry.notes),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),

        // Bottom Bar
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(
                onPressed: () => context.read<WizardCubit>().prevStep(),
                child: const Text('INDIETRO'),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                ),
                onPressed: () => _confirmFinish(context, state),
                child: const Text('CONCLUDI'),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _confirmFinish(BuildContext context, WizardState state) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Concludi Lavoro'),
        content: const Text('Vuoi archiviare il lavoro e tornare alla home?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Annulla'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(ctx);
              await _saveAndFinish(context, state);
            },
            child: const Text('Conferma'),
          ),
        ],
      ),
    );
  }

  Future<void> _saveAndFinish(BuildContext context, WizardState state) async {
    // Save everything
    final plantId = state.selectedPlant!.id;

    // Save interventions
    for (final entry in state.workEntries) {
      String? mainPhotoId;

      // Save detail photos
      for (final photo in entry.detailPhotos) {
        final savedId = await _savePhoto(photo, plantId);
        mainPhotoId ??= savedId;
      }

      await _interventionRepo.add(
        plantId: plantId,
        type: entry.type,
        description: entry.notes,
        photoId: mainPhotoId,
      );
    }

    // Save initial and final photos to gallery (PhotoService logic)
    if (state.initialPhoto != null) {
      await _savePhoto(state.initialPhoto!, plantId);
    }
    if (state.finalPhoto != null) {
      await _savePhoto(state.finalPhoto!, plantId);
    }

    if (context.mounted) {
      context.go('/');
    }
  }

  Future<String> _savePhoto(XFile file, String plantId) async {
    final bytes = await file.readAsBytes();
    final mime = file.name.toLowerCase().endsWith('.png')
        ? 'image/png'
        : 'image/jpeg';
    final dataUrl = 'data:$mime;base64,${base64Encode(bytes)}';
    final id = const Uuid().v4();

    final date = DateTime.now();
    Season season = Season.spring; // Simplification
    final m = date.month;
    if (m == 12 || m <= 2) {
      season = Season.winter;
    } else if (m <= 5) {
      season = Season.spring;
    } else if (m <= 8) {
      season = Season.summer;
    } else {
      season = Season.autumn;
    }

    final entry = PhotoEntry(
      id: id,
      plantId: plantId,
      path: dataUrl,
      dateTaken: date,
      season: season,
    );

    final box = Hive.box('photos');
    await box.put(id, entry);
    return id;
  }
}
