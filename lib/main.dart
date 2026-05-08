import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

import 'app.dart';
import 'config/firebase_runtime_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (FirebaseRuntimeOptions.isConfigured) {
    await Firebase.initializeApp(options: FirebaseRuntimeOptions.web);
  }

  runApp(const CivicDutyApp());
}
