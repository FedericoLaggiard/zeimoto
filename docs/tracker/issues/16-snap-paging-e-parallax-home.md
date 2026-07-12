# A16 — Snap paging + parallasse nella Home

Status: ready

## Parent

[PLAN.md](../PLAN.md)

---

## Problem Statement

Rispetto al prototipo Variant C, la home produzione ha perso due funzionalità
visive essenziali che definiscono il carattere dell'interfaccia:

1. **Snap paging verticale** — nel prototipo ogni sezione occupa una pagina
   intera (`PageView` verticale); scorrere fa snap alla sezione successiva o
   precedente con effetto di paginazione netto. In produzione la home usa
   `CustomScrollView` con scroll continuo libero: non c'è snap, le sezioni
   si susseguono come una lista.

2. **Effetto parallasse** — nel prototipo i titoli di sezione e il contenuto
   si muovono a velocità diverse durante le transizioni tra pagine (titolo:
   depth `1.35`; contenuto: depth `0.85`; l'effetto include traslazione
   verticale, scala e opacità). In produzione non esiste nessun effetto
   di questo tipo.

---

## Solution

Introdurre uno strato di presentazione `HomePager` (estratto in un
`StatefulWidget` dedicato) che:

- Possiede un `PageController` verticale condiviso da tutte le pagine.
- Rende le 5 sezioni in un `PageView` verticale con snap nativo.
- Avvolge titolo e contenuto di ogni pagina in un widget `SectionParallax`
  con i valori di depth del prototipo.
- Lascia invariato il contratto pubblico di ogni sezione (`AiAssistantSection`,
  `CollectionSection`, ecc.) — il parallasse è applicato interamente in
  `HomePager`, le sezioni non sanno di essere in un `PageView`.
- Espone un parametro opzionale `controller` per permettere l'iniezione del
  `PageController` nei test (seam di test esplicito).

---

## Commits

### Commit 1 — `feat(widgets): add SectionParallax widget`

Aggiungere `lib/widgets/section_parallax.dart`: un `StatelessWidget` che
avvolge qualsiasi `child` in un `AnimatedBuilder` su un `PageController`
passato dall'esterno. Il calcolo dell'offset usa la stessa formula del
prototipo (`delta * 124 * depth` per la traslazione, `1 - delta.abs() * 0.07 *
depth` per la scala, `(1 - delta.abs() * 0.42).clamp(0.5, 1.0)` per
l'opacità). Parametri: `pageController`, `pageIndex` (int), `depth` (double),
`child`.

Nessuna modifica ad altri file. Tutti i test esistenti restano verdi.

### Commit 2 — `feat(home): introduce HomePager widget`

Aggiungere `lib/features/home/home_pager.dart`: un `StatefulWidget` che:

- Crea internamente un `PageController` se il parametro opzionale `controller`
  non è fornito.
- Rende un `PageView` verticale con 5 pagine, ognuna composta da
  `SectionParallax(depth: 1.35, child: titolo)` + `Expanded(SectionParallax(depth: 0.85, child: widget_sezione))`.
- Per ora i 5 slot di pagina sono `SizedBox.expand()` placeholder.

`home.dart` NON è ancora modificato — `HomePager` non è usato. Tutti i test
esistenti restano verdi.

### Commit 3 — `refactor(home): Home usa HomePager al posto di CustomScrollView`

Modificare `home.dart`:

- Sostituire il blocco `CustomScrollView` con `HomePager`.
- I titoli di sezione oggi renderizzati inline in `home.dart` come
  `Padding(Text(l10n.calendar_section_title...))` si spostano nei slot titolo
  del `HomePager`.
- I widget di sezione (`AiAssistantSection`, `CollectionSection`, ecc.) sono
  invariati — finiscono nello slot contenuto del `HomePager` senza modifiche.
- FAB e `AgentBar` rimangono in `home.dart`, invariati.
- L'app gira: snap funziona, parallasse funziona.

### Commit 4 — `test(home): adattare home_test al PageView`

Modificare `test/features/home/home_test.dart`:

- Aggiornare il test `buildApp()` per iniettare un `PageController` esterno in
  `HomePager` (tramite il parametro `controller`) così che i test possano
  chiamare `jumpToPage`.
- Rimuovere o aggiornare l'assertion che cerca `CustomScrollView` (ora c'è un
  `PageView`).
