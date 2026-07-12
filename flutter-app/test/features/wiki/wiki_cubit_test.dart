import 'package:flutter_test/flutter_test.dart';
import 'package:zeimoto/features/wiki/wiki_article.dart';
import 'package:zeimoto/features/wiki/wiki_cubit.dart';
import 'package:zeimoto/features/wiki/wiki_state.dart';

// ---------------------------------------------------------------------------
// Fixtures
// ---------------------------------------------------------------------------

const _articleA = WikiArticle(title: 'Nebari', body: 'Come sviluppare...');
const _articleB = WikiArticle(title: 'Potatura', body: 'Principi guida...');
const _articleC = WikiArticle(title: 'Rinvaso', body: 'Finestre temporali...');

// ---------------------------------------------------------------------------
// Tests
// ---------------------------------------------------------------------------

void main() {
  group('WikiCubit', () {
    test('initial state is WikiLoaded with article at index returned by pickIndex',
        () {
      final cubit = WikiCubit(
        articles: const [_articleA, _articleB, _articleC],
        pickIndex: (_) => 1,
      );

      expect(cubit.state, isA<WikiLoaded>());
      expect((cubit.state as WikiLoaded).article, _articleB);
    });

    test('pickIndex receives articles.length as upper bound', () {
      int capturedMax = -1;
      WikiCubit(
        articles: const [_articleA, _articleB, _articleC],
        pickIndex: (max) {
          capturedMax = max;
          return 0;
        },
      );

      expect(capturedMax, 3);
    });

    test('state does not change after initial selection (single call to pickIndex)',
        () {
      var callCount = 0;
      final cubit = WikiCubit(
        articles: const [_articleA, _articleB],
        pickIndex: (max) {
          callCount += 1;
          return 0;
        },
      );

      final firstState = cubit.state;

      // Additional reads must not trigger another pick
      expect(cubit.state, same(firstState));
      expect(callCount, 1);
    });

    test('selects first article when pickIndex returns 0', () {
      final cubit = WikiCubit(
        articles: const [_articleA, _articleB],
        pickIndex: (_) => 0,
      );

      expect((cubit.state as WikiLoaded).article, _articleA);
    });

    test('uses Random pick when pickIndex is omitted (smoke test)', () {
      // Smoke: no assertion on which article is picked, just no exception thrown.
      final cubit = WikiCubit(
        articles: const [_articleA, _articleB, _articleC],
      );

      expect(cubit.state, isA<WikiLoaded>());
    });
  });
}
