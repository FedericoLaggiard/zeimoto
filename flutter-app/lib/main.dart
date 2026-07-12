import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:zeimoto/l10n/app_localizations.dart';

import 'app/zeimoto_app_shell.dart';
import 'core/design/zeimoto_theme.dart';

void main() {
  runApp(const ZeimotoApp());
}

class ZeimotoApp extends StatelessWidget {
  const ZeimotoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Zeimoto',
      debugShowCheckedModeBanner: !kReleaseMode,
      theme: ZeimotoTheme.light,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: const ZeimotoAppShell(),
    );
  }
}
