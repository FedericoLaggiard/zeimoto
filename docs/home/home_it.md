# Feature Home

La Home è la schermata principale di Zeimoto, montata dal router su `AppRoutes.home` (`/`).

---

## Responsabilità

`Home` compone le 5 sezioni verticali dell'applicazione in un unico `Scaffold` scrollabile:

| Ordine | Sezione | Collocazione |
|--------|---------|--------------|
| 1 | `AiAssistantSection` | `lib/features/ai_assistant/` |
| 2 | `CollectionSection` | `lib/features/collection/` |
| 3 | `CalendarSection` | `lib/features/calendar/` |
| 4 | `FocusPlantSection` | `lib/features/focus/` |
| 5 | `WikiDelGiornoSection` | `lib/features/wiki/` |

Oltre alle sezioni, la Home monta:

- **FAB** (`add_plant_fab`) — sollecita l'utente ad aggiungere una pianta; naviga verso `AppRoutes.addPlant` tramite GoRouter.
- **`AgentBar`** pinnata in fondo — widget non interattivo che mostra il placeholder testuale `agent_bar_hint_text`.

---

## Collocazione

```
lib/features/home/
└── home.dart    # class Home extends StatelessWidget
```

La Home è una feature a tutti gli effetti, coerente con le altre feature sotto `lib/features/` (ADR-0001).

---

## Contratto pubblico

- **Nessun input obbligatorio**: `Home()` non accetta parametri.
- **Dipendenza ambient**: si aspetta un `PlantRepository` iniettato nell'albero tramite `RepositoryProvider` (fornito da `main.dart`).
- **Navigazione**: delegata a `AppRoutes` — nessun import diretto di route (ADR-0004).

---

## Fix safe-area bottom

L'area scrollabile usa `Positioned.fill(bottom: agentBarHeight + MediaQuery.of(context).padding.bottom)` per garantire che l'ultimo contenuto non venga nascosto dall'`AgentBar` né dall'indicatore home su iPhone (safe-area inset inferiore).

---

## Test

`test/features/home/home_test.dart` — widget test con `buildAppRouter()` reale e `InMemoryPlantRepository`. Verifica la composizione, lo scrolling, la navigazione al wizard e il fix safe-area bottom.
