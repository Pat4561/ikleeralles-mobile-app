class InvalidCredentialsException implements Exception {

}

class RegistrationException implements Exception {

  final Map map;

  RegistrationException (this.map);

  String getMessage() {
    return map["message"];
  }

}