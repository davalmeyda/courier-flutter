import 'package:flutter/material.dart';

class BottomNavigationWidget extends StatelessWidget {
  const BottomNavigationWidget({super.key});

  @override
  Widget build(BuildContext context) {
    // final state = context.watch<NavigationBloc>().state;
    return BottomNavigationBar(
      type: BottomNavigationBarType.shifting,
      elevation: 0,
      // currentIndex: state.selectedIndex,
      currentIndex: 0,
      // onTap: (value) => context.read<NavigationBloc>().add(ChangeIndex(value)),
      onTap: (value) => {},
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.help_center),
          label: 'Recibir',
          backgroundColor: Colors.blue,
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.local_shipping),
          label: 'Entregar',
          backgroundColor: Colors.blue,
        ),
      ],
    );
  }
}
