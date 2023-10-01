import 'package:rxdart/rxdart.dart';

class AuthBloc2 {
  final BehaviorSubject<int?> _userId = BehaviorSubject<int>();

  AuthBloc2() {
    _userId.add(59);
  }

  Stream<dynamic> get userStream => _userId.stream;

  dynamic get userId => _userId.hasValue ? _userId.value : null;

  void setUser(int id) {
    _userId.add(id);
  }

  void dispose() {
    _userId.close();
  }
}

final authBloc2 = AuthBloc2();
