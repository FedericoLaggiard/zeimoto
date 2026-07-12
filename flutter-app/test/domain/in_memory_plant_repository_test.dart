import 'package:flutter_test/flutter_test.dart';
import 'package:zeimoto/domain/plants.dart';

void main() {
  group('InMemoryPlantRepository', () {
    test('exposes seeded plants ordered by descending createdAt', () {
      final repository = InMemoryPlantRepository();

      expect(repository.plants, isNotEmpty);
      expect(_isSortedByMostRecentFirst(repository.plants), isTrue);
    });

    test('keeps the newest added plant at the front of the list', () {
      final repository = InMemoryPlantRepository();

      final addedPlant = repository.add(
        species: 'Acer palmatum',
        nickname: 'Momiji',
        cover: PlaceholderPhoto.random(99),
      );

      expect(repository.plants.first, same(addedPlant));
      expect(_isSortedByMostRecentFirst(repository.plants), isTrue);
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
