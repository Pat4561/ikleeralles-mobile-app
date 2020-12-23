import 'package:flutter/foundation.dart';
import 'package:ikleeralles/network/keys.dart';
import 'package:ikleeralles/network/models/abstract.dart';
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


  Map toMap() {
    return {
      AuthKeys.username: usernameOrEmail,
      AuthKeys.password: password
    };
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

  static AccessToken fromMap (Map map) {
    return AccessToken(
      map[AuthKeys.token],
      validTill: DateTime.fromMicrosecondsSinceEpoch(map[AuthKeys.validTill])
    );
  }

  Map toMap() {
    return {
      AuthKeys.token: token,
      AuthKeys.validTill: validTill.millisecondsSinceEpoch
    };
  }

}


class UserInfo {

  final Credentials credentials;
  final UserResult userResult;
  final AccessToken accessToken;

  UserInfo ({ this.credentials, this.userResult, this.accessToken });

  Map toMap() {
    return {
      UserInfoKeys.credentials: credentials.toMap(),
      UserInfoKeys.userResult: userResult.toMap(),
      UserInfoKeys.accessToken: accessToken.toMap()
    };
  }


  
}