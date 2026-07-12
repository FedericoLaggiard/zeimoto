# Home Feature

Home is the main screen of Zeimoto, mounted by the router at `AppRoutes.home` (`/`).

---

## Responsibilities

`Home` composes the 5 vertical sections of the app inside a single scrollable `Scaffold`:

| Order | Section | Location |
|-------|---------|----------|
| 1 | `AiAssistantSection` | `lib/features/ai_assistant/` |
| 2 | `CollectionSection` | `lib/features/collection/` |
| 3 | `CalendarSection` | `lib/features/calendar/` |
| 4 | `FocusPlantSection` | `lib/features/focus/` |
| 5 | `WikiDelGiornoSection` | `lib/features/wiki/` |

In addition to sections, Home mounts:

- **FAB** (`add_plant_fab`) — invites the user to add a plant; navigates to `AppRoutes.addPlant` via GoRouter.
- **Pinned `AgentBar`** at the bottom — a non-interactive widget showing the `agent_bar_hint_text` placeholder.

---

## Location

```
lib/features/home/
└── home.dart    # class Home extends StatelessWidget
```

Home is a first-class feature, consistent with the other features under `lib/features/` (ADR-0001).

---

## Public contract

- **No required input**: `Home()` accepts no parameters.
- **Ambient dependency**: expects a `PlantRepository` injected into the widget tree via `RepositoryProvider` (provided by `main.dart`).
- **Navigation**: delegated to `AppRoutes` — no direct route imports (ADR-0004).

---

## Safe-area bottom fix

The scrollable area uses `Positioned.fill(bottom: agentBarHeight + MediaQuery.of(context).padding.bottom)` to ensure the last item is never hidden behind the `AgentBar` or the iPhone home indicator (system bottom inset).

---

## Tests

`test/features/home/home_test.dart` — widget test with real `buildAppRouter()` and `InMemoryPlantRepository`. Covers composition, scrolling, wizard navigation and the safe-area bottom regression.
