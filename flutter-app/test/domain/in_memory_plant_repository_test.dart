import 'package:flutter_test/flutter_test.dart';
import 'package:zeimoto/domain/plants.dart';

void main() {
  group('InMemoryPlantRepository', () {
    test('exposes seeded plants ordered by descending createdAt', () async {
      final repository = InMemoryPlantRepository();
      final plants = await repository.getAll();

      expect(plants, isNotEmpty);
      expect(_isSortedByMostRecentFirst(plants), isTrue);
    });

    test('keeps the newest added plant at the front of the list', () async {
      final repository = InMemoryPlantRepository();

      final addedPlant = await repository.add(
        species: 'Acer palmatum',
        nickname: 'Momiji',
        sourcePhotoPath: '/fake/momiji.jpg',
      );

      final plants = await repository.getAll();
      expect(plants.first, same(addedPlant));
      expect(_isSortedByMostRecentFirst(plants), isTrue);
    });
  });
}

bool _isSortedByMostRecentFirst(List<Plant> plants) {
  for (var index = 0; index < plants.length - 1; index++) {
    if (plants[index].createdAt.isBefore(plants[index + 1].createdAt)) {
      return false;
    }
  }

  return true;
}
