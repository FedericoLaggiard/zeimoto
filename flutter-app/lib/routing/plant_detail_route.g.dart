// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'plant_detail_route.dart';

// **************************************************************************
// GoRouterGenerator
// **************************************************************************

List<RouteBase> get $appRoutes => [$plantDetailRoute];

RouteBase get $plantDetailRoute => GoRouteData.$route(
  path: '/plant-detail',
  factory: $PlantDetailRoute._fromState,
);

mixin $PlantDetailRoute on GoRouteData {
  static PlantDetailRoute _fromState(GoRouterState state) =>
      PlantDetailRoute(state.extra as Plant);

  PlantDetailRoute get _self => this as PlantDetailRoute;

  @override
  String get location => GoRouteData.$location('/plant-detail');

  @override
  void go(BuildContext context) => context.go(location, extra: _self.$extra);

  @override
  Future<T?> push<T>(BuildContext context) =>
      context.push<T>(location, extra: _self.$extra);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location, extra: _self.$extra);

  @override
  void replace(BuildContext context) =>
      context.replace(location, extra: _self.$extra);
}
