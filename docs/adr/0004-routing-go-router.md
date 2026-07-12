# ADR-0004 — Routing centralizzato con go_router

**Status:** Accepted  
**Data:** 2026-07-12  
**Contesto:** A6 — Agent bar operativa (issue #6)

---

## Contesto

Prima di questo ADR la navigazione era distribuita tra i widget: `ZeimotoAppShell` importava direttamente `AddPlantWizard` e `PlantDetailPlaceholder`, e `AgentBar` conteneva la logica di navigazione (`_openWizard`). Questo violava ADR-0001 (architettura feature-based) creando dipendenze compile-time dal layer `app/` verso i layer `features/`, e ADR-0003 (logica nei Cubit) lasciando la coordinazione della navigazione nei widget.

---

## Decisione

**Tutta la navigazione dell'applicazione è dichiarata in `lib/routing/`**, che è l'unica sorgente di verità per:

- le costanti dei path (`AppRoutes.home`, `AppRoutes.addPlant`, `AppRoutes.plantDetail`, …)
- il `GoRouter` configurato con tutte le rotte e i relativi widget

I widget **non importano mai** altri widget di feature per scopi di navigazione. Per navigare usano esclusivamente `context.push(AppRoutes.<name>)` e `context.pop()` forniti da `go_router`.

### Package scelto: `go_router`

- API idiomatica e manutenuta da Google/Flutter team
- Supporto deep link nativi per future esigenze
- `GoRouter` è facilmente sostituibile nei test con un'istanza locale
- `MaterialApp.router` + `routerConfig` integra il router nella radice dell'app

---

## Conseguenze

### Positive

- **ADR-0001 rispettato**: il layer `lib/app/` non importa più implementazioni da `lib/features/`
- **ADR-0003 rispettato**: nessuna logica di navigazione nei widget; i Cubit restano navigation-agnostic
- **Single source of truth**: aggiungere, rinominare o proteggere una route richiede modifiche in un solo file
- **Testabilità**: i test forniscono un `GoRouter` locale senza toccare il `buildAppRouter` globale

### Negative / Trade-off

- Ogni nuova schermata richiede una dichiarazione esplicita in `app_router.dart` (overhead minimo, vantaggio netto)
- L'extra per `PlantDetailPlaceholder` passa un oggetto `Plant` non serializzabile: va bene in questo slice; quando si introdurrà la persistenza la route dovrà passare un ID e risolvere la pianta nel `pageBuilder`

---

## Regole vincolanti (obbligatorie per tutti i contributor e per gli agenti AFK)

1. **Nessun `Navigator.of(context).push(…)`** con istanza widget esplicita. Usare sempre `context.push(AppRoutes.<name>)`.
2. **Nessun `Navigator.of(context).pop()`** nelle schermate. Usare `context.pop()` di go_router.
3. **Ogni nuova schermata** deve avere una costante in `AppRoutes` e una `GoRoute` in `buildAppRouter()`.
4. **Nessun widget** in `lib/app/` o `lib/features/<A>/` può importare un widget di `lib/features/<B>/` per navigarci. Il routing è il tramite.
5. In fase di test, usare `buildAppRouter()` o un `GoRouter` locale equivalente — mai avvolgere i widget in `MaterialApp(home: ...)` quando si testa la navigazione.
