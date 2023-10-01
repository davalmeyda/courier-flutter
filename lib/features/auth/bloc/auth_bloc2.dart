import 'package:rxdart/rxdart.dart';
import 'package:ojo_courier/models/user.entity.dart';

class AuthBloc2 {
  final BehaviorSubject<User> _user = BehaviorSubject<User>();

  AuthBloc2() {
    _user.add(User());
  }

  Stream<User> get userStream => _user.stream;

  User get user => _user.value;

  void setUser(User user) {
    _user.add(user);
  }

  void dispose() {
    _user.close();
  }
}

final authBloc2 = AuthBloc2();
