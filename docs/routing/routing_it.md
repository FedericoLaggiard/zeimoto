# Routing

Il layer di routing (`lib/routing/`) è la **sorgente unica di verità** per tutta la navigazione dell'applicazione. Nessun widget può referenziare direttamente un'altra schermata: usa sempre API di go_router tramite costanti `AppRoutes` oppure wrapper typed (`GoRouteData`) definiti nel routing layer.

Vedi [ADR-0004](../adr/0004-routing-go-router.md) per le regole vincolanti e la motivazione della scelta.

---

## Struttura dei file

```
lib/routing/
├── routes.dart       # AppRoutes — costanti dei path (importa questo nei widget)
├── app_router.dart   # buildAppRouter() — factory del GoRouter (importa questo in main.dart)
│                     # re-esporta routes.dart
└── plant_detail_route.dart   # typed route (GoRouteData) per /plant-detail
```

Il codice che ha bisogno solo delle costanti (es. widget che chiamano `context.push`) importa **`routes.dart`**.
Il codice che naviga verso route con payload obbligatorio può importare il wrapper typed da `lib/routing/` (es. `PlantDetailRoute`).
Il codice che costruisce l'app (es. `main.dart`) importa **`app_router.dart`**.

---

## Costanti dei path (`AppRoutes`)

Definite in `lib/routing/routes.dart`:

| Costante | Path | Descrizione |
|----------|------|-------------|
| `AppRoutes.home` | `/` | Shell principale — `Home` |
| `AppRoutes.addPlant` | `/add-plant` | Wizard creazione pianta (fullscreen dialog) |
| `AppRoutes.plantDetail` | `/plant-detail` | Dettaglio singola pianta |

Per aggiungere una nuova rotta: dichiarare la costante in `routes.dart`, poi aggiungere la `GoRoute` corrispondente in `app_router.dart`. Nessun altro file va modificato.

---

## Mappa delle rotte

```mermaid
graph LR
    HOME[/ home] -->|context.push addPlant| WIZ[/add-plant\nAddPlantWizard\nfullscreenDialog]
  HOME -->|PlantDetailRoute(plant).push\nextra typed: Plant| DET[/plant-detail\nPlantDetailPlaceholder]
    WIZ -->|context.pop\non save o close| HOME
    DET -->|context.pop| HOME
```

---

## Factory del router (`buildAppRouter`)

Definita in `lib/routing/app_router.dart`. Ritorna un `GoRouter` con route manuali per shell e wizard, e route typed aggregate generate da `go_router_builder`:

```dart
GoRouter buildAppRouter() {
  return GoRouter(
    initialLocation: AppRoutes.home,
    routes: [
      // Home shell
      GoRoute(path: AppRoutes.home,        builder: ...),
      // Wizard add-plant (fullscreen dialog, nessun extra)
      GoRoute(path: AppRoutes.addPlant,    pageBuilder: ...),
      // Typed routes generate (es. PlantDetailRoute)
      ...$appRoutes,
    ],
  );
}
```

Il `GoRouter` viene creato in `_ZeimotoAppState` (un `StatefulWidget`) per garantire che l'istanza sopravviva ai rebuild del widget.

---

## Come navigare

### Aprire una schermata

```dart
// In qualsiasi widget con un BuildContext
context.push(AppRoutes.addPlant);

// Con payload obbligatorio: preferire route typed
PlantDetailRoute(plant).push(context);
```

Regola pratica:
- Usa `context.push(AppRoutes.<name>)` per route senza payload obbligatorio.
- Usa wrapper typed (`GoRouteData`) per route con payload obbligatorio, così il contratto è verificato a compile-time.

### Tornare indietro

```dart
context.pop();
```

### ❌ Pattern vietati (ADR-0004)

```dart
// NON usare Navigator direttamente con widget espliciti
Navigator.of(context).push(MaterialPageRoute(builder: (_) => AddPlantWizard()));

// NON usare stringhe letterali
context.push('/add-plant');

// NON importare AddPlantWizard in un altro widget per navigarci
import '../features/add_plant/add_plant_wizard.dart'; // ← violazione ADR-0001
```

---

## Contratti delle rotte

| Rotta | `extra` | Note |
|-------|---------|------|
| `AppRoutes.home` | — | Nessun extra |
| `AppRoutes.addPlant` | — | Nessun extra; il wizard legge il repository dall'ambiente |
| `AppRoutes.plantDetail` | `Plant` (obbligatorio) | Contratto esposto tramite `PlantDetailRoute(plant)`; il parser generated usa `state.extra as Plant`. Non serializzabile: usare ID quando si introdurrà la persistenza |

---

## Integrazione in `main.dart`

```dart
class _ZeimotoAppState extends State<ZeimotoApp> {
  late final _router = buildAppRouter();   // creato una volta sola

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider<PlantRepository>(
      create: (_) => InMemoryPlantRepository(),
      child: MaterialApp.router(           // NON MaterialApp(home: ...)
        routerConfig: _router,
        ...
      ),
    );
  }
}
```

Il `RepositoryProvider` deve essere **esterno** a `MaterialApp.router` così che tutte le rotte (inclusi i dialog fullscreen come il wizard) possano leggere il repository tramite `context.read<PlantRepository>()`.

---

## Aggiungere una nuova rotta — checklist

1. [ ] Dichiarare la costante in `lib/routing/routes.dart`
2. [ ] Aggiungere route manuale o typed route (`GoRouteData`) nel layer routing
3. [ ] Se c'è payload obbligatorio, preferire wrapper typed e documentarne il contratto
4. [ ] Aggiornare questa pagina (tabelle costanti e contratti)
5. [ ] Test: verificare navigazione verso e da questa schermata
