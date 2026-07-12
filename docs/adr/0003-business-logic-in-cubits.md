# Business logic lives in Cubits; orchestration-only flows are removed

All business logic — validation, normalisation, orchestration — lives in the Cubit for the feature that owns it. Thin orchestration classes that only delegate to a repository (the former `PlantCreationFlow` pattern) are not introduced; their logic is absorbed into the Cubit.

The `PlantCreationFlow` class was removed during the A4 refactor and its validation and normalisation logic moved into `PlantCreationCubit`. This keeps the business rules co-located with the state machine that enforces them, and makes them testable via direct Cubit unit tests instead of widget pumps.

## Consequences

- A future reader must not reintroduce a `*Flow` or `*UseCase` class unless there is a concrete need (e.g. logic shared across two features). One feature, one Cubit.
- Domain layer (`lib/domain/`) contains only pure data types, repository interfaces, and value-object helpers — no orchestration logic.
