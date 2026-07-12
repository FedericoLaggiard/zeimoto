# A1 — App Shell skeleton

Status: done

## Parent

[PLAN.md — App Shell MVP (Issue #3)](../PLAN.md)

## What to build

Creare l'entry point reale sotto `lib/` che monta un `Scaffold` con sfondo washi, un'area scroll verticale vuota e un'agent bar pinned in basso (inerte, nessuna azione). L'attuale `main.dart` che punta al prototipo viene aggiornato per montare questo nuovo shell, senza toccare né cancellare `lib/prototype/`.

La palette e la tipografia di riferimento sono quelle già definite in `lib/prototype/app_shell/shared/design.dart` (`ZeimotoColors`): vanno riportate 1:1 sotto `lib/` in un file `lib/core/design/zeimoto_theme.dart`.

## Acceptance criteria

- [ ] L'app si apre direttamente sullo scheletro dell'App Shell (nessuna schermata intermedia né router verso il prototipo)
- [ ] Lo sfondo usa il colore washi (`ZeimotoColors.washi`)
- [ ] L'agent bar è visibile in fondo allo schermo, pinned, con altezza fissa
- [ ] L'agent bar non fa nulla al tap (inerte)
- [ ] L'area centrale è uno `CustomScrollView` / `ListView` vuoto che scrolla senza coprire l'agent bar
- [ ] `lib/prototype/` esiste ancora intatta
- [ ] Nessun log di debug in produzione (`kReleaseMode` guard o equivalente)

## Blocked by

Nessuno — può partire immediatamente.
