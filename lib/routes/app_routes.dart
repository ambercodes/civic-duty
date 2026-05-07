import 'package:flutter/material.dart';

import '../screens/dashboard_screen.dart';
import '../screens/dossier_screen.dart';
import '../screens/landing_screen.dart';
import '../screens/ratification_screen.dart';
import '../screens/record_screen.dart';

class AppRoutes {
  const AppRoutes._();

  static const landing = '/';
  static const dashboard = '/dashboard';
  static const dossier = '/dossier';
  static const ratify = '/ratify';
  static const record = '/record';

  static Map<String, WidgetBuilder> get routes {
    return {
      landing: (_) => const LandingScreen(),
      dashboard: (_) => const DashboardScreen(),
      dossier: (_) => const DossierScreen(),
      ratify: (_) => const RatificationScreen(),
      record: (_) => const RecordScreen(),
    };
  }
}
