import 'package:flutter/material.dart';

import 'package:scanner_qr/features/features.dart';

class AppRoutes {
  static const String initialRoute = LoginView.route;
  static final mainNavigatorKey = GlobalKey<NavigatorState>();
  static Map<String, WidgetBuilder> get routes => {
        ReceiveListView.route: (_) => const ReceiveListView(),
        ReceiveScannerView.route: (_) => const ReceiveScannerView(),
        // DeliverListView.route: (_) => const DeliverListView(),
        // DeliverFormView.route: (_) => const DeliverFormView(),
        LoginView.route: (_) => const LoginView(),
      };
}
