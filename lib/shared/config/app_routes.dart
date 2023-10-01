import 'package:flutter/material.dart';

import 'package:ojo_courier/features/features.dart';

class AppRoutes {
  static const String initialRoute = LoginView.route;
  static final mainNavigatorKey = GlobalKey<NavigatorState>();
  static Map<String, WidgetBuilder> get routes => {
        HomeView.route: (_) => const HomeView(),
        ReceiveListView.route: (_) => const ReceiveListView(),
        ReceiveScannerView.route: (_) => const ReceiveScannerView(),
        DeliverListView.route: (_) => const DeliverListView(),
        DeliverScannerView.route: (_) => const DeliverScannerView(),
        LoginView.route: (_) => const LoginView(),
      };
}
