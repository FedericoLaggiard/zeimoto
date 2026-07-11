# A2 — Dominio Pianta + PlantRepository in-memory

Status: ready-for-agent

## Parent

[PLAN.md — App Shell MVP (Issue #3)](../PLAN.md)

## What to build

Estrarre dal prototipo le entità e le costanti di dominio verso moduli reali sotto `lib/`, senza spostare né modificare alcun file di `lib/prototype/`.

Elementi da creare sotto `lib/domain/`:
- `Plant` — entità core: `id` (UUID v4), `species` (String), `nickname` (String), `coverPhoto` (tipo opaco `PlaceholderPhoto` per questo slice), `createdAt` (DateTime)
- `PlaceholderPhoto` — wrapper deterministico che riproduce la stessa palette del prototipo; il contratto accetta già "una foto scelta" come input opaco, così da non cambiare API quando arriverà la vera camera
- `kSeedSpecies` — lista predefinita di specie (identica al prototipo)
- `defaultNickname(species, existingCount)` — funzione pura che restituisce `<ultimoTokenSpecie>_<NN>` con `NN` progressivo a due cifre
- `PlantRepository` — interfaccia (aggiunge una pianta, restituisce la lista ordinata per `createdAt` decrescente)
- `InMemoryPlantRepository` — implementazione con seed identico al prototipo

Nessuna UI dipende ancora da questi tipi in questa issue.

## Acceptance criteria

- [ ] `Plant`, `PlaceholderPhoto`, `kSeedSpecies`, `defaultNickname` vivono sotto `lib/domain/` (o sotto-cartella coerente) e non sotto `lib/prototype/`
- [ ] `PlantRepository` è un'interfaccia (abstract class / interfaccia Dart); l'`InMemoryPlantRepository` la implementa
- [ ] `defaultNickname` con specie `"Acer palmatum"` e `existingCount=2` restituisce `"palmatum_03"`
- [ ] `defaultNickname` con nickname non vuoto/whitespace restituisce il nickname fornito invariato
- [ ] `InMemoryPlantRepository` espone le piante ordinate per `createdAt` decrescente (la più recente prima)
- [ ] I test di unità coprono `defaultNickname` (casi: specie multi-token, specie mono-token, nickname esplicito, nickname whitespace) e l'ordinamento del repository
- [ ] `lib/prototype/` esiste ancora intatta

## Blocked by

[01-app-shell-skeleton.md](./01-app-shell-skeleton.md)
