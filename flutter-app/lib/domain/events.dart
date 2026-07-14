/// Canonical event types for a Bonsai plant.
///
/// Identifiers are in English to match DB storage values, ARB keys, and
/// enum names — see MISSION.md "Convenzioni di implementazione → Vocabolario".
enum EventType {
  repotting,
  pruning,
  wiring,
  pinching,
  defoliation,
  treatment,
  fertilizing,
  observation,
  styling,
}
