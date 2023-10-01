import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ojo_courier/features/auth/bloc/auth_bloc.dart';

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
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  tooltip: 'Recepción',
                  enableFeedback: true,
                  icon: Row(
                    children: [
                      Icon(
                        Icons.trolley,
                        color: state.selectedIndex == 0
                            ? Colors.blue
                            : Colors.white,
                      ),
                      const SizedBox(width: 10),
                      Text(
                        'Recepción',
                        style: TextStyle(
                            color: state.selectedIndex == 0
                                ? Colors.blue
                                : Colors.white),
                      ),
                    ],
                  ),
                  style: ButtonStyle(
                    backgroundColor: state.selectedIndex == 0
                        ? MaterialStateProperty.all(Colors.white)
                        : MaterialStateProperty.all(Colors.blue),
                  ),
                  onPressed: () {
                    context.read<AuthBloc>().add(const ChangeIndex(0));
                  },
                );
              },
            ),
            const Spacer(),
            BlocBuilder<AuthBloc, AuthState>(
              builder: (context, state) {
                return IconButton(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  tooltip: 'Despacho',
                  enableFeedback: true,
                  icon: Row(
                    children: [
                      Text(
                        'Despacho',
                        style: TextStyle(
                            color: state.selectedIndex == 1
                                ? Colors.blue
                                : Colors.white),
                      ),
                      const SizedBox(width: 10),
                      Icon(
                        Icons.local_shipping,
                        color: state.selectedIndex == 1
                            ? Colors.blue
                            : Colors.white,
                      ),
                    ],
                  ),
                  style: ButtonStyle(
                    backgroundColor: state.selectedIndex == 1
                        ? MaterialStateProperty.all(Colors.white)
                        : MaterialStateProperty.all(Colors.blue),
                  ),
                  onPressed: () {
                    context.read<AuthBloc>().add(const ChangeIndex(1));
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
