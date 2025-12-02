import 'dart:convert';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';
import 'package:zeimoto/models/enums.dart';
import 'package:zeimoto/models/photo.dart';
import 'package:hive/hive.dart';

class PhotoService {
  final ImagePicker _picker = ImagePicker();
  final _uuid = const Uuid();

  Future<PhotoEntry?> pickAndSave(String plantId, {bool fromCamera = false}) async {
    final XFile? file = await (fromCamera
        ? _picker.pickImage(source: ImageSource.camera)
        : _picker.pickImage(source: ImageSource.gallery));
    if (file == null) return null;
    final id = _uuid.v4();
    final bytes = await file.readAsBytes();
    final mime = _mimeFromName(file.name);
    final dataUrl = 'data:$mime;base64,${base64Encode(bytes)}';

    final date = DateTime.now();
    final season = _seasonForMonth(date.month);

    final entry = PhotoEntry(
      id: id,
      plantId: plantId,
      path: dataUrl,
      dateTaken: date,
      season: season,
    );

    final box = Hive.box('photos');
    await box.put(id, entry);
    return entry;
  }

  String _mimeFromName(String name) {
    final lower = name.toLowerCase();
    if (lower.endsWith('.png')) return 'image/png';
    if (lower.endsWith('.webp')) return 'image/webp';
    return 'image/jpeg';
  }

  Season _seasonForMonth(int month) {
    if (month == 12 || month <= 2) return Season.winter;
    if (month <= 5) return Season.spring;
    if (month <= 8) return Season.summer;
    return Season.autumn;
  }
}
