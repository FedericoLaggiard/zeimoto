# Routing

The routing layer (`lib/routing/`) is the **single source of truth** for all navigation in the application. No widget may reference another screen directly — it always uses `AppRoutes` constants and go_router APIs.

See [ADR-0004](../adr/0004-routing-go-router.md) for binding rules and the rationale behind the choice.

---

## File structure

```
lib/routing/
├── routes.dart       # AppRoutes — path constants (import this in widgets)
└── app_router.dart   # buildAppRouter() — GoRouter factory (import this in main.dart)
                      # re-exports routes.dart
```

Code that only needs the constants (e.g. widgets calling `context.push`) imports **`routes.dart`**.
Code that assembles the app (e.g. `main.dart`) imports **`app_router.dart`**.

---

## Path constants (`AppRoutes`)

Defined in `lib/routing/routes.dart`:

| Constant | Path | Description |
|----------|------|-------------|
| `AppRoutes.home` | `/` | Main shell — `ZeimotoAppShell` |
| `AppRoutes.addPlant` | `/add-plant` | Plant creation wizard (fullscreen dialog) |
| `AppRoutes.plantDetail` | `/plant-detail` | Single plant detail |

To add a new route: declare the constant in `routes.dart`, then add the matching `GoRoute` in `app_router.dart`. No other file needs to change.

---

## Route map

```mermaid
graph LR
    HOME[/ home] -->|context.push addPlant| WIZ[/add-plant\nAddPlantWizard\nfullscreenDialog]
    HOME -->|context.push plantDetail\nextra: Plant| DET[/plant-detail\nPlantDetailPlaceholder]
    WIZ -->|context.pop\non save or close| HOME
    DET -->|context.pop| HOME
```

---

## Router factory (`buildAppRouter`)

Defined in `lib/routing/app_router.dart`. Returns a `GoRouter` with three top-level routes:

```dart
GoRouter buildAppRouter() {
  return GoRouter(
    initialLocation: AppRoutes.home,
    routes: [
      // Home shell
      GoRoute(path: AppRoutes.home,        builder: ...),
      // Add-plant wizard (fullscreen dialog, no extra)
      GoRoute(path: AppRoutes.addPlant,    pageBuilder: ...),
      // Plant detail (extra: Plant required)
      GoRoute(path: AppRoutes.plantDetail, pageBuilder: ...),
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

// With payload (extra required for plantDetail)
context.push(AppRoutes.plantDetail, extra: plant);
```

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
| `AppRoutes.plantDetail` | `Plant` (required) | `state.extra! as Plant`; not serialisable — switch to ID when persistence is introduced |

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
2. [ ] Add the `GoRoute` in `buildAppRouter()` with an explanatory comment
3. [ ] Document the `extra` contract if present
4. [ ] Update this page (constants and contracts tables)
5. [ ] Tests: verify navigation to and from the new screen
