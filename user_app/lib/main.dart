import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'app.dart';
import 'core/services/supabase_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations(<DeviceOrientation>[
    DeviceOrientation.portraitUp,
  ]);
  // Boots the Supabase gateway when the build carries configuration.
  // No-ops (and records the reason) when it does not, so the UI can say so
  // instead of failing silently.
  await SupabaseService.init();
  runApp(const GrocerraApp());
}
