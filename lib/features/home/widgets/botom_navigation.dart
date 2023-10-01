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
                return IconButton(
                  tooltip: 'Recepción',
                  enableFeedback: true,
                  icon: const Icon(Icons.trolley),
                  onPressed: () {
                    context.read<AuthBloc>().add(const ChangeIndex(0));
                  },
                );
              },
            ),
            const Spacer(),
            BlocBuilder<AuthBloc, AuthState>(
              builder: (context, state) {
                if (state.selectedIndex == 1) {
                  return IconButton(
                    tooltip: 'Despacho',
                    icon: const Icon(Icons.local_shipping),
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
    /*return NavigationBar(
      onDestinationSelected: (value) =>
          context.read<AuthBloc>().add(ChangeIndex(value)),
      selectedIndex: state.selectedIndex,
      indicatorColor: Colors.white,
      backgroundColor: Colors.blue,
      labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
      elevation: 0,
      destinations: const [
        NavigationDestination(
          icon: Icon(Icons.trolley),
          label: 'Recepción',
        ),
        NavigationDestination(
          icon: Icon(Icons.local_shipping),
          label: 'Despacho',
        ),
      ],
    );*/
    // return BottomNavigationBar(
    //   type: BottomNavigationBarType.shifting,
    //   elevation: 0,
    //   currentIndex: state.selectedIndex,
    //   onTap: (value) => context.read<AuthBloc>().add(ChangeIndex(value)),
    //   items: const [
    //     BottomNavigationBarItem(
    //       icon: Icon(Icons.trolley),
    //       label: 'Recepción',
    //       backgroundColor: Colors.blue,
    //     ),
    //     BottomNavigationBarItem(
    //       icon: Icon(Icons.local_shipping),
    //       label: 'Despacho',
    //       backgroundColor: Colors.blue,
    //     ),
    //   ],
    // );
  }
}
