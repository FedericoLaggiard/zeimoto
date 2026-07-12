# Routing

The routing layer (`lib/routing/`) is the **single source of truth** for all navigation in the application. No widget may reference another screen directly — it must use go_router APIs via `AppRoutes` constants or typed wrappers (`GoRouteData`) defined in the routing layer.

See [ADR-0004](../adr/0004-routing-go-router.md) for binding rules and the rationale behind the choice.

---

## File structure

```
lib/routing/
├── routes.dart       # AppRoutes — path constants (import this in widgets)
├── app_router.dart   # buildAppRouter() — GoRouter factory (import this in main.dart)
│                     # re-exports routes.dart
└── plant_detail_route.dart   # typed route (GoRouteData) for /plant-detail
```

Code that only needs the constants (e.g. widgets calling `context.push`) imports **`routes.dart`**.
Code that navigates to routes with required payload can import typed wrappers from `lib/routing/` (e.g. `PlantDetailRoute`).
Code that assembles the app (e.g. `main.dart`) imports **`app_router.dart`**.

---

## Path constants (`AppRoutes`)

Defined in `lib/routing/routes.dart`:

| Constant | Path | Description |
|----------|------|-------------|
| `AppRoutes.home` | `/` | Main shell — `Home` |
| `AppRoutes.addPlant` | `/add-plant` | Plant creation wizard (fullscreen dialog) |
| `AppRoutes.plantDetail` | `/plant-detail` | Single plant detail |

To add a new route: declare the constant in `routes.dart`, then add the matching `GoRoute` in `app_router.dart`. No other file needs to change.

---

## Route map

```mermaid
graph LR
    HOME[/ home] -->|context.push addPlant| WIZ[/add-plant\nAddPlantWizard\nfullscreenDialog]
  HOME -->|PlantDetailRoute(plant).push\ntyped extra: Plant| DET[/plant-detail\nPlantDetailPlaceholder]
    WIZ -->|context.pop\non save or close| HOME
    DET -->|context.pop| HOME
```

---

## Router factory (`buildAppRouter`)

Defined in `lib/routing/app_router.dart`. Returns a `GoRouter` with manual routes for shell and wizard, plus generated typed routes aggregated by `go_router_builder`:

```dart
GoRouter buildAppRouter() {
  return GoRouter(
    initialLocation: AppRoutes.home,
    routes: [
      // Home shell
      GoRoute(path: AppRoutes.home,        builder: ...),
      // Add-plant wizard (fullscreen dialog, no extra)
      GoRoute(path: AppRoutes.addPlant,    pageBuilder: ...),
      // Generated typed routes (e.g. PlantDetailRoute)
      ...$appRoutes,
    ],
  );
}
```

The `GoRouter` is created inside `_ZeimotoAppState` (a `StatefulWidget`) so the instance survives widget rebuilds.

---

## How to navigate

### Push a screen

```dart
// From any widget with a BuildContext
context.push(AppRoutes.addPlant);

// For required payload routes: prefer typed route wrappers
PlantDetailRoute(plant).push(context);
```

Rule of thumb:
- Use `context.push(AppRoutes.<name>)` for routes without required payload.
- Use typed wrappers (`GoRouteData`) for routes with required payload so the contract is checked at compile time.

### Go back

```dart
context.pop();
```

### ❌ Forbidden patterns (ADR-0004)

```dart
// DO NOT use Navigator directly with an explicit widget
Navigator.of(context).push(MaterialPageRoute(builder: (_) => AddPlantWizard()));

// DO NOT use string literals
context.push('/add-plant');

// DO NOT import AddPlantWizard in another widget to navigate to it
import '../features/add_plant/add_plant_wizard.dart'; // ← ADR-0001 violation
```

---

## Route contracts

| Route | `extra` | Notes |
|-------|---------|-------|
| `AppRoutes.home` | — | No extra |
| `AppRoutes.addPlant` | — | No extra; wizard reads repository from ambient context |
| `AppRoutes.plantDetail` | `Plant` (required) | Contract exposed through `PlantDetailRoute(plant)`; generated parser uses `state.extra as Plant`. Not serialisable — switch to ID when persistence is introduced |

---

## Integration in `main.dart`

```dart
class _ZeimotoAppState extends State<ZeimotoApp> {
  late final _router = buildAppRouter();   // created once

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider<PlantRepository>(
      create: (_) => InMemoryPlantRepository(),
      child: MaterialApp.router(           // NOT MaterialApp(home: ...)
        routerConfig: _router,
        ...
      ),
    );
  }
}
```

The `RepositoryProvider` must sit **outside** `MaterialApp.router` so that all routes (including fullscreen dialogs like the wizard) can read the repository via `context.read<PlantRepository>()`.

---

## Adding a new route — checklist

1. [ ] Declare the constant in `lib/routing/routes.dart`
2. [ ] Add a manual route or typed route (`GoRouteData`) in the routing layer
3. [ ] If there is required payload, prefer a typed wrapper and document the contract
4. [ ] Update this page (constants and contracts tables)
5. [ ] Tests: verify navigation to and from the new screen
