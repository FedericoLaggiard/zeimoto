import 'package:flutter/material.dart';
import 'package:zeimoto/widgets/card_button_icon.dart';

class AnimatedCardButton extends StatelessWidget {
  final double width;
  final double height;
  final Animation<double> fade;
  final Animation<Offset> slide;
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  const AnimatedCardButton({
    super.key,
    required this.width,
    required this.height,
    required this.fade,
    required this.slide,
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: fade,
      child: SlideTransition(
        position: slide,
        child: SizedBox(
          width: width,
          height: height,
          child: CardButtonIcon(icon: icon, label: label, onTap: onTap),
        ),
      ),
    );
  }
}
