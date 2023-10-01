import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scanner_qr/features/auth/bloc/auth_bloc.dart';
import 'package:scanner_qr/features/auth/bloc/auth_bloc2.dart';
import 'package:scanner_qr/shared/shared.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Verifica si hay un usuario almacenado localmente
  final userId = await LocalPreferences().getString('idLogged');

  // Crea el AuthBloc2 y establece el usuario si está disponible
  final authBloc2 = AuthBloc2();
  if (userId != null) {
    authBloc2.setUser(int.parse(userId));
  }

  runApp(MultiRepositoryProvider(
    providers: [
      RepositoryProvider<AuthBloc>(
        create: (context) => AuthBloc(),
      ),
    ],
    child: BlocProvider(
      create: (context) => AuthBloc(),
      child: MyApp(authBloc2: authBloc2),
    ),
  ));
}

class MyApp extends StatelessWidget {
  final AuthBloc2 authBloc2;
  const MyApp({Key? key, required this.authBloc2}) : super(key: key);

  String _determineInitialRoute() {
    return authBloc2.userId != null
        ? AppRoutes.homeRoute
        : AppRoutes.loginRoute;
  }

  @override
  Widget build(BuildContext context) {
    LocalPreferences().getString('idLogged').then((value) {
      if (value != null) {
        authBloc2.setUser(int.parse(value));
      }
    });
    final navigatorKey = AppRoutes.mainNavigatorKey;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'OJO Courier',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      navigatorKey: navigatorKey,
      initialRoute: _determineInitialRoute(),
      routes: AppRoutes.routes,
    );
  }
}
