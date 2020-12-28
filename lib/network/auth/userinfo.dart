import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:ikleeralles/logic/managers/purchases.dart';
import 'package:ikleeralles/network/keys.dart';
import 'package:ikleeralles/network/models/user_result.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  final List<String> activeIAPSubs;

  static const String cachingKey = "userInfoCache";

  UserInfo ({ this.credentials, this.userResult, this.accessToken, this.activeIAPSubs });

  static UserInfo fromMap(Map map) {
    List activeSubs = map[UserInfoKeys.activeIAPSubs];
    List<String> activeSubsStrList = activeSubs.map((e) => e.toString()).toList();
    return UserInfo(
      credentials: Credentials.fromMap(map[UserInfoKeys.credentials]),
      accessToken: AccessToken.fromMap(map[UserInfoKeys.accessToken]),
      userResult: UserResult(map[UserInfoKeys.userResult]),
      activeIAPSubs: activeSubsStrList
    );
  }

  Map toMap() {
    return {
      UserInfoKeys.credentials: credentials.toMap(),
      UserInfoKeys.userResult: userResult.toMap(),
      UserInfoKeys.accessToken: accessToken.toMap(),
      UserInfoKeys.activeIAPSubs: activeIAPSubs
    };
  }

  Future save() async {
    String jsonStr = json.encode(toMap());
    var prefs = await SharedPreferences.getInstance();
    await prefs.setString(UserInfo.cachingKey, jsonStr);
  }

  static Future<UserInfo> loadCached() async {
    try {
      var prefs = await SharedPreferences.getInstance();
      String userInfoStr = prefs.getString(cachingKey);
      if (userInfoStr != null) {
        Map<String, dynamic> map = json.decode(userInfoStr);
        return UserInfo.fromMap(map);
      }
    } catch (e) {
      print(e);
    }
    return null;

  }

  static Future clearCache() async {
    var prefs = await SharedPreferences.getInstance();
    await prefs.setString(UserInfo.cachingKey, "");
  }


  bool get hasPremium {
    return userResult.hasPremium ||
        activeIAPSubs.contains(IAPSku.monthlySubAndroid) ||
        activeIAPSubs.contains(IAPSku.monthlySubIOS) ||
        activeIAPSubs.contains(IAPSku.yearlySubIOS) ||
        activeIAPSubs.contains(IAPSku.yearlySubAndroid);
  }
}