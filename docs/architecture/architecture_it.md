# Architettura Generale

Panoramica dell'architettura dell'applicazione Flutter Zeimoto al termine del MVP A1–A9, A14 e A15.

---

## Struttura del progetto

```
flutter-app/lib/
├── main.dart                     # Entry point; RepositoryProvider radice + GoRouter
├── core/
│   └── design/
│       └── zeimoto_theme.dart   # Palette, spaziatura, ThemeData
├── data/
│   ├── db/
│   │   └── app_database.dart    # Schema Drift, generato da drift_dev
│   └── repositories/
│       └── drift_plant_repository.dart  # Impl. Drift di PlantRepository
├── domain/
│   └── plants.dart              # Tipi di dominio, PhotoPath, interfaccia repository, impl. in-memory
├── features/
│   ├── home/
│   │   └── home.dart            # Feature Home: 5 sezioni + FAB + AgentBar
│   ├── add_plant/
│   │   ├── plant_creation_state.dart
│   │   ├── plant_creation_cubit.dart
│   │   └── add_plant_wizard.dart
│   ├── ai_assistant/
│   │   └── ai_assistant_section.dart
│   ├── calendar/
│   │   └── calendar_section.dart
│   ├── collection/
│   │   ├── collection_state.dart
│   │   ├── collection_cubit.dart
│   │   ├── collection_section.dart
│   │   └── plant_detail_placeholder.dart
│   └── focus/
│       ├── focus_state.dart
│       ├── focus_cubit.dart
│       └── focus_plant_section.dart
├── widgets/
│   ├── agent_bar.dart           # Widget UI riutilizzabile — barra agente pinnata
│   └── plant_cover_photo.dart   # Widget condiviso — foto di copertina pianta da filesystem
├── routing/
│   ├── routes.dart              # AppRoutes — costanti dei path (sorgente unica di verità)
│   ├── app_router.dart          # buildAppRouter() factory + re-export di routes.dart
│   └── plant_detail_route.dart  # typed route (GoRouteData) per /plant-detail
└── l10n/
    ├── app_it.arb               # Stringhe italiano (template)
    ├── app_en.arb               # Stringhe inglese
    └── app_localizations.dart   # Generato da flutter gen-l10n
```

---

## Livelli architetturali

```mermaid
graph TD
    subgraph Presentazione
        HM[Home]
        APW[AddPlantWizard]
        AIA[AiAssistantSection]
        CS[CollectionSection]
        FPS[FocusPlantSection]
        CAL[CalendarSection]
        DPP[PlantDetailPlaceholder]
    end

    subgraph StatoFeature["Stato Feature (Cubit)"]
        PCC[PlantCreationCubit]
        PCS[PlantCreationState]
        CC[CollectionCubit]
        CST[CollectionState]
        FC[FocusCubit]
        FS[FocusState]
    end

    subgraph Dominio
        PR[PlantRepository interface]
        P[Plant]
        PP[PhotoPath]
    end

    subgraph Infrastruttura
        IMPR[InMemoryPlantRepository]
        DPR[DriftPlantRepository]
        ADB[(AppDatabase / SQLite)]
    end

    subgraph Fondamenta
        TH[ZeimotoTheme]
        L10N[AppLocalizations]
    end

    HM --> TH
    HM --> L10N
    HM --> AIA
    HM --> CS
    HM --> FPS
    HM --> CAL
    CS --> DPP
    FPS --> DPP
    APW --> PCC
    APW --> L10N
    PCC --> PCS
    PCC --> PR
    CC --> CST
    CC --> PR
    FC --> FS
    FC --> PR
    PR --> P
    IMPR -->|implements| PR
    DPR -->|implements| PR
    DPR --> ADB
```

---

## Iniezione delle dipendenze

`PlantRepository` è fornito una volta sola a livello di `main.dart` tramite `RepositoryProvider` (da `flutter_bloc`). In produzione viene istanziato `DriftPlantRepository(AppDatabase(NativeDatabase(...)))`. Il `GoRouter` è creato da `buildAppRouter()` e passato a `MaterialApp.router`. Ogni feature legge il repository tramite `context.read<PlantRepository>()` nel `create` del proprio `BlocProvider`.

```mermaid
graph TD
    A[RepositoryProvider&lt;PlantRepository&gt;\nmain.dart] --> B[MaterialApp.router\nrouterConfig: GoRouter]
    B --> GR[GoRouter\nbuildAppRouter]
    GR --> C[Home]
    GR --> D[AddPlantWizard]
    GR --> DPP[PlantDetailPlaceholder]
    D --> E[BlocProvider&lt;PlantCreationCubit&gt;\ncontext.read PlantRepository]
    C --> F[CollectionSection\nBlocProvider&lt;CollectionCubit&gt; interno\ncontext.read PlantRepository]
    C --> G[FocusPlantSection\nBlocProvider&lt;FocusCubit&gt; interno\ncontext.read PlantRepository]
```

---

## Decisioni architetturali (ADR)

| ADR | Titolo |
|-----|--------|
| [0001](../adr/0001-feature-based-architecture.md) | Feature-based architecture sotto `lib/features/` |
| [0002](../adr/0002-flutter-bloc-state-management.md) | `flutter_bloc` come state-management seam |
| [0003](../adr/0003-business-logic-in-cubits.md) | Logica di business nei Cubit; nessun `*Flow` intermedio |
| [0004](../adr/0004-routing-go-router.md) | Routing centralizzato con go_router in `lib/routing/` |
| [0005](../adr/0005-plant-repository-drift-contract.md) | Contratto `PlantRepository` Drift: API, reattività Cubit, injection, test |

---

## Convenzioni di test

| Layer | Strategia | File |
|-------|-----------|------|
| Cubit | Unit test puri, senza widget | `test/features/<nome>/*_cubit_test.dart` |
| Widget | Widget test con `GoRouter` locale + `RepositoryProvider.value` + fake/in-memory repo | `test/features/<nome>/*_test.dart` |
| Home | Widget test con `buildAppRouter()` reale + `InMemoryPlantRepository` | `test/features/home/home_test.dart` |
| Widget standalone | Widget test in isolamento con `MaterialApp` + `AppLocalizations` | `test/widgets/*_test.dart` |
| Dominio | Unit test puri | `test/domain/*_test.dart` |
| Repository Drift | Unit test con `NativeDatabase.memory()` iniettato nel costruttore | `test/data/repositories/*_test.dart` |
