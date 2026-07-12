# A13 — Retiro prototipo

Status: done

## Parent

[PLAN.md — App Shell MVP (Issue #3)](../PLAN.md)

## What to build

Questa è l'unica issue HITL del piano: richiede intervento umano prima di procedere con la rimozione irreversibile di `lib/prototype/`.

Passaggi:

1. **Compilare la sezione "Verdict"** di `flutter-app/lib/prototype/app_shell/NOTES.md` — il maintainer deve confermare che tutti i pattern vincenti del prototipo (Variant C) sono stati re-implementati e testati nelle issue A1–A12 e che nessun artefatto del prototipo è ancora necessario come riferimento.

2. **Rimuovere `lib/prototype/`** e ogni riferimento residuo (import, commenti, file di configurazione) dal codice sorgente.

3. Verificare che `flutter test` continui a passare dopo la rimozione.

⚠️ Non eseguire la rimozione senza aver compilato il Verdict. La cancellazione è irreversibile (a meno di `git`).

## Acceptance criteria

- [x] La sezione "Verdict" di `flutter-app/lib/prototype/app_shell/NOTES.md` è compilata e firmata dal maintainer
- [x] `lib/prototype/` è stata rimossa dal repository
- [x] Nessun import o riferimento a `lib/prototype/` esiste nel codice sotto `lib/`
- [x] `flutter test` passa senza errori dopo la rimozione (83/83)
- [x] `flutter analyze` non riporta warning relativi alla rimozione

## Blocked by

[12-rifiniture-mvp.md](./12-rifiniture-mvp.md)
