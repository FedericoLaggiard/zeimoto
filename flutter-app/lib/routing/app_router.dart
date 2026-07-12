import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../domain/plants.dart';
import '../features/add_plant/add_plant_wizard.dart';
import '../features/collection/plant_detail_placeholder.dart';
import '../app/zeimoto_app_shell.dart';
import 'routes.dart';

export 'routes.dart';

// ---------------------------------------------------------------------------
// Router factory
// ---------------------------------------------------------------------------

/// Creates and returns the application [GoRouter].
///
/// All routes reference [AppRoutes] constants — never raw strings.
/// Each [GoRoute] carries an inline comment describing the screen it owns
/// and any contract it expects (e.g. required `extra` type).
///
/// Callers must wrap this router inside a [RepositoryProvider] so that
/// every route can access the ambient [PlantRepository] from context.
GoRouter buildAppRouter() {
  return GoRouter(
    initialLocation: AppRoutes.home,
    routes: [
      // ── Home ────────────────────────────────────────────────────────────
      // Root shell: ZeimotoAppShell with scrollable content sections and
      // the pinned agent bar at the bottom.
      GoRoute(
        path: AppRoutes.home,
        builder: (context, state) => const ZeimotoAppShell(),
      ),

      // ── Add Plant wizard ─────────────────────────────────────────────────
      // Full-page dialog (fullscreenDialog: true) for the 3-step plant
      // creation flow.  Opens from the FAB in ZeimotoAppShell.
      // No `extra` required.
      GoRoute(
        path: AppRoutes.addPlant,
        pageBuilder: (context, state) =>
            const MaterialPage(fullscreenDialog: true, child: AddPlantWizard()),
      ),

      // ── Plant detail ─────────────────────────────────────────────────────
      // Detail view for a single plant.
      // Contract: `state.extra` must be a [Plant] object.
      // The redirect guard below ensures a missing or wrong extra redirects to
      // home instead of crashing with a force-unwrap error.
      GoRoute(
        path: AppRoutes.plantDetail,
        redirect: (context, state) =>
            state.extra is Plant ? null : AppRoutes.home,
        pageBuilder: (context, state) {
          // Safe: redirect guard above guarantees extra is a Plant.
          final plant = state.extra! as Plant;
          return MaterialPage(child: PlantDetailPlaceholder(plant: plant));
        },
      ),
    ],
  );
}
