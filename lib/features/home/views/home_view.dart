import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ojo_courier/features/auth/bloc/auth_bloc.dart';
import 'package:ojo_courier/features/features.dart';
import 'package:ojo_courier/shared/shared.dart';

class HomeView extends StatelessWidget {
  static const String route = 'HomeView';
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Courier v1.0.0'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await LocalPreferences().clear();
              if (!context.mounted) return;
              Navigator.pushNamedAndRemoveUntil(
                  context, LoginView.route, (route) => false);
            },
          ),
        ],
      ),
      body: SafeArea(
        child: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            if (state.selectedIndex == 1) {
              return const DeliverListView();
            }
            return const ReceiveListView();
          },
        ),
      ),
      bottomNavigationBar: const BottomNavigationWidget(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          if (state.selectedIndex == 1) {
            return FloatingActionButton(
              backgroundColor: CustomColors.primary,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(100)),
              ),
              elevation: 0,
              child: const Icon(
                Icons.document_scanner,
                color: Colors.white,
              ),
              onPressed: () {
                Navigator.pushNamed(context, DeliverScannerView.route);
              },
            );
          }
          return FloatingActionButton(
            backgroundColor: CustomColors.primary,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(100)),
            ),
            elevation: 0,
            child: const Icon(
              Icons.document_scanner,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.pushNamed(context, ReceiveScannerView.route);
            },
          );
        },
      ),
    );
  }
}
