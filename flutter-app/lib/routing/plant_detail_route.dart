import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../domain/plants.dart';
import '../features/collection/plant_detail_placeholder.dart';
import 'routes.dart';

part 'plant_detail_route.g.dart';

@TypedGoRoute<PlantDetailRoute>(path: AppRoutes.plantDetail)
class PlantDetailRoute extends GoRouteData with $PlantDetailRoute {
  const PlantDetailRoute(this.$extra);

  final Plant $extra;

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return PlantDetailPlaceholder(plant: $extra);
  }
}
