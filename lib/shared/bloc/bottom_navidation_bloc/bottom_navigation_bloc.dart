import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
part 'bottom_navigation_event.dart';
part 'bottom_navigation_state.dart';

class BottomNavigationBloc
    extends Bloc<BottomNavigationEvent, BottomNavigationState> {
  BottomNavigationBloc() : super(const BottomNavigationState()) {
    on<ChangeIndex>(_onChangeIndex);
  }

  void _onChangeIndex(ChangeIndex event, Emitter<BottomNavigationState> emit) {
    emit(state.copyWith(selectedIndex: event.index));
  }
}