- Sostituire ogni `scrollUntilVisible` con navigazione esplicita:
  `controller.jumpToPage(N)` + `tester.pumpAndSettle()` per portare in vista
  la sezione target.
- Aggiungere un'assertion che verifica la presenza di `PageView` con 5 figli.
- Tutti i test di composizione e CTA (agent bar → wizard, card collezione →
  dettaglio, focus pianta → dettaglio) devono continuare a passare nella nuova
  struttura.

---

## Decision Document

- **`SectionParallax`** vive in `lib/widgets/` accanto agli altri widget
  condivisi (`AgentBar`, `PhotoTile`). È un widget puro: nessuna dipendenza
  da BLoC, repository o localizzazione.

- **`HomePager`** vive in `lib/features/home/home_pager.dart`, non in
  `lib/widgets/`, perché conosce l'ordine e i titoli delle 5 sezioni di home
  — è logica di composizione della feature, non un widget generico.

- **Il `PageController` non è esposto nel contratto pubblico di `Home`** —
  `Home` rimane `StatelessWidget` senza parametri. Solo `HomePager` è
  `StatefulWidget`. Il parametro `controller` di `HomePager` è pensato
  esclusivamente per i test; il codice applicativo non lo usa.

- **Le sezioni non cambiano interfaccia** — `AiAssistantSection`,
  `CollectionSection`, `CalendarSection`, `FocusPlantSection`,
  `WikiDelGiornoSection` non acquisiscono parametri `pageController` /
  `pageIndex`. Il parallasse è responsabilità di `HomePager`.

- **Snap physics**: `PageScrollPhysics` nativo di Flutter — nessun pacchetto
  aggiuntivo.

- **Depth values** replicati dal prototipo Variant C senza modifica:
  titolo `1.35`, contenuto `0.85`.

- **Contenuto più lungo della pagina**: il design si adatta, il contenuto
  viene troncato. Nessuno scroll interno alle sezioni in questa issue.

---

## Testing Decisions

Un buon test verifica comportamento osservabile dall'esterno, non dettagli
implementativi:

- **Non testare** i valori numerici di traslazione/scala/opacità — sono dettagli
  di rendering che cambiano facilmente.
- **Testare** che navigare alla pagina N renda visibile la sezione N.
- **Testare** che l'`AgentBar` sia ancora visibile dopo aver navigato
  all'ultima pagina.
- **Testare** che le CTA critiche (wizard, dettaglio pianta) funzionino
  correttamente dalla pagina corretta.

Prior art: `test/features/home/home_test.dart` — tutti i test esistenti sono
widget test con `buildAppRouter()` + `InMemoryPlantRepository`. Il pattern
rimane invariato, cambia solo il meccanismo di navigazione da
`scrollUntilVisible` a `jumpToPage`.

---

## Out of Scope

- Indicatori di pagina visivi (dot indicators).
- Gesture shortcut per saltare sezioni.
- Feedback aptico sullo snap.
- Modifiche al design visivo delle sezioni.
- Cambio del comportamento del FAB.
- Scroll interno alle sezioni con contenuto lungo (issue futura).
- Modifiche a BLoC o repository.

---

## Further Notes

Il widget `_SectionParallax` del prototipo (`variant_c.dart`) è la reference
implementation diretta. Il porting in `lib/widgets/section_parallax.dart`
deve essere una trascrizione quasi letterale — solo rinominare da privato a
pubblico e rimuovere le dipendenze sui tipi del prototipo.
