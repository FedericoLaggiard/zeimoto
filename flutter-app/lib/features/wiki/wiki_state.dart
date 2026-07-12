import 'wiki_article.dart';

/// All states emitted by [WikiCubit].
sealed class WikiState {
  const WikiState();
}

/// An article has been selected and is ready to display.
final class WikiLoaded extends WikiState {
  const WikiLoaded({required this.article});

  final WikiArticle article;
}
