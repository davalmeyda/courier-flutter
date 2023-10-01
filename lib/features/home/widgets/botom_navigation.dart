import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scanner_qr/features/auth/bloc/auth_bloc.dart';

class BottomNavigationWidget extends StatefulWidget {
  const BottomNavigationWidget({super.key});

  @override
  State<BottomNavigationWidget> createState() => _BottomNavigationWidgetState();
}

class _BottomNavigationWidgetState extends State<BottomNavigationWidget> {
  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      shape: const CircularNotchedRectangle(),
      color: Colors.blue,
      child: IconTheme(
        data: IconThemeData(color: Theme.of(context).colorScheme.onPrimary),
        child: Row(
          children: <Widget>[
            BlocBuilder<AuthBloc, AuthState>(
              builder: (context, state) {
                if (state.selectedIndex == 0) {
                  return IconButton(
                    tooltip: 'Recepción',
                    enableFeedback: true,
                    icon: const Icon(
                      Icons.trolley,
                      color: Colors.blue,
                    ),
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.white),
                    ),
                    onPressed: () {
                      context.read<AuthBloc>().add(const ChangeIndex(0));
                    },
                  );
                } else {
                  return IconButton(
                    tooltip: 'Recepción',
                    enableFeedback: true,
                    icon: const Icon(Icons.trolley),
                    onPressed: () {
                      context.read<AuthBloc>().add(const ChangeIndex(0));
                    },
                  );
                }
              },
            ),
            const Spacer(),
            BlocBuilder<AuthBloc, AuthState>(
              builder: (context, state) {
                if (state.selectedIndex == 1) {
                  return IconButton(
                    tooltip: 'Despacho',
                    icon: const Icon(
                      Icons.local_shipping,
                      color: Colors.blue,
                    ),
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.white),
                    ),
                    onPressed: () {
                      context.read<AuthBloc>().add(const ChangeIndex(1));
                    },
                  );
                } else {
                  return IconButton(
                    tooltip: 'Despacho',
                    icon: const Icon(Icons.local_shipping),
                    onPressed: () {
                      context.read<AuthBloc>().add(const ChangeIndex(1));
                    },
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
