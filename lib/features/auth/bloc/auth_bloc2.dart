import 'package:rxdart/rxdart.dart';
import 'package:scanner_qr/shared/config/config.dart';

class AuthBloc2 {
  final BehaviorSubject<dynamic> _user = BehaviorSubject<dynamic>();

  AuthBloc2() {
    LocalPreferences().getString('user').then((value) {
      if (value != null) {
        _user.add(value);
      }
    });
  }

  Stream<dynamic> get userStram => _user.stream;

  dynamic get user => _user.hasValue ? _user.value : null;

  void setUser(dynamic user) {
    _user.add(user);
    LocalPreferences().setString('user', user);
  }

  void dispose() {
    _user.close();
  }
}

final authBloc2 = AuthBloc2();
