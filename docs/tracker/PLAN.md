# PLAN — App Shell MVP (Issue #3): attività da eseguire

Status: ready-for-agent

Documento derivato dal prototipo `flutter-app/lib/prototype/app_shell/` (Variant C promossa: home a 5 sezioni scroll + agent bar pinned + wizard Nuova Pianta 3 step) e da `MISSION.md`. Traduce il PRD in una pianificazione operativa incrementale.

## Problem Statement

Il prototipo Variant C mostra la direzione UX vincente (home operativa scroll a 5 sezioni con agent bar pinned e wizard Foto → Specie → Nickname), ma vive interamente sotto `lib/prototype/` con store in-memory, foto placeholder e zero test. In questo stato non è codice MVP: non ha separazione UI/dominio, non ha seam testabili, non ha persistenza, e non è integrato con il resto del futuro app shell. Serve un piano che porti il concept da prototipo throwaway a baseline MVP stabile senza allargare lo scope oltre l'App Shell.

## Solution

Un piano incrementale di attività verticali, ognuna piccola e completa, che:

- estrae il dominio Pianta e il flusso di creazione dal prototipo in moduli reali sotto `lib/`
- ricostruisce la home a 5 sezioni + agent bar come App Shell reale, riusando i pattern visivi ma non il codice del prototipo
- introduce un unico seam principale (Plant Creation Flow) su cui appoggiare la maggior parte dei test
- introduce un seam secondario minimo (Home Section Composition) solo per le CTA di navigazione
- lascia la persistenza a uno slice successivo, mantenendo un contratto stabile

## User Stories

1. Come utente, voglio aprire l'app e atterrare direttamente sulla home operativa, così da non passare da schermate intermedie.
2. Come utente, voglio scorrere la home in verticale e vedere le 5 sezioni (Assistente AI, Collezione, Calendario, Focus Pianta, Wiki del Giorno) nell'ordine del prototipo, così da avere continuità con quanto già validato.
3. Come utente, voglio una agent bar sempre visibile in basso con il campo "Cosa vuoi fare oggi?", così da lanciare azioni da qualsiasi sezione.
4. Come utente, voglio avviare "Nuova Pianta" dall'agent bar, così da entrare nel wizard senza cercare menu.
5. Come utente, voglio un wizard Nuova Pianta a 3 step (Foto → Specie → Nickname), così da seguire un flusso photo-first coerente con la memoria evolutiva.
6. Come utente, voglio che il pulsante di avanzamento resti disabilitato finché non ho scelto una foto, così da non poter creare Piante senza base visiva.
7. Come utente, voglio che il pulsante di avanzamento resti disabilitato finché non ho scelto una specie, così da non poter salvare Piante non contestualizzabili.
8. Come utente, voglio poter scegliere la specie da una lista predefinita, così da essere veloce nel caso comune.
9. Come utente, voglio poter inserire una specie manualmente, così da non essere bloccato quando manca dall'elenco.
10. Come utente, voglio lasciare vuoto il nickname e ottenere un default automatico tipo `palmatum_03`, così da non interrompere il flusso.
11. Come utente, voglio poter chiudere il wizard in ogni step, così da mantenere il controllo.
12. Come utente, voglio che appena salvo la Pianta la ritrovi in cima al carosello Collezione, così da avere conferma immediata dell'esito.
13. Come utente, voglio aprire il dettaglio Pianta tappando una card della Collezione, così da entrare nel contesto in un tap.
14. Come utente, voglio aprire il dettaglio Pianta anche dalla sezione Focus Pianta, così da approfondire ciò su cui la home mi guida.
15. Come utente, voglio che la sezione Calendario mostri eventi passati e task suggeriti come blocchi distinti, così da distinguere ciò che è stato fatto da ciò che è solo proposto.
16. Come utente, voglio che la sezione Wiki del Giorno mostri un articolo pescato all'apertura, così da avere apprendimento contestuale senza sforzo.
17. Come utente, voglio che l'app abbia il linguaggio visuale del prototipo (washi, verde salvia, carbone, spazi ampi, foto protagoniste), così da percepire l'identità del prodotto fin da subito.
18. Come utente, voglio che nulla dell'app suggerisca autonomia AI totale, così da mantenere il mio ruolo decisionale.
19. Come team prodotto, vogliamo un unico seam Plant Creation Flow che espone comportamento osservabile end-to-end, così da concentrare i test lì.
20. Come team prodotto, vogliamo separare lo stato di presentazione (sezione corrente, step wizard) dallo stato di dominio (lista Piante, regole di creazione), così da poter testare le regole senza rendering.
21. Come team prodotto, vogliamo componenti UI condivisi (target foto, picker specie, card pianta, agent bar), così da evitare divergenza tra sezioni.
22. Come team prodotto, vogliamo eliminare `lib/prototype/` una volta promossi i pattern vincenti, così da non avere due sorgenti di verità.
23. Come team prodotto, vogliamo che ogni attività del piano sia rilasciabile in isolamento e verificabile, così da procedere per tracer bullet.

