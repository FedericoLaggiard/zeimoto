import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'app/app.dart';
import 'models/adapters.dart';
import 'l10n/app_localizations.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    await Hive.initFlutter();
  } else {
    final appDir = await getApplicationDocumentsDirectory();
    await Hive.initFlutter(appDir.path);
  }

  registerHiveAdapters();

  if (kIsWeb) {
    await Hive.openBox('plants');
    await Hive.openBox('photos');
    await Hive.openBox('interventions');
  } else {
    const secureStorage = FlutterSecureStorage();
    var key = await secureStorage.read(key: 'hive_enc_key');
    if (key == null) {
      final newKey = Hive.generateSecureKey();
      await secureStorage.write(key: 'hive_enc_key', value: newKey.join(','));
      key = newKey.join(',');
    }
    final encryptionKey = key.split(',').map(int.parse).toList().cast<int>();
    final cipher = HiveAesCipher(encryptionKey);
    await Hive.openBox('plants', encryptionCipher: cipher);
    await Hive.openBox('photos', encryptionCipher: cipher);
    await Hive.openBox('interventions', encryptionCipher: cipher);
  }

  runApp(const BonsaiApp());
}

class BonsaiApp extends StatelessWidget {
  const BonsaiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Bonsai Manager',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      routerConfig: AppRouter.router,
      locale: const Locale('it'),
      supportedLocales: const [Locale('it'), Locale('en')],
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
    );
  }
}
