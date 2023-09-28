part of 'auth_bloc.dart';

abstract class AuthEvent {
  const AuthEvent();
}

class ChangeIdUser extends AuthEvent {
  const ChangeIdUser(this.userId);
  final int userId;
}

class ChangeIndex extends AuthEvent {
  const ChangeIndex(this.index);
  final int index;
}
