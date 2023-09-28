import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(const AuthState()) {
    on<ChangeIdUser>(_onChangeIdUser);
    on<ChangeIndex>(_onChangeIndex);
  }

  void _onChangeIdUser(ChangeIdUser event, Emitter<AuthState> emit) {
    emit(state.copyWith(userId: event.userId));
  }

  void _onChangeIndex(ChangeIndex event, Emitter<AuthState> emit) {
    emit(state.copyWith(selectedIndex: event.index));
  }
}
