# Feature Home

La Home è la schermata principale di Zeimoto, montata dal router su `AppRoutes.home` (`/`).

---

## Responsabilità

`Home` compone le 5 sezioni dell'applicazione in un `Scaffold` a snap-paging verticale tramite `HomePager`:

| Pagina | Sezione | Collocazione |
|--------|---------|---------------|
| 0 | `AiAssistantSection` | `lib/features/ai_assistant/` |
| 1 | `CollectionSection` | `lib/features/collection/` |
| 2 | `CalendarSection` | `lib/features/calendar/` |
| 3 | `FocusPlantSection` | `lib/features/focus/` |
| 4 | `WikiDelGiornoSection` | `lib/features/wiki/` |

Oltre alle sezioni, la Home monta:

- **FAB** (`add_plant_fab`) — sollecita l'utente ad aggiungere una pianta; naviga verso `AppRoutes.addPlant` tramite GoRouter.
- **`AgentBar`** pinnata in fondo — widget non interattivo che mostra il placeholder testuale `agent_bar_hint_text`.

---

## Collocazione

```
lib/features/home/
├── home.dart       # class Home extends StatelessWidget
└── home_pager.dart # class HomePager extends StatefulWidget

lib/widgets/
└── section_parallax.dart  # class SectionParallax extends StatelessWidget
```

La Home è una feature a tutti gli effetti, coerente con le altre feature sotto `lib/features/` (ADR-0001).

---

## Architettura snap-paging

`HomePager` è un `StatefulWidget` che possiede un `PageController` e rende un `PageView` verticale con `PageScrollPhysics` (snap nativo). Ogni pagina avvolge titolo e contenuto in un `SectionParallax` con i valori di depth dal prototipo Variant C:

- **titolo**: depth `1.35` — si muove più velocemente (parallasse più marcato)
- **contenuto**: depth `0.85` — si muove più lentamente (parallasse sottile)

`SectionParallax` applica traslazione verticale, scala e opacità in funzione dell'offset dalla pagina corrente.

---

## Contratto pubblico

- **`Home`** — `StatelessWidget` senza parametri; legge il `PlantRepository` ambient tramite `RepositoryProvider` (ADR-0001).
- **`HomePager`** — nessun parametro pubblico. Il `PageController` è accessibile via `HomePagerState.controller` (seam di test; il codice produzione non lo usa).
- **`SectionParallax`** — widget puro senza dipendenze da BLoC, repository o localizzazione.
- **Navigazione**: sempre delegata ad `AppRoutes` (ADR-0004).

---

## Fix safe-area bottom

L'area paginata usa `Positioned.fill(bottom: agentBarHeight + MediaQuery.of(context).padding.bottom)` per garantire che nessuna pagina si sovrapponga all'`AgentBar` né all'indicatore home su iPhone. Il contenuto più lungo della pagina viene troncato (`ClipRect` + `OverflowBox`).

---

## Test

`test/features/home/home_test.dart` — widget test con `buildAppRouter()` reale e `InMemoryPlantRepository`. La navigazione tra pagine usa `_pagerController(tester).jumpToPage(N)` tramite il seam `HomePagerState.controller`. Verifica: composizione, ordine delle sezioni, navigazione al wizard, dettaglio pianta e fix safe-area bottom.
