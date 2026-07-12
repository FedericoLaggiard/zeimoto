import 'package:flutter_test/flutter_test.dart';
import 'package:zeimoto/domain/plants.dart';
import 'package:zeimoto/routing/plant_detail_route.dart';
import 'package:zeimoto/routing/routes.dart';

void main() {
  group('Typed routes', () {
    test('PlantDetailRoute uses canonical plant-detail path', () {
      final plant = Plant(
        id: 'p-1',
        species: 'Acer palmatum',
        nickname: 'acero_01',
        cover: PlaceholderPhoto.palette.first,
        createdAt: DateTime(2026, 1, 1),
      );

      final route = PlantDetailRoute(plant);

      expect(route.location, AppRoutes.plantDetail);
    });
  });
}
