import 'dart:math';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'wiki_article.dart';
import 'wiki_state.dart';

/// Cubit that selects a random [WikiArticle] from [articles] once and holds it
/// for the lifetime of the home session.
///
/// The random selection is performed in the constructor and never changes,
/// satisfying the "same article until next launch" requirement.
///
/// The [pickIndex] parameter is injectable for deterministic testing; in
/// production the default [Random.nextInt] is used.
///
/// Emits:
/// - [WikiLoaded] with the randomly selected article
class WikiCubit extends Cubit<WikiState> {
  WikiCubit({
    required List<WikiArticle> articles,
    int Function(int max)? pickIndex,
  }) : super(_pick(articles, pickIndex ?? Random().nextInt));

  static WikiState _pick(
    List<WikiArticle> articles,
    int Function(int max) pick,
  ) {
    final article = articles[pick(articles.length)];
    return WikiLoaded(article: article);
  }
}
