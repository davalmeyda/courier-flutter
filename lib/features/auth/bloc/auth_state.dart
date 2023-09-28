part of 'auth_bloc.dart';

class AuthState extends Equatable {
  const AuthState({
    this.userId = 0,
    this.selectedIndex = 0,
  });

  final int userId;
  final int selectedIndex;

  AuthState copyWith({
    int? userId,
    int? selectedIndex,
  }) =>
      AuthState(
        userId: userId ?? this.userId,
        selectedIndex: selectedIndex ?? this.selectedIndex,
      );

  @override
  List<Object?> get props => [userId, selectedIndex];
}
