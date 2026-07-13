# Home Feature

Home is the main screen of Zeimoto, mounted by the router at `AppRoutes.home` (`/`).

---

## Responsibilities

`Home` composes the 5 sections of the app inside a snap-paging vertical `Scaffold` via `HomePager`:

| Page | Section | Location |
|------|---------|----------|
| 0 | `AiAssistantSection` | `lib/features/ai_assistant/` |
| 1 | `CollectionSection` | `lib/features/collection/` |
| 2 | `CalendarSection` | `lib/features/calendar/` |
| 3 | `FocusPlantSection` | `lib/features/focus/` |
| 4 | `WikiDelGiornoSection` | `lib/features/wiki/` |

In addition to sections, Home mounts:

- **FAB** (`add_plant_fab`) — invites the user to add a plant; navigates to `AppRoutes.addPlant` via GoRouter.
- **Pinned `AgentBar`** at the bottom — a non-interactive widget showing the `agent_bar_hint_text` placeholder.

---

## Location

```
lib/features/home/
├── home.dart       # class Home extends StatelessWidget
└── home_pager.dart # class HomePager extends StatefulWidget

lib/widgets/
└── section_parallax.dart  # class SectionParallax extends StatelessWidget
```

Home is a first-class feature, consistent with the other features under `lib/features/` (ADR-0001).

---

## Snap-paging architecture

`HomePager` is a `StatefulWidget` that owns a `PageController` and renders a vertical `PageView` with `PageScrollPhysics` (native snap). Each page wraps its title and content in a `SectionParallax` with the depth values from prototype Variant C:

- **title**: depth `1.35` — moves faster (stronger parallax)
- **content**: depth `0.85` — moves slower (subtler parallax)

`SectionParallax` applies vertical translation, scale, and opacity as a function of the offset from the current page.

---

## Public contract

- **`Home`** — `StatelessWidget` with no parameters; reads the ambient `PlantRepository` via `RepositoryProvider` (ADR-0001).
- **`HomePager`** — no public parameters. The `PageController` is accessible via `HomePagerState.controller` (test seam; production code never uses it).
- **`SectionParallax`** — pure widget with no BLoC, repository or l10n dependencies.
- **Navigation**: always delegated to `AppRoutes` (ADR-0004).

---

## Safe-area bottom fix

The paged area uses `Positioned.fill(bottom: agentBarHeight + MediaQuery.of(context).padding.bottom)` to ensure no page overlaps the `AgentBar` or the iPhone home indicator. Content taller than one page is clipped (`ClipRect` + `OverflowBox`).

---

## Tests

`test/features/home/home_test.dart` — widget test with real `buildAppRouter()` and `InMemoryPlantRepository`. Page navigation uses `_pagerController(tester).jumpToPage(N)` via the `HomePagerState.controller` test seam. Covers: section composition, page order, wizard navigation, plant detail, and safe-area bottom regression.
