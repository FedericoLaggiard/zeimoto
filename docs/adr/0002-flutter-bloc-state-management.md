# flutter_bloc as the state-management seam

We use `flutter_bloc` (Cubit variant) as the single state-management mechanism across all Flutter features. `PlantRepository` and other shared repositories are provided at the root of the widget tree via `RepositoryProvider` (in `main.dart`) so every route can access them without explicit prop-drilling. Feature cubits are created via `BlocProvider` at the feature's entry widget.

MISSION.md already committed to "Bloc state management" as the frontend approach. This ADR formalises the choice of `flutter_bloc` as the concrete library and `RepositoryProvider` as the injection pattern for shared repositories.

## Considered options

- `provider` / `riverpod`: not chosen because `flutter_bloc` aligns with the Cubit-centred design where state transitions are explicit named methods, not reactive dependencies.
- Manual constructor injection: rejected because it requires prop-drilling or passing repositories through route `settings`, which breaks when routes are pushed programmatically.
