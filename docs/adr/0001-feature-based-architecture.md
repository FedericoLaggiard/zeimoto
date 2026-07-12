# Feature-based architecture under `lib/features/`

All Flutter features live under `lib/features/<feature-name>/`. Each feature folder is self-contained: its cubit, state, and widgets are private to the feature. Shared domain types (entities, repository interfaces) live under `lib/domain/`. Infrastructure adapters (e.g. `InMemoryPlantRepository`) live under `lib/domain/` until a dedicated `lib/infrastructure/` layer is warranted.

This boundary was set explicitly during the A4 architecture session to ensure each feature can be worked on, tested, and reasoned about in isolation. Moving files outside `lib/features/<name>/` or creating cross-feature widget dependencies contradicts this decision.
