import 'package:rxdart/rxdart.dart';

class AuthBloc2 {
  final BehaviorSubject<dynamic> _user = BehaviorSubject<dynamic>();

  AuthBloc2() {
    _user.add(null);
  }

  Stream<dynamic> get userStram => _user.stream;

  dynamic get user => _user.value;

  void setUser(dynamic user) {
    _user.add(user);
  }

  void dispose() {
    _user.close();
  }
}

final authBloc2 = AuthBloc2();
