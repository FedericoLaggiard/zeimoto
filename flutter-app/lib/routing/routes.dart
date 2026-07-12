/// Centralised route path constants for Zeimoto.
///
/// Every navigation call in the app **must** reference these constants
/// instead of hard-coded strings.  Changing a path here is the only edit
/// required — no other file needs to be touched (see ADR-0004).
abstract final class AppRoutes {
  /// Home — [ZeimotoAppShell] with scrollable content and pinned agent bar.
  static const home = '/';

  /// Add Plant wizard — full-page dialog opened from the home FAB.
  static const addPlant = '/add-plant';

  /// Plant detail — a [Plant] object must be passed as `extra`.
  static const plantDetail = '/plant-detail';
}