## Implementation Decisions

### Decisioni strutturali

- **Variant vincente**: Variant C del prototipo (home scroll a 5 sezioni + agent bar pinned + wizard 3 step) è la baseline strutturale.
- **Non promuovere codice prototipo**: nessun file di `lib/prototype/` viene spostato o rinominato; i pattern vincenti vengono re-implementati sotto `lib/` reale con separazione UI/dominio e con test.
- **Cleanup finale**: `lib/prototype/` viene rimosso solo quando tutte le attività di questo piano sono chiuse e la sezione "Verdict" delle NOTES è compilata.

### Decisioni di dominio

- **Entità core dell'App Shell**: `Pianta` (id, specie, nickname, cover foto, timestamp creazione). Nessuna altra entità di dominio è nel perimetro di questo piano.
- **Foto in questo slice**: rimane placeholder deterministico (stessa palette del prototipo). Integrazione camera/import è fuori scope, ma il contratto del flow accetta già "una foto scelta" come input opaco, così da non cambiare API quando arriverà la vera camera.
- **Specie**: pool predefinito (stesso del prototipo, `kSeedSpecies`) + inserimento manuale.
- **Nickname**: se assente, default `<ultimoTokenSpecie>_<NN>` con `NN` progressivo a due cifre.
- **Regole obbligatorie MVP**: foto obbligatoria, specie obbligatoria, nickname opzionale.

### Decisioni di stato

- **Stato di dominio**: un `PlantRepository` (interfaccia) + implementazione in-memory in questo slice; l'App Shell dipende dall'interfaccia, non dall'implementazione.
- **Stato di presentazione**: sezione home corrente, indice carosello, step wizard, valori parziali del wizard — tenuti locali al widget/blocco corrispondente, mai mescolati con il repository.
- **Nessuna persistenza reale** in questo piano; il repository in-memory è sostituibile in uno slice futuro senza cambiare il contratto.

### Decisioni sui seam (test surface)

- **Seam principale — Plant Creation Flow**: unico punto in cui si osserva end-to-end il comportamento del wizard (avanzamento gated, salvataggio, default nickname, effetto sul repository). Tutti i test comportamentali del wizard passano da qui.
- **Seam secondario — Home Section Composition**: verifica solo che le 5 sezioni siano presenti nell'ordine atteso e che le CTA critiche (agent bar → wizard, card Collezione → dettaglio, Focus Pianta → dettaglio) portino dove devono. Nessun altro seam per sezione.
- **Anti-pattern esplicito**: non aggiungere seam separati per Assistente AI, Calendario, Wiki finché il loro contenuto è statico/mock — non c'è comportamento osservabile da isolare.

### Decisioni UX / design

- **Palette e tipografia**: identiche al prototipo (`ZeimotoColors` in `shared/design.dart`) — vengono riportate 1:1 sotto `lib/` reale, senza rinominare per non introdurre drift.
- **Agent bar**: sempre pinned in basso, altezza fissa; la home scrolla sotto senza coprirla.
- **Wizard**: full-page 3 step con progress indicator; chiudibile in ogni step.
- **Copy**: usa il vocabolario di `MISSION.md` (Pianta, Collezione, Focus Pianta, Wiki, task suggeriti). Nessun copy che suggerisca AI autonoma.

### Piano attività (tracer bullet, ognuna è un incremento verticale rilasciabile)

Le attività sono ordinate per dipendenza; ognuna dovrebbe diventare una issue implementativa separata sotto `docs/tracker/issues/`.

