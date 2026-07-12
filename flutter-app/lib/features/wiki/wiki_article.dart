/// A wiki article with a [title] and a [body].
///
/// Used by [WikiCubit] as the unit of content for the "Wiki del Giorno" section.
/// Articles are immutable value objects; equality is structural.
final class WikiArticle {
  const WikiArticle({required this.title, required this.body});

  final String title;
  final String body;

  @override
  bool operator ==(Object other) =>
      other is WikiArticle && other.title == title && other.body == body;

  @override
  int get hashCode => Object.hash(title, body);
}
