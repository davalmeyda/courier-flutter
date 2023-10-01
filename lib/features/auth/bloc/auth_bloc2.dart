import 'package:rxdart/rxdart.dart';
import 'package:scanner_qr/shared/config/config.dart';

class AuthBloc2 {
  final BehaviorSubject<int> _userId = BehaviorSubject<int>();

  AuthBloc2() {
    LocalPreferences().getString('idLogged').then((value) {
      if (value != null) {
        _userId.add(int.parse(value));
      }
    });
  }

  Stream<dynamic> get userStream => _userId.stream;

  dynamic get userId => _userId.hasValue ? _userId.value : null;

  void setUser(int id) {
    _userId.add(id);
    LocalPreferences().setString('idLogged', id.toString());
  }

  void dispose() {
    _userId.close();
  }
}

final authBloc2 = AuthBloc2();
