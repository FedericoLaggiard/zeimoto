import 'plants.dart';

/// Maximum accepted length for a user-supplied nickname.
const _kNicknameMaxLength = 100;

/// Orchestrates plant creation: validates inputs, normalises the nickname,
/// and delegates persistence to [PlantRepository].
///
/// Throws [ArgumentError] if [cover] is null, [species] is blank, or the
/// supplied [nickname] fails validation.
/// Never logs or exposes sensitive data.
class PlantCreationFlow {
  PlantCreationFlow(this._repository);

  final PlantRepository _repository;

  Plant execute({
    required PlaceholderPhoto? cover,
    required String species,
    String? nickname,
  }) {
    if (cover == null) {
      throw ArgumentError.notNull('cover');
    }
    if (species.trim().isEmpty) {
      throw ArgumentError.value(species, 'species', 'must not be blank');
    }

    // Normalise nickname: null/blank → null (repository generates the default);
    // non-blank → trimmed and validated.
    final normalised = _normalizeNickname(nickname);

    return _repository.add(
      species: species,
      nickname: normalised,
      cover: cover,
    );
  }

  /// Returns [null] when [raw] is absent or blank so the repository can
  /// generate a default.  Trims whitespace from a non-blank value, then
  /// rejects values that exceed [_kNicknameMaxLength] or contain control
  /// characters (U+0000–U+001F, U+007F).
  static String? _normalizeNickname(String? raw) {
    if (raw == null || raw.trim().isEmpty) return null;

    final trimmed = raw.trim();
    if (trimmed.length > _kNicknameMaxLength) {
      throw ArgumentError.value(
        raw,
        'nickname',
        'must be at most $_kNicknameMaxLength characters',
      );
    }
    if (trimmed.contains(RegExp(r'[\x00-\x1F\x7F]'))) {
      throw ArgumentError.value(
        raw,
        'nickname',
        'must not contain control characters',
      );
    }
    return trimmed;
  }
}
