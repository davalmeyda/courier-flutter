bool validarCodigoEscaneado(String code) {
  String pattern = r'^[a-zA-Z0-9]{1,4}-\d{6}-\d{1,3}(-C\d{1,2})?$';
  RegExp regExp = RegExp(pattern);

  if (regExp.hasMatch(code)) {
    return true;
  } else {
    return false;
  }
}
