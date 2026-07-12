import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../domain/plants.dart';
import '../features/add_plant/add_plant_wizard.dart';
import '../features/collection/plant_detail_placeholder.dart';
import '../app/zeimoto_app_shell.dart';

// ---------------------------------------------------------------------------
// Route path constants — single source of truth for navigation
// ---------------------------------------------------------------------------

/// Centralised route constants for Zeimoto.
///
/// All navigation calls in the app MUST use these constants instead of
/// hard-coded path strings. This is the **architectural seam** that keeps
/// feature widgets decoupled from each other and from the app shell.
///
/// See ADR-0004 for the routing policy.
abstract final class AppRoutes {
  /// Home — ZeimotoAppShell with the main content.
  static const home = '/';

  /// Add Plant wizard — opens as a full-page dialog route.
  static const addPlant = '/add-plant';

  /// Plant detail — `extra` must be a [Plant] object.
  static const plantDetail = '/plant-detail';
}

// ---------------------------------------------------------------------------
// Router factory
// ---------------------------------------------------------------------------

/// Creates and returns the application [GoRouter].
///
/// The repository must be provided so that routes which need to create
/// BLoC providers (e.g. the wizard) can read it from context.
///
/// Callers (typically [ZeimotoApp.build]) must wrap this router inside a
/// [RepositoryProvider] so the ambient repository is available to all routes.
GoRouter buildAppRouter() {
  return GoRouter(
    initialLocation: AppRoutes.home,
    routes: [
      GoRoute(
        path: AppRoutes.home,
        builder: (context, state) => const ZeimotoAppShell(),
        routes: [
          GoRoute(
            path: 'add-plant',
            pageBuilder: (context, state) => const MaterialPage(
              fullscreenDialog: true,
              child: AddPlantWizard(),
            ),
          ),
          GoRoute(
            path: 'plant-detail',
            pageBuilder: (context, state) {
              final plant = state.extra! as Plant;
              return MaterialPage(child: PlantDetailPlaceholder(plant: plant));
            },
          ),
        ],
      ),
    ],
  );
}
