part of 'bottom_navigation_bloc.dart';

abstract class BottomNavigationEvent {
  const BottomNavigationEvent();
}

class ChangeIndex extends BottomNavigationEvent {
  const ChangeIndex(this.index);
  final int index;
}
