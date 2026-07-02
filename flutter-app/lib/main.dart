// PROTOTYPE — throwaway UI for issue #3 (app shell + archivio + creazione pianta).
// Not production code. Delete or absorb the winning variant when done.
// Run with: flutter run
import 'package:flutter/material.dart';

import 'prototype/app_shell/prototype_root.dart';
import 'prototype/app_shell/shared/design.dart';

void main() {
  runApp(const ZeimotoPrototypeApp());
}

class ZeimotoPrototypeApp extends StatelessWidget {
  const ZeimotoPrototypeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Zeimoto — Prototype',
      debugShowCheckedModeBanner: false,
      theme: ZeimotoTheme.light,
      home: const PrototypeRoot(),
    );
  }
}
