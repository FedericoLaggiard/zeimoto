# Domain Docs

Come le skill devono consumare la documentazione di dominio quando esplorano il repo.

## Prima di esplorare, leggi questi

- `src/zeimoto/MISSION.md` (documento sorgente di visione, perimetro e modellazione MVP)
- `CONTEXT.md` al root, se esiste
- `CONTEXT-MAP.md` al root, se esiste (multi-contesto)
- `docs/adr/`, se esiste (decisioni architetturali)

Se `CONTEXT.md` / `docs/adr/` non esistono, procedi senza segnalarlo.

## Struttura

Repo single-context.

## Convenzione nomi file di documentazione

I file di documentazione per feature devono seguire il pattern `<nome_feature>_<lingua>.md`.

Esempi corretti:
- `docs/add_plant/add_plant_en.md`
- `docs/routing/routing_it.md`
- `docs/i18n/i18n_en.md`

Non usare nomi generici come `feature_en.md` o `feature_it.md`.

La lingua si esprime con il codice ISO 639-1 (`en`, `it`).

## Vocabolario

Usa la terminologia definita in `src/zeimoto/MISSION.md` (es. Pianta, Evento, Work Session, Timeline, Synthetic Memory, Active State, Task Engine, Quick Actions).

Se serve un concetto non presente, annotalo per una sessione `/grill-with-docs` (non creare nuova documentazione “a vuoto”).
