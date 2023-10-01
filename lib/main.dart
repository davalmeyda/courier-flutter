import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ojo_courier/features/auth/bloc/auth_bloc.dart';
import 'package:ojo_courier/features/auth/bloc/auth_bloc2.dart';
import 'package:ojo_courier/shared/shared.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final user = await LocalPreferences().getUser();
  if (user != null) {
    authBloc2.setUser(user);
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
    return authBloc2.user != null ? AppRoutes.homeRoute : AppRoutes.loginRoute;
  }

  @override
  Widget build(BuildContext context) {
    LocalPreferences().getUser().then((value) {
      if (value != null) {
        authBloc2.setUser(value);
      }
    });
    final navigatorKey = AppRoutes.mainNavigatorKey;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Ojo Courier',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: CustomColors.primary),
        useMaterial3: true,
      ),
      navigatorKey: navigatorKey,
      initialRoute: _determineInitialRoute(),
      routes: AppRoutes.routes,
    );
  }
}
