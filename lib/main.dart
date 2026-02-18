import 'package:flutter/material.dart';

import 'app.dart';
import 'core/config/app_environment.dart';
import 'core/config/firebase_bootstrap.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  AppEnvironment.current = AppEnvironment.dev;
  await FirebaseBootstrap.initialize(AppEnvironment.current);

  runApp(const WhatsAppCloneApp());
}
