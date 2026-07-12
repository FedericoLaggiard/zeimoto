# A14 — Typed routes con go_router

Status: ready-for-agent

## Parent

[PLAN.md — App Shell MVP](../PLAN.md)

## Contesto

Introdotto in A6 (ADR-0004), il routing usa `state.extra` non tipizzato per passare oggetti di dominio alle route (es. `Plant` a `/plant-detail`). Questo crea due problemi:

1. **Invisible contract** — un `context.push(AppRoutes.plantDetail)` senza `extra` compila ma crasha a runtime. Il tipo richiesto non è visibile nel call site.
2. **Force-unwrap residuo** — nonostante il `redirect` guard aggiunto in A6 come fix immediato, il `state.extra! as Plant` resta un cast che presuppone il guard.

La soluzione definitiva è usare le **Typed Routes** di go_router (`TypedGoRoute` + classi `RouteData`), che rendono il contratto di ogni rotta un tipo Dart verificabile a compile-time.

## What to build

Migrare `lib/routing/` a typed routes:

- Creare una classe `RouteData` per ogni rotta che richiede parametri (inizialmente solo `PlantDetailRoute`)
- Sostituire `context.push(AppRoutes.plantDetail, extra: plant)` con `PlantDetailRoute(plant: plant).push(context)` (o equivalente API go_router typed)
- Rimuovere il `redirect` guard su `/plant-detail` introdotto come fix temporaneo in A6 (non più necessario con typed routes)
- Mantenere le costanti `AppRoutes` in `routes.dart` come riferimento ai path — i typed route wrapper li utilizzano internamente

## Acceptance criteria

- [ ] La rotta `/plant-detail` usa un typed route: la compilazione fallisce se si naviga senza passare un `Plant`
- [ ] Il redirect guard temporaneo su `/plant-detail` è rimosso
- [ ] `context.push(AppRoutes.plantDetail, extra: plant)` è sostituito con l'API typed
- [ ] Tutti i test passano
- [ ] Nessun `state.extra!` non guardato rimane in `app_router.dart`

## Blocked by

Nessuna dipendenza tecnica. Può essere eseguita dopo il merge di A6.

## Riferimenti

- [ADR-0004 — Routing go_router](../../../docs/adr/0004-routing-go-router.md)
- [go_router typed routes docs](https://pub.dev/documentation/go_router/latest/topics/Type-safe%20routes-topic.html)
