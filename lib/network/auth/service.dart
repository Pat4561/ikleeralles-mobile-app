import 'package:flutter/foundation.dart';
import 'package:ikleeralles/network/auth/userinfo.dart';
import 'package:ikleeralles/network/api/base.dart';
import 'package:ikleeralles/network/models/login_result.dart';
class AuthService {


  ValueNotifier<UserInfo> _userInfoValueNotifier = ValueNotifier<UserInfo>(null);

  UserInfo get userInfo => _userInfoValueNotifier.value;

  void updateUserInfo(UserInfo userInfo) {
    this._userInfoValueNotifier.value = userInfo;
  }

  static final AuthService _instance = AuthService._internal();

  factory AuthService() {
    return _instance;
  }

  AuthService._internal();

  void listen( Function() onUserInfoUpdated ) {
    this._userInfoValueNotifier.addListener(onUserInfoUpdated);
  }

  void unListen( Function() onUserInfoUpdated ) {
    this._userInfoValueNotifier.removeListener(onUserInfoUpdated);
  }

  Future login({ String usernameOrEmail, String password }) async {

    var loginResult = await Api().authorize(
        username: usernameOrEmail,
        password: password
    );

    var credentials = Credentials(usernameOrEmail: usernameOrEmail, password: password);
    var accessToken = AccessToken(loginResult.accessToken);
    var userResult = await SecuredApi(accessToken).getUser();
    var userInfo = UserInfo(
        accessToken: accessToken,
        userResult: userResult,
        credentials: credentials
    );
    updateUserInfo(userInfo);

  }

  //The webview should return a loginresult and credentials
  Future registerFromWeb({ LoginResult loginResult, Credentials credentials }) async {
    var accessToken = AccessToken(loginResult.accessToken);
    var userResult = await SecuredApi(accessToken).getUser();
    var userInfo = UserInfo(
        accessToken: accessToken,
        userResult: userResult,
        credentials: credentials
    );
    updateUserInfo(userInfo);

  }


}