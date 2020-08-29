import 'package:flutter/foundation.dart';
import 'package:ikleeralles/network/keys.dart';
import 'package:ikleeralles/network/models/user_result.dart';

class Credentials {

  final String usernameOrEmail;
  final String password;

  Credentials ({ @required this.usernameOrEmail, @required this.password });

  static Credentials fromMap(Map map) {
    return Credentials(
      usernameOrEmail: map[AuthKeys.username],
      password: map[AuthKeys.password]
    );
  }
}

class AccessToken {

  final String token;
  DateTime validTill;

  AccessToken (this.token, { this.validTill }) {
    if (validTill == null) {
      validTill = DateTime.now().add(Duration(days: 1));
    }
  }

}

class UserInfo {

  final Credentials credentials;
  final UserResult userResult;
  final AccessToken accessToken;

  UserInfo ({ this.credentials, this.userResult, this.accessToken });

}