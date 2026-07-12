import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zeimoto/l10n/app_localizations.dart';

import 'core/design/zeimoto_theme.dart';
import 'domain/plants.dart';
import 'routing/app_router.dart';

void main() {
  runApp(const ZeimotoApp());
}

class ZeimotoApp extends StatefulWidget {
  const ZeimotoApp({super.key});

  @override
  State<ZeimotoApp> createState() => _ZeimotoAppState();
}

class _ZeimotoAppState extends State<ZeimotoApp> {
  late final _router = buildAppRouter();

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider<PlantRepository>(
      create: (_) => InMemoryPlantRepository(),
      child: MaterialApp.router(
        title: 'Zeimoto',
        debugShowCheckedModeBanner: !kReleaseMode,
        theme: ZeimotoTheme.light,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        routerConfig: _router,
      ),
    );
  }
}
