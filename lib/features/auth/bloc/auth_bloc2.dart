import 'package:ojo_courier/shared/config/config.dart';
import 'package:rxdart/rxdart.dart';
import 'package:ojo_courier/models/user.entity.dart';

class AuthBloc2 {
  final BehaviorSubject<User?> _user = BehaviorSubject<User?>();

  AuthBloc2() {
    LocalPreferences().getUser().then((value) {
      _user.add(value);
    });
  }

  Stream<dynamic> get userStream => _user.stream;

  User? get user => _user.hasValue ? _user.value : null;

  Future setUser(User user) async {
    _user.add(user);
    return await LocalPreferences().setUser(user);
  }

  void dispose() {
    _user.close();
  }
}

final authBloc2 = AuthBloc2();
