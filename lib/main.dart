import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ojo_courier/features/auth/bloc/auth_bloc.dart';
import 'package:ojo_courier/shared/shared.dart';

void main() {
  runApp(MultiRepositoryProvider(
    providers: [
      RepositoryProvider<AuthBloc>(
        create: (context) => AuthBloc(),
      ),
    ],
    child: BlocProvider(
      create: (context) => AuthBloc(),
      child: const MyApp(),
    ),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final navigatorKey = AppRoutes.mainNavigatorKey;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Motorizado App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: CustomColors.primary),
        useMaterial3: true,
      ),
      navigatorKey: navigatorKey,
      initialRoute: AppRoutes.initialRoute,
      routes: AppRoutes.routes,
    );
  }
}
