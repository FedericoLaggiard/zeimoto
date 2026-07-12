import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/design/zeimoto_theme.dart';
import '../../l10n/app_localizations.dart';
import 'wiki_article.dart';
import 'wiki_cubit.dart';
import 'wiki_state.dart';

/// WikiDelGiornoSection — feature entry widget for the wiki-of-the-day display.
///
/// Builds the mock article list from localised strings, creates a [WikiCubit]
/// via [BlocProvider] (so the random selection is made once and held for the
/// entire home session), and delegates rendering to [_WikiView].
///
/// [pickIndex] is injectable for testing; production uses [Random.nextInt].
class WikiDelGiornoSection extends StatelessWidget {
  const WikiDelGiornoSection({super.key, this.pickIndex});

  final int Function(int max)? pickIndex;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final articles = <WikiArticle>[
      WikiArticle(title: l10n.wiki_article_1_title, body: l10n.wiki_article_1_body),
      WikiArticle(title: l10n.wiki_article_2_title, body: l10n.wiki_article_2_body),
      WikiArticle(title: l10n.wiki_article_3_title, body: l10n.wiki_article_3_body),
      WikiArticle(title: l10n.wiki_article_4_title, body: l10n.wiki_article_4_body),
      WikiArticle(title: l10n.wiki_article_5_title, body: l10n.wiki_article_5_body),
    ];

    return BlocProvider(
      create: (_) => WikiCubit(
        articles: articles,
        pickIndex: pickIndex ?? Random().nextInt,
      ),
      child: const _WikiView(),
    );
  }
}

// ---------------------------------------------------------------------------
// Internal view — consumes WikiCubit
// ---------------------------------------------------------------------------

class _WikiView extends StatelessWidget {
  const _WikiView();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WikiCubit, WikiState>(
      builder: (context, state) {
        return switch (state) {
          WikiLoaded(article: final article) => _WikiCard(article: article),
        };
      },
    );
  }
}

// ---------------------------------------------------------------------------
// Card widget
// ---------------------------------------------------------------------------

class _WikiCard extends StatelessWidget {
  const _WikiCard({required this.article});

  final WikiArticle article;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 8),
      child: Container(
        padding: const EdgeInsets.all(22),
        decoration: BoxDecoration(
          color: ZeimotoColors.charcoal,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Badge row
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.menu_book_outlined,
                    color: ZeimotoColors.sage,
                    size: 16,
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  l10n.wiki_reading_label,
                  style: const TextStyle(
                    fontSize: 9,
                    letterSpacing: 2.2,
                    fontWeight: FontWeight.w600,
                    color: ZeimotoColors.sage,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Article title
            Text(
              article.title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w300,
                color: Colors.white,
                height: 1.3,
              ),
            ),
            const SizedBox(height: 10),
            // Article body
            Text(
              article.body,
              style: TextStyle(
                fontSize: 13,
                height: 1.5,
                color: Colors.white.withValues(alpha: 0.65),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
