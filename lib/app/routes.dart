import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:zeimoto/screens/home_screen.dart';
import 'package:zeimoto/screens/start_screen/start_screen.dart';
import 'package:zeimoto/screens/add_plant_screen.dart';
import 'package:zeimoto/screens/plant_detail_screen.dart';
import 'package:zeimoto/screens/add_wizard/wizard_screen.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    routes: [
      GoRoute(
        path: '/',
        builder: (ctx, st) => const StartScreen(),
      ),
      GoRoute(
        path: '/add-wizard',
        builder: (ctx, st) => const WizardScreen(),
      ),
      GoRoute(
        path: '/plants',
        builder: (ctx, st) => const HomeScreen(),
      ),
      GoRoute(
        path: '/add-plant',
        builder: (ctx, st) => const AddPlantScreen(),
      ),
      GoRoute(
        path: '/plant/:id',
        builder: (ctx, st) => PlantDetailScreen(
          plantId: st.pathParameters['id']!,
          initialTabIndex: _initialTab(st),
        ),
      ),
    ],
    errorBuilder: (ctx, st) => Scaffold(body: Center(child: Text('Errore: ${st.error}'))),
  );
}

int? _initialTab(GoRouterState st) {
  final extra = (st.extra is int) ? st.extra as int : null;
  final qp = st.uri.queryParameters['tab'];
  if (qp == 'gallery') return 1;
  return extra;
}
