import 'package:flutter/material.dart';
import '../data/repositories/store_orders_repository.dart';
import 'store_shell.dart';

final _sharedStoreRepository = MockStoreOrdersRepository();

final Map<String, WidgetBuilder> storeRoutes = {
  '/store': (_) => StoreShell(repository: _sharedStoreRepository, initialRoute: '/store/live'),
  '/store/live': (_) => StoreShell(repository: _sharedStoreRepository, initialRoute: '/store/live'),
  '/store/orders': (_) => StoreShell(repository: _sharedStoreRepository, initialRoute: '/store/orders'),
  '/store/history': (_) => StoreShell(repository: _sharedStoreRepository, initialRoute: '/store/orders'),
  '/store/analytics': (_) => StoreShell(repository: _sharedStoreRepository, initialRoute: '/store/analytics'),
  '/store/inventory': (_) => StoreShell(repository: _sharedStoreRepository, initialRoute: '/store/inventory'),
  '/store/payouts': (_) => StoreShell(repository: _sharedStoreRepository, initialRoute: '/store/payouts'),
  '/store/issues': (_) => StoreShell(repository: _sharedStoreRepository, initialRoute: '/store/issues'),
  '/store/catering': (_) => StoreShell(repository: _sharedStoreRepository, initialRoute: '/store/catering'),
  '/store/settings': (_) => StoreShell(repository: _sharedStoreRepository, initialRoute: '/store/settings'),
  '/store/packing': (_) => StoreShell(repository: _sharedStoreRepository, initialRoute: '/store/packing'),
};
