import 'package:flutter/material.dart';

class StartScreenGrid extends StatelessWidget {
  final List<int> order;
  final bool reorderMode;
  final AnimationController jiggle;
  final Animation<double> jiggleAngle;
  final Color bg;
  final double gridSpacing;
  final Widget Function(int id, double w, double h, BuildContext context) buildCard;
  final Widget Function(int id, double w, double h, BuildContext context) buildCardFeedback;
  final void Function(int itemId, int targetIndex) onAccept;
  final VoidCallback onDragStarted;
  final VoidCallback onDragEndOrCancel;

  const StartScreenGrid({
    super.key,
    required this.order,
    required this.reorderMode,
    required this.jiggle,
    required this.jiggleAngle,
    required this.bg,
    required this.gridSpacing,
    required this.buildCard,
    required this.buildCardFeedback,
    required this.onAccept,
    required this.onDragStarted,
    required this.onDragEndOrCancel,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (ctx2, c2) {
        final colW = (c2.maxWidth - gridSpacing) / 2;
        final cardH = colW;
        return Stack(
          children: [
            GridView.builder(
              padding: const EdgeInsets.only(bottom: 120, top: 40),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: gridSpacing,
                crossAxisSpacing: gridSpacing,
                childAspectRatio: colW / cardH,
              ),
              itemCount: order.length,
              itemBuilder: (ctxItem, i) {
                final id = order[i];
                return DragTarget<int>(
                  onWillAcceptWithDetails: (details) => details.data != id,
                  onAcceptWithDetails: (details) => onAccept(details.data, i),
                  builder: (ctxDrop, candidates, rejected) {
                    final baseChild = buildCard(id, colW, cardH, context);
                    final child = reorderMode
                        ? AnimatedBuilder(
                            animation: jiggle,
                            builder: (ctxAnim, _) => Transform.rotate(
                              angle: jiggleAngle.value,
                              child: baseChild,
                            ),
                          )
                        : baseChild;
                    return LongPressDraggable<int>(
                      data: id,
                      feedback: Material(
                        color: Colors.transparent,
                        child: buildCardFeedback(id, colW, cardH, context),
                      ),
                      onDragStarted: onDragStarted,
                      onDragEnd: (_) => onDragEndOrCancel(),
                      onDraggableCanceled: (velocity, offset) => onDragEndOrCancel(),
                      childWhenDragging: Opacity(opacity: 0.3, child: child),
                      child: child,
                    );
                  },
                );
              },
            ),
            IgnorePointer(
              ignoring: true,
              child: Align(
                alignment: Alignment.topCenter,
                child: Container(
                  height: 30,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        bg,
                        bg.withValues(alpha: 0.0),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
