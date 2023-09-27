part of 'bottom_navigation_bloc.dart';

class BottomNavigationState extends Equatable {
  const BottomNavigationState({
    this.selectedIndex = 0,
  });

  final int selectedIndex;

  BottomNavigationState copyWith({
    int? selectedIndex,
  }) =>
      BottomNavigationState(
        selectedIndex: selectedIndex ?? this.selectedIndex,
      );

  @override
  List<Object?> get props => [selectedIndex];
}
