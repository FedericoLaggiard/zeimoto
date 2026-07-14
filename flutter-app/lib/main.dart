import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zeimoto/l10n/app_localizations.dart';

import 'core/design/zeimoto_theme.dart';
import 'data/db/app_database.dart';
import 'data/repositories/drift_plant_repository.dart';
import 'domain/plants.dart';
import 'routing/app_router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final db = AppDatabase();
  runApp(ZeimotoApp(db: db));
}

class ZeimotoApp extends StatefulWidget {
  const ZeimotoApp({super.key, required this.db});

  final AppDatabase db;

  @override
  State<ZeimotoApp> createState() => _ZeimotoAppState();
}

class _ZeimotoAppState extends State<ZeimotoApp> {
  late final _router = buildAppRouter();

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider<AppDatabase>.value(
      value: widget.db,
      child: RepositoryProvider<PlantRepository>(
        create: (_) => DriftPlantRepository(widget.db),
        child: MaterialApp.router(
          title: 'Zeimoto',
          debugShowCheckedModeBanner: !kReleaseMode,
          theme: ZeimotoTheme.light,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          routerConfig: _router,
        ),
      ),
    );
  }
}
