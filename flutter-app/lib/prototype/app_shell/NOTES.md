# Prototype notes — issue #3

**Question**
What should the MVP app shell + Archivio Piante + Creazione Pianta look and feel like?
Which structural approach best serves the mission ("l'app osserva, suggerisce e ricorda") on mobile?

**What this is**
Throwaway UI prototype. Three radically different variants of the shell + archive + create flow, all wired into a single Flutter app and switchable via the floating bar at the bottom of the screen (or ← / → on keyboard when running in a simulator with a hardware keyboard).

**How to run**

```
flutter run
```

Boots straight into the prototype. No login, no persistence. Five seeded plants are shown; each variant lets you add more via its create flow. State is in-memory only — a hot restart wipes everything.

Photos are gradient placeholders (labelled `PLACEHOLDER`) so the prototype needs zero platform permissions. Real camera / picker integration comes later, once a variant wins.

**Variants**

- **A — Griglia zen.** No bottom nav. Big 2-column photo grid, sparse chrome. Detail = full-bleed hero with a scrollable metadata drawer. Create = full-page vertical scroll (foto → specie → nickname).
- **B — Feed + bottom nav.** Single-column tall cards (like a considered feed). Bottom nav with Piante / Home / Calendario / Chat / "+". Detail = card sections. Create = modal bottom-sheet stepper (Foto → Specie → Conferma).
- **C — Cover carousel + agent bar.** Horizontal PageView of large cover cards, filter chips on top, persistent "Cosa vuoi fare oggi?" input bar at the bottom. Detail = swipeable pages between plants. Create = full-page 3-step wizard.

**What every variant enforces (from PRD)**

- Foto obbligatoria (Save disabled until a placeholder is picked)
- Specie obbligatoria (Save/Next disabled until picked)
- Nickname opzionale (auto default like `palmatum_03`)

**Verdict**

_Not filled in yet — fill this in after you flip through the variants._

- Winning variant:
- What to keep from the losers:
- Structural decision to fold into real code:

**Cleanup**

Once the verdict is captured, delete `lib/prototype/` and fold the winner into the real code path. Do **not** promote prototype code directly — it was written under prototype constraints (no tests, in-memory store, placeholder photos).
