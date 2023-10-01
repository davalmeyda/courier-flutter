import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scanner_qr/features/auth/bloc/auth_bloc.dart';
import 'package:scanner_qr/features/features.dart';
import 'package:scanner_qr/shared/shared.dart';

class HomeView extends StatelessWidget {
  static const String route = 'HomeView';
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Inicio'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              LocalPreferences().clear();
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
              backgroundColor: Colors.blue,
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
            backgroundColor: Colors.blue,
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
