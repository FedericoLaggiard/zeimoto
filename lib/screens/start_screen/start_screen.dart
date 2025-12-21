import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zeimoto/l10n/app_localizations.dart';
import 'package:zeimoto/screens/start_screen/bloc/start_screen_cubit.dart';
import 'package:zeimoto/screens/start_screen/bloc/start_screen_state.dart';
import 'package:zeimoto/screens/start_screen/widgets/start_screen_grid.dart';
import 'package:zeimoto/screens/start_screen/widgets/card_builders.dart';

class StartScreen extends StatelessWidget {
  const StartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => StartScreenCubit(),
      child: const _StartScreenContent(),
    );
  }
}

class _StartScreenContent extends StatefulWidget {
  const _StartScreenContent();

  @override
  State<_StartScreenContent> createState() => _StartScreenContentState();
}

class _StartScreenContentState extends State<_StartScreenContent>
    with TickerProviderStateMixin {
  late final AnimationController _ctrl = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 2),
  );
  late final Animation<double> _fadeGreeting = CurvedAnimation(
    parent: _ctrl,
    curve: const Interval(0.0, 0.2, curve: Curves.easeOut),
  );
  late final Animation<Offset> _slideGreetingFromTop =
      Tween(begin: const Offset(0, -0.15), end: Offset.zero).animate(
    CurvedAnimation(
      parent: _ctrl,
      curve: const Interval(0.0, 0.2, curve: Curves.easeOut),
    ),
  );
  late final Animation<double> _fadeTitle = CurvedAnimation(
    parent: _ctrl,
    curve: const Interval(0.2, 0.4, curve: Curves.easeOut),
  );
  late final Animation<Offset> _slideTitleFromTop =
      Tween(begin: const Offset(0, -0.15), end: Offset.zero).animate(
    CurvedAnimation(
      parent: _ctrl,
      curve: const Interval(0.2, 0.4, curve: Curves.easeOut),
    ),
  );
  late final Animation<double> _fadeCardWork = CurvedAnimation(
    parent: _ctrl,
    curve: const Interval(0.45, 0.60, curve: Curves.easeOut),
  );
  late final Animation<double> _fadeCardTips = CurvedAnimation(
    parent: _ctrl,
    curve: const Interval(0.52, 0.67, curve: Curves.easeOut),
  );
  late final Animation<double> _fadeCardLearn = CurvedAnimation(
    parent: _ctrl,
    curve: const Interval(0.59, 0.74, curve: Curves.easeOut),
  );
  late final Animation<double> _fadeCardGoPlants = CurvedAnimation(
    parent: _ctrl,
    curve: const Interval(0.66, 0.81, curve: Curves.easeOut),
  );
  late final Animation<Offset> _slideCardWorkFromBottom =
      Tween(begin: const Offset(0, 0.2), end: Offset.zero).animate(
    CurvedAnimation(
      parent: _ctrl,
      curve: const Interval(0.45, 0.60, curve: Curves.easeOut),
    ),
  );
  late final Animation<Offset> _slideCardTipsFromBottom =
      Tween(begin: const Offset(0, 0.2), end: Offset.zero).animate(
    CurvedAnimation(
      parent: _ctrl,
      curve: const Interval(0.52, 0.67, curve: Curves.easeOut),
    ),
  );
  late final Animation<Offset> _slideCardLearnFromBottom =
      Tween(begin: const Offset(0, 0.2), end: Offset.zero).animate(
    CurvedAnimation(
      parent: _ctrl,
      curve: const Interval(0.59, 0.74, curve: Curves.easeOut),
    ),
  );
  late final Animation<Offset> _slideCardGoPlantsFromBottom =
      Tween(begin: const Offset(0, 0.2), end: Offset.zero).animate(
    CurvedAnimation(
      parent: _ctrl,
      curve: const Interval(0.66, 0.81, curve: Curves.easeOut),
    ),
  );

  late final AnimationController _jiggle = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 400),
  );
  late final Animation<double> _jiggleAngle = Tween(
    begin: -0.06,
    end: 0.06,
  ).animate(CurvedAnimation(parent: _jiggle, curve: Curves.easeInOut));

  @override
  void initState() {
    super.initState();
    _ctrl.forward();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    _jiggle.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bg = const Color(0xFF8D9D89);
    return BlocListener<StartScreenCubit, StartScreenState>(
      listenWhen: (previous, current) =>
          previous.reorderMode != current.reorderMode,
      listener: (context, state) {
        if (state.reorderMode) {
          _jiggle.repeat(reverse: true);
        } else {
          _jiggle.stop();
          _jiggle.reset();
        }
      },
      child: Scaffold(
        backgroundColor: bg,
        body: SafeArea(
          child: LayoutBuilder(
            builder: (ctx, c) {
              final w = c.maxWidth;
              final h = c.maxHeight;
              final contentW = w * 0.88;
              final titleSize = 35.0;
              final subTitleSize = 30.0;
              final gridSpacing = 16.0;
              final hslBg = HSLColor.fromColor(bg);
              final subTitleColor = hslBg
                  .withLightness((hslBg.lightness + 0.32).clamp(0.0, 1.0))
                  .toColor();
              return Center(
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: contentW),
                  child: SizedBox(
                    height: h,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 28),
                        FadeTransition(
                          opacity: _fadeGreeting,
                          child: SlideTransition(
                            position: _slideGreetingFromTop,
                            child: Text(
                              AppLocalizations.of(context).t('greeting'),
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: titleSize,
                                fontWeight: FontWeight.w600,
                              ),
                              textAlign: TextAlign.left,
                            ),
                          ),
                        ),
                        const SizedBox(height: 4),
                        FadeTransition(
                          opacity: _fadeTitle,
                          child: SlideTransition(
                            position: _slideTitleFromTop,
                            child: Text(
                              AppLocalizations.of(context).t('title'),
                              style: TextStyle(
                                color: subTitleColor,
                                fontSize: subTitleSize,
                                fontWeight: FontWeight.w200,
                              ),
                              textAlign: TextAlign.left,
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Expanded(
                          child: BlocBuilder<StartScreenCubit, StartScreenState>(
                            builder: (context, state) {
                              return StartScreenGrid(
                                order: state.order,
                                reorderMode: state.reorderMode,
                                jiggle: _jiggle,
                                jiggleAngle: _jiggleAngle,
                                bg: bg,
                                gridSpacing: gridSpacing,
                                buildCard: (id, w, h, ctx3) => buildStartCard(
                                  id,
                                  w,
                                  h,
                                  ctx3,
                                  _fadeCardWork,
                                  _slideCardWorkFromBottom,
                                  _fadeCardTips,
                                  _slideCardTipsFromBottom,
                                  _fadeCardLearn,
                                  _slideCardLearnFromBottom,
                                  _fadeCardGoPlants,
                                  _slideCardGoPlantsFromBottom,
                                  enableHero: true,
                                ),
                                buildCardFeedback: (id, w, h, ctx3) =>
                                    buildStartCardFeedback(id, w, h, ctx3),
                                onAccept: (itemId, targetIndex) {
                                  context
                                      .read<StartScreenCubit>()
                                      .itemReordered(itemId, targetIndex);
                                },
                                onDragStarted: () {
                                  context
                                      .read<StartScreenCubit>()
                                      .reorderStarted();
                                },
                                onDragEndOrCancel: () {
                                  context
                                      .read<StartScreenCubit>()
                                      .reorderFinished();
                                },
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
