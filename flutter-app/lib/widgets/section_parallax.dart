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
        final translateY = delta * 124.0 * depth;
        final scale =
            (1.0 - delta.abs() * 0.07 * depth).clamp(0.8, 1.0).toDouble();
        final opacity = (1.0 - delta.abs() * 0.42).clamp(0.5, 1.0).toDouble();

        return Transform(
          alignment: Alignment.center,
          transform: Matrix4.identity()
            ..translate(0.0, translateY)
            ..scale(scale),
          child: Opacity(
            opacity: opacity,
            child: child,
          ),
        );
      },
    );
  }
}