1. **A1 — Scheletro App Shell reale**: creare l'entry point `lib/` che monta un `Scaffold` con background washi, area scroll vuota e agent bar pinned inerte. Sostituisce l'attuale entry che punta al prototipo (senza cancellare `lib/prototype/`). Verifica: l'app si apre sullo scheletro, l'agent bar è visibile ma non fa nulla.
2. **A2 — Dominio Pianta + PlantRepository in-memory**: estrarre `Plant`, `PlaceholderPhoto`, `kSeedSpecies`, `defaultNickname` dal prototipo verso `lib/` reale, definire `PlantRepository` come interfaccia, fornire `InMemoryPlantRepository` con seed identico al prototipo. Nessuna UI tocca ancora questi tipi.
3. **A3 — Seam Plant Creation Flow (headless)**: implementare il flow di creazione come componente osservabile senza UI (input: foto scelta, specie, nickname opzionale; output: Pianta creata nel repository; regole: gate foto/specie, default nickname). Coperto da test di comportamento (invarianti MVP dal PRD).
4. **A4 — Wizard UI 3 step collegato al seam**: full-page wizard Foto → Specie → Nickname che consuma il seam A3. Pulsante avanti/salva disabilitato secondo gate. Chiusura possibile in ogni step. Nessuna logica di dominio nel widget.
5. **A5 — Sezione Collezione (carosello)**: sezione home che legge da `PlantRepository` e mostra il carosello di card come nel prototipo. Tap su card apre placeholder di dettaglio (una schermata minima che mostra nickname + specie).
6. **A6 — Agent bar operativa**: campo "Cosa vuoi fare oggi?" con CTA che apre il wizard A4. Il testo inserito viene ignorato in questo slice (nessuna intent detection); resta l'affordance visuale.
7. **A7 — Sezione Assistente AI (statica)**: card/blocco con contenuto mock (stesso testo del prototipo), nessun comportamento dinamico. Serve solo a fissare la struttura visiva.
8. **A8 — Sezione Calendario (statica, eventi vs task)**: due liste distinte, dati mock come nel prototipo, nessuna interazione. Fissa la distinzione visiva tra "già fatto" e "solo suggerito".
9. **A9 — Sezione Focus Pianta**: pesca casuale da `PlantRepository` all'apertura della home; tap apre lo stesso dettaglio placeholder di A5.
10. **A10 — Sezione Wiki del Giorno**: pesca casuale dall'elenco articoli mock del prototipo; contenuto statico.
11. **A11 — Composizione Home + navigazione end-to-end**: mette insieme A5–A10 nell'ordine del prototipo dentro lo scroll di A1, verifica che l'agent bar resti pinned, copre il seam Home Section Composition con test sulle CTA critiche (agent bar → wizard, card → dettaglio, Focus Pianta → dettaglio).
12. **A12 — Rifiniture MVP**: stati vuoti (Collezione vuota, Focus Pianta assente), stati disabled del wizard, feedback di salvataggio (snackbar o transizione). Nessuna nuova sezione.
13. **A13 — Retiro prototipo**: compilare la sezione "Verdict" di `flutter-app/lib/prototype/app_shell/NOTES.md`, poi rimuovere `lib/prototype/` e ogni riferimento residuo. Ultima attività, blocca il chiusura del piano.

## Testing Decisions

- **Cosa è un buon test qui**: verifica un comportamento osservabile dall'utente (o dal repository) attraverso un seam, non la struttura interna di un widget.
- **Copertura seam principale (Plant Creation Flow, attività A3 + A4)**:
  - non è possibile completare il flow senza aver scelto una foto
  - non è possibile completare il flow senza aver scelto una specie
  - il nickname viene generato con il pattern `<ultimoTokenSpecie>_<NN>` quando l'input è vuoto o solo whitespace
  - una Pianta creata compare in cima alla lista esposta dal `PlantRepository`
- **Copertura seam secondario (Home Section Composition, attività A11)**:
  - le 5 sezioni sono presenti nell'ordine atteso
  - la CTA dell'agent bar apre il wizard
  - il tap su una card della Collezione apre il dettaglio della Pianta corrispondente
  - il tap sulla card Focus Pianta apre il dettaglio della Pianta selezionata
- **Prior art**: usare `flutter_test` (già in `dev_dependencies` di `pubspec.yaml`); nessun harness custom. Widget test per il seam secondario, test puri (senza `WidgetTester`) sul seam principale dove possibile.
- **Non testare**: contenuto statico di Assistente AI, Calendario, Wiki del Giorno (in questo slice non hanno comportamento).

## Out of Scope

- Camera reale, import da galleria, permessi di sistema (le foto restano placeholder in questo piano).
- Persistenza reale (Isar o altro): il `PlantRepository` è in-memory; l'introduzione di persistenza è uno slice successivo che deve mantenere il contratto.
- Modello Evento, Timeline, Work Session, Task Engine, Wiki con contenuti reali, chat AI, Confidence Layer, memoria AI, calendario intelligente.
- Retrieval, embeddings, backend Supabase/pgvector, BYOK provider AI.
- Dettaglio Pianta ricco (in questo piano è un placeholder minimo che serve solo alle CTA di navigazione).
- Localizzazione, accessibilità avanzata, animazioni oltre a quelle di default di `PageView`/scroll.

## Further Notes

- L'ordine A1 → A13 è una dipendenza reale, non una preferenza. In particolare A3 deve precedere A4, A2 deve precedere A3, e A13 chiude il piano.
- Ogni attività dovrebbe generare una issue separata sotto `docs/tracker/issues/<NN>-<slug>.md`. La creazione delle issue non fa parte di questo piano — è compito della skill `to-issues`.
- La filosofia di prodotto (`MISSION.md`: "l'app osserva, suggerisce e ricorda — ma non sostituisce") deve essere leggibile in ogni copy: nessuna frase che dia all'AI un ruolo decisionale.
