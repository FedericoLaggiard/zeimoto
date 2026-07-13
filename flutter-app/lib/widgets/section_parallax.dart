import 'package:flutter/material.dart';

/// Wraps a [child] with a parallax effect driven by a [PageController].
///
/// The animation reacts to how far the page at [pageIndex] is from the
/// viewport centre, applying translation, scale, and opacity in a way that
/// mirrors the Zeimoto prototype (Variant C).
///
/// Intended to be used inside [HomePager] — each page slot wraps its title
/// and content widgets independently with different [depth] values:
/// - title: depth `1.35` (moves faster → stronger parallax)
/// - content: depth `0.85` (moves slower → subtler parallax)
///
/// This widget is intentionally free of BLoC / routing / l10n dependencies.
class SectionParallax extends StatelessWidget {
  const SectionParallax({
    super.key,
    required this.pageController,
    required this.pageIndex,
    required this.depth,
    required this.child,
  });

  final PageController pageController;
  final int pageIndex;
  final double depth;
  final Widget child;

  /// Pixels translated per page-delta per depth unit (prototype Variant C).
  static const double _kTranslateMultiplier = 124.0;

  /// Scale reduction per unit |delta| per depth unit.
  static const double _kScaleReductionRate = 0.07;

  /// Opacity reduction per unit |delta| (depth-independent).
  static const double _kOpacityReductionRate = 0.42;

  /// Minimum scale — prevents a page from fully collapsing.
  static const double _kMinScale = 0.8;

  /// Minimum opacity — keeps off-screen pages faintly visible.
  static const double _kMinOpacity = 0.5;

  double _delta() {
    if (!pageController.hasClients) return 0.0;
    final page = pageController.page ?? pageController.initialPage.toDouble();
    return page - pageIndex;
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: pageController,
      builder: (context, _) {
        final delta = _delta();
        final translateY = delta * _kTranslateMultiplier * depth;
        final scale = (1.0 - delta.abs() * _kScaleReductionRate * depth)
            .clamp(_kMinScale, 1.0)
            .toDouble();
        final opacity =
            (1.0 - delta.abs() * _kOpacityReductionRate)
                .clamp(_kMinOpacity, 1.0)
                .toDouble();

        return Transform(
          alignment: Alignment.center,
          transform: Matrix4.identity()
            ..translate(0.0, translateY)
            ..scale(scale),
          child: Opacity(opacity: opacity, child: child),
        );
      },
    );
  }
}
