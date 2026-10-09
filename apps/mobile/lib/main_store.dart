import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'core/theme/app_theme.dart';
import 'features/store/presentation/store_routes.dart';
import 'features/store/presentation/store_shell.dart';
import 'features/store/data/repositories/store_orders_repository.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const GrocerraStoreApp());
}

class GrocerraStoreApp extends StatelessWidget {
  const GrocerraStoreApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Grocerra Store Manager — Madina Halal Meats',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      builder: (context, child) {
        return ShadTheme(
          data: ShadThemeData(
            colorScheme: const ShadGreenColorScheme.light(),
            radius: const BorderRadius.all(Radius.circular(8)),
          ),
          child: child ?? const SizedBox.shrink(),
        );
      },
      initialRoute: '/store/live',
      routes: {
        '/': (_) => StoreShell(
              repository: MockStoreOrdersRepository(),
              initialRoute: '/store/live',
            ),
        ...storeRoutes,
      },
    );
  }
}
