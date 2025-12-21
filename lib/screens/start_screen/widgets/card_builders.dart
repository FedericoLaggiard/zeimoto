import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:zeimoto/l10n/app_localizations.dart';
import 'package:zeimoto/screens/start_screen/widgets/animated_card_button.dart';

Widget buildStartCard(
  int id,
  double w,
  double h,
  BuildContext context,
  Animation<double> fadeWork,
  Animation<Offset> slideWork,
  Animation<double> fadeTips,
  Animation<Offset> slideTips,
  Animation<double> fadeLearn,
  Animation<Offset> slideLearn,
  Animation<double> fadeGoPlants,
  Animation<Offset> slideGoPlants, {
  bool enableHero = false,
}) {
  switch (id) {
    case 0:
      return AnimatedCardButton(
        width: w,
        height: h,
        fade: fadeWork,
        slide: slideWork,
        icon: Icons.handyman,
        label: AppLocalizations.of(context).t('btn_work'),
        onTap: () => context.go('/add-wizard'),
        heroTag: enableHero ? 'work_wizard_icon' : null,
      );
    case 1:
      return AnimatedCardButton(
        width: w,
        height: h,
        fade: fadeTips,
        slide: slideTips,
        icon: Icons.event_note,
        label: AppLocalizations.of(context).t('btn_tips'),
        onTap: () {},
        heroTag: enableHero ? 'tips_icon' : null,
      );
    case 2:
      return AnimatedCardButton(
        width: w,
        height: h,
        fade: fadeLearn,
        slide: slideLearn,
        icon: Icons.menu_book,
        label: AppLocalizations.of(context).t('btn_learn'),
        onTap: () {},
        heroTag: enableHero ? 'learn_icon' : null,
      );
    case 3:
      return AnimatedCardButton(
        width: w,
        height: h,
        fade: fadeGoPlants,
        slide: slideGoPlants,
        icon: Icons.local_florist,
        label: AppLocalizations.of(context).t('btn_go_plants'),
        onTap: () => context.go('/plants'),
        heroTag: enableHero ? 'go_plants_icon' : null,
      );
    case 4:
      return AnimatedCardButton(
        width: w,
        height: h,
        fade: fadeGoPlants,
        slide: slideGoPlants,
        icon: Icons.settings,
        label: AppLocalizations.of(context).t('btn_settings'),
        onTap: () {},
        heroTag: enableHero ? 'settings_icon' : null,
      );
    case 5:
      return AnimatedCardButton(
        width: w,
        height: h,
        fade: fadeGoPlants,
        slide: slideGoPlants,
        icon: Icons.photo_library,
        label: AppLocalizations.of(context).t('btn_gallery'),
        onTap: () {},
        heroTag: enableHero ? 'gallery_icon' : null,
      );
    case 6:
      return AnimatedCardButton(
        width: w,
        height: h,
        fade: fadeGoPlants,
        slide: slideGoPlants,
        icon: Icons.calendar_today,
        label: AppLocalizations.of(context).t('btn_calendar'),
        onTap: () {},
        heroTag: enableHero ? 'calendar_icon' : null,
      );
    case 7:
    default:
      return AnimatedCardButton(
        width: w,
        height: h,
        fade: fadeGoPlants,
        slide: slideGoPlants,
        icon: Icons.help_outline,
        label: AppLocalizations.of(context).t('btn_help'),
        onTap: () {},
        heroTag: enableHero ? 'help_icon' : null,
      );
  }
}

Widget buildStartCardFeedback(
  int id,
  double w,
  double h,
  BuildContext context,
) {
  const fade = AlwaysStoppedAnimation<double>(1.0);
  const slide = AlwaysStoppedAnimation<Offset>(Offset.zero);
  return buildStartCard(
    id,
    w,
    h,
    context,
    fade,
    slide,
    fade,
    slide,
    fade,
    slide,
    fade,
    slide,
    enableHero: false,
  );
}
