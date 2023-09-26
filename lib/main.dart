import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:scanner_qr/shared/shared.dart';

void main() {
  // runApp(MultiRepositoryProvider(
  //   providers: [
  //     // RepositoryProvider(create: (context) => _httpTaskRepository)
  //   ],
  //   child: BlocProvider(
  //     create: (context) => HomeBloc(
  //       context.read<TaskRepository>(),
  //     ),
  //     child: const MyApp(),
  //   ),
  // ));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final navigatorKey = AppRoutes.mainNavigatorKey;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Motorizado App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      navigatorKey: navigatorKey,
      initialRoute: AppRoutes.initialRoute,
      routes: AppRoutes.routes,
    );
  }
}
