import 'package:flutter/material.dart';

import 'core/config/app_config.dart';
import 'core/theme/app_theme.dart';
import 'features/shell/presentation/home_shell.dart';

/// Root widget of the Grocerra customer app.
///
/// Screen set and navigation follow the Reevake blueprint
/// `User App - Frontend` (app: User app): a light, Apple-inspired UI with a
/// restrained green accent and a floating five-tab navigation bar
/// (Home - Browse - Catering - Orders - Profile).
class GrocerraApp extends StatelessWidget {
  const GrocerraApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppConfig.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      home: const HomeShell(),
    );
  }
}
