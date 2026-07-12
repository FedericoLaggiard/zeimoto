# A15 — Estrazione della Home in una feature dedicata e AgentBar in lib/widgets/

Status: done

## Parent

[PLAN.md — App Shell MVP (Issue #3)](../PLAN.md)

## Problem Statement

Dal punto di vista di chi sviluppa la app oggi, tutta la Home vive dentro un unico file monolitico: [flutter-app/lib/app/zeimoto_app_shell.dart](../../../flutter-app/lib/app/zeimoto_app_shell.dart). Nello stesso file convivono due responsabilità che dovrebbero essere separate:

1. **`ZeimotoAppShell`** — la composizione della schermata Home vera e propria (5 sezioni verticali scrollabili, FAB per il wizard, agent bar pinnata). È chiaramente una *feature* del prodotto, alla pari con `CollectionSection`, `CalendarSection`, `FocusPlantSection`, `AiAssistantSection`, `WikiDelGiornoSection` — che sono già isolate in `lib/features/<slice>/`.

2. **`AgentBar`** — un widget UI di basso livello, senza logica di business, che potrebbe (e dovrebbe) essere riutilizzato da altre schermate future. Oggi è definito nello stesso file di `ZeimotoAppShell` e importa direttamente `AppLocalizations` per il proprio hint text.

Le conseguenze pratiche di questo accoppiamento:

- `lib/app/` è una cartella che ospita **un solo file**, e quel file mescola concerns eterogenei — non è una collocazione difendibile secondo ADR-0001 (architettura feature-based).
- Il nome `ZeimotoAppShell` suggerisce uno *shell applicativo* generico, ma di fatto è la Home: nessun'altra route la usa come guscio. Il nome mente.
- Testare `AgentBar` in isolamento oggi richiede istanziare tutta la Home o duplicare l'harness — non c'è un test file dedicato alla barra.
- Ogni volta che si tocca la composizione della Home si finisce a scrollare un file da ~200 righe dove metà è la Home e metà è la AgentBar.

## Solution

Fare la separazione minimale possibile, in commit tiny che lasciano il codice sempre compilabile e i test sempre verdi:

1. **AgentBar** esce dal file dello shell e si trasferisce in `lib/widgets/agent_bar.dart`. Nessuna modifica alla sua API o al suo comportamento — è un puro spostamento con aggiornamento degli import.
2. **ZeimotoAppShell** si trasforma in `Home`, feature autonoma sotto `lib/features/home/home.dart`, coerente con le altre feature esistenti. Il router smette di conoscere `lib/app/`.
3. **`lib/app/`** e il vecchio file `zeimoto_app_shell.dart` vengono cancellati completamente. Non resta un "thin wrapper" — la separazione è netta.
4. **Test**: mirror del sorgente. `test/app/zeimoto_app_shell_test.dart` diventa `test/features/home/home_test.dart`. Viene aggiunto un nuovo test file `test/widgets/agent_bar_test.dart` per testare la barra in isolamento (hint text localizzato, `AbsorbPointer` attivo).
5. **Documentazione**: nasce `docs/home/home_it.md` + `docs/home/home_en.md` per descrivere la feature, e `docs/architecture/architecture_*.md` viene aggiornato per riflettere la nuova collocazione.

## Commits

Ogni commit deve lasciare la build verde e tutti i test passanti. La strategia è: spostare prima l'anello più esterno (`AgentBar`, isolabile), poi coprirlo con test, poi spostare l'anello interno (Home), poi ripulire.

### Commit 1 — Estrai `AgentBar` in `lib/widgets/agent_bar.dart`

- Crea `lib/widgets/agent_bar.dart` copiando la classe `AgentBar` (e le sue dipendenze locali: import di `ZeimotoSpacing`, `AppLocalizations`) dal file `zeimoto_app_shell.dart`.
- Rimuovi la definizione di `AgentBar` da `zeimoto_app_shell.dart` e aggiungi al suo posto l'import del nuovo file.
- Aggiorna l'import nel file di test `test/app/zeimoto_app_shell_test.dart` in modo che continui a risolvere il simbolo `AgentBar`.
- Nessuna modifica di API, di parametri, di comportamento. Cut & paste puro.
- Verifica: il full test suite passa (77/77).

### Commit 2 — Test di isolamento per `AgentBar`

- Crea `test/widgets/agent_bar_test.dart`.
- Test minimi ma sufficienti per bloccare regressioni sull'API pubblica del widget: hint text presente e localizzato (via `lookupAppLocalizations` — no hard-code), presenza di `AbsorbPointer` sul `TextField` (verifica il contratto "non interattivo"), rispetto del parametro `height`.
- Nessuna modifica al codice di produzione.

### Commit 3 — Crea `lib/features/home/home.dart` come duplicato di `ZeimotoAppShell`

- Crea la cartella `lib/features/home/` e il file `home.dart`.
- Definisci `class Home extends StatelessWidget` copiando integralmente il body di `ZeimotoAppShell` (comprensivo del fix safe-area bottom introdotto nel commit `fix(shell): risolvi overlap ultimo contenuto con agent bar su iPhone`).
- A questo punto esistono **entrambe** le classi (`ZeimotoAppShell` in `lib/app/` e `Home` in `lib/features/home/`), ma nessuno usa ancora `Home`. Green.

### Commit 4 — Il router monta `Home` al posto di `ZeimotoAppShell`

- In `lib/routing/app_router.dart` cambia il `builder` della route home da `ZeimotoAppShell()` a `Home()` e aggiorna gli import.
- In `lib/routing/routes.dart` aggiorna il commento che menziona `ZeimotoAppShell`.
- Nel test file `test/app/zeimoto_app_shell_test.dart` sostituisci ogni `find.byType(ZeimotoAppShell)` con `find.byType(Home)` e rinomina il gruppo `'ZeimotoAppShell'` in `'Home'`. L'import di `zeimoto_app_shell.dart` viene sostituito da `home.dart`.
- Verifica: 77/77 verdi.

### Commit 5 — Cancella `lib/app/zeimoto_app_shell.dart` e la cartella `lib/app/`

- Rimuovi il file `lib/app/zeimoto_app_shell.dart` (ora codice morto — nessun import residuo lo referenzia).
- Rimuovi la cartella `lib/app/` se rimane vuota.
- Fai una `grep_search` per `ZeimotoAppShell` e per `lib/app/` per assicurarti che non restino riferimenti in codice o docs (aggiorna eventuali docs residue).
- Verifica: build e test verdi.

### Commit 6 — Sposta il test file

- Sposta `test/app/zeimoto_app_shell_test.dart` in `test/features/home/home_test.dart` (git-mv, il contenuto è già allineato al nuovo nome dopo commit 4).
- Rimuovi la cartella `test/app/` se rimane vuota.
- Verifica: 77/77 verdi.

### Commit 7 — Documentazione

- Crea `docs/home/home_it.md` e `docs/home/home_en.md` che descrivono la feature Home: responsabilità, composizione (le 5 sezioni + FAB + AgentBar), collocazione, contratto pubblico (nessun input, si aspetta un `PlantRepository` nell'`RepositoryProvider` ambient).
- Aggiorna `docs/architecture/architecture_it.md` + `architecture_en.md` menzionando la nuova collocazione di `Home` sotto `lib/features/home/` e di `AgentBar` sotto `lib/widgets/`.
- Aggiorna la memoria repo `/memories/repo/routing.md` se cita esplicitamente `ZeimotoAppShell` o `lib/app/`.

## Decision Document

- **Feature Home**: la Home diventa una feature autonoma in `lib/features/home/` per coerenza con `collection/`, `focus/`, `wiki/`, `calendar/`, `ai_assistant/`. La cartella `lib/app/` viene eliminata: non serve un livello intermedio "app shell" quando la Home ha una route dedicata e nessuna altra route condivide chrome globale.
- **Nome del widget**: la classe si chiama `Home`, senza suffissi. Le sezioni interne mantengono il suffisso `Section` (`CollectionSection`, `WikiDelGiornoSection`, ecc.); una Home chiamata `HomeSection` sarebbe ambigua.
- **AgentBar in `lib/widgets/`**: primo abitante di una cartella pensata per widget UI riutilizzabili senza logica di dominio. La collocazione è distinta da `lib/core/design/` (che ospita design tokens: colori, spacing, tipografia) e da `lib/features/*` (che ospitano feature verticali con stato e dominio).
- **AgentBar as-is**: nessuna modifica alla sua API pubblica (`AgentBar({super.key, this.height = ZeimotoSpacing.agentBarHeight})`) né al comportamento (`AbsorbPointer` + `TextField` non interattivo). L'issue A6 già copre la sua futura promozione a barra operativa; questo refactor non anticipa quella evoluzione.
- **Router**: `AppRoutes.home` continua a puntare a `/`, cambia solo il widget montato dal builder. Nessuna route rinominata, nessun path modificato.
- **Nessun re-export "compatibilità"**: dopo il commit 5 non resta né una typedef, né un file che ri-esporta `ZeimotoAppShell = Home`. Il rename è netto.
- **Fix safe-area bottom preservato**: la logica `Positioned.fill(bottom: agentBarHeight + MediaQuery.of(context).padding.bottom)` migra insieme al body della Home. Il test di regressione corrispondente resta in vigore.

## Testing Decisions

- **Cosa costituisce un buon test qui**: verificare comportamento osservabile dell'API pubblica del widget — non i dettagli interni della struttura (albero widget, chiavi private, ecc.). I test esistenti sulla Home già seguono questa disciplina (asserzioni su `find.byType(CollectionSection)`, `find.text(l10n.wiki_section_title)`, ecc.).
- **Home**: tutti i test attualmente in `test/app/zeimoto_app_shell_test.dart` migrano in `test/features/home/home_test.dart` con la sola rinomina del riferimento alla classe (`ZeimotoAppShell` → `Home`). Nessun test viene aggiunto o rimosso da questa migrazione — la copertura resta la stessa.
- **AgentBar**: nuovo file `test/widgets/agent_bar_test.dart` con test di isolamento. Prior art: la disciplina è la stessa di `test/features/calendar/calendar_section_test.dart` — costruire una `MaterialApp` con `AppLocalizations` delegates e la locale `it`, pumpare il widget in isolamento, assert su `find.text(l10n.agent_bar_hint_text)` e sulla presenza di `AbsorbPointer` che avvolge un `TextField`.
- **Il fix di regressione safe-area bottom** (`'ultimo contenuto non è nascosto dalla barra con safe-area bottom inset'`) migra con gli altri e continua a girare sotto `test/features/home/home_test.dart`.
- **Nessun nuovo harness custom**: si continua a usare `flutter_test` con `MaterialApp` + `AppLocalizations.localizationsDelegates` come in tutto il resto della suite.

## Out of Scope

- Qualsiasi evoluzione di `AgentBar` verso "barra operativa" (già coperta dalla issue A6 "Agent bar operativa").
- Estrazione di altri sotto-widget della Home (es. i titoli di sezione ripetuti, il pattern `SliverToBoxAdapter(Padding(...Text(l10n.X_title)))` che si ripete 5 volte). Sarà eventualmente una micro-issue separata dopo che il refactor si sarà stabilizzato.
- Introduzione di uno `HomeCubit` o simili: la Home resta un widget stateless che compone altre feature. Nessuna logica di stato viene aggiunta.
- Modifiche al routing (path, redirect, typed routes) al di là dello swap `ZeimotoAppShell` → `Home` nel builder.
- Modifiche al FAB, alle route del wizard, o al `RepositoryProvider` in `main.dart`.
- Modifiche a `lib/prototype/` — il codice del prototipo resta invariato (fuori dal perimetro MVP, ha la sua issue di ritiro A13).

## Further Notes

- La cartella `lib/widgets/` **non esiste ancora**. Il commit 1 la crea. Non è un errore: è la prima volta che il repo introduce un livello dedicato ai widget UI condivisi. Se in futuro emergessero più widget candidati (icone custom, badge, chip specifici), abiteranno la stessa cartella.
- Il fix `safe-area bottom` è recente (commit `6e6c06c`): assicurarsi che venga copiato letteralmente nel body di `Home` al commit 3, insieme al commento esplicativo.
- Dopo il completamento, aggiornare lo status di questa issue a `done` e spuntare le AC del blocco successivo se dipendenti.

## Acceptance criteria

- [X] `AgentBar` vive in `lib/widgets/agent_bar.dart` senza modifiche alla sua API pubblica
- [X] Esiste `test/widgets/agent_bar_test.dart` con test di isolamento sul widget
- [X] `class Home extends StatelessWidget` vive in `lib/features/home/home.dart`
- [X] `lib/app/` e il file `zeimoto_app_shell.dart` sono stati eliminati
- [X] Il router monta `Home` sulla route `AppRoutes.home`
- [X] I test della Home vivono in `test/features/home/home_test.dart` e continuano a coprire l'ordine delle sezioni, la CTA del FAB, il tap sulle card e la regressione safe-area
- [X] Nessun `ZeimotoAppShell` residuo nel repo (`grep_search` pulita in codice e docs)
- [X] Documentazione: `docs/home/home_it.md` + `docs/home/home_en.md` esistono e `docs/architecture/` è aggiornata
- [X] Full test suite verde (77/77 attesi al termine del refactor, più i nuovi test AgentBar)

## Blocked by

Nessuna dipendenza. Tutte le issue prerequisite (A1..A11) sono in stato `done`.
