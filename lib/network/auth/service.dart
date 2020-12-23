import 'package:flutter/foundation.dart';
import 'package:ikleeralles/network/auth/userinfo.dart';
import 'package:ikleeralles/network/api/base.dart';
import 'package:ikleeralles/network/models/login_result.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
class AuthService {


  final ValueNotifier<UserInfo> userInfoValueNotifier = ValueNotifier<UserInfo>(null);

  SecuredApi _securedApi;

  SecuredApi get securedApi => _securedApi;

  UserInfo get userInfo => userInfoValueNotifier.value;

  void updateUserInfo(UserInfo userInfo) {
    this.userInfoValueNotifier.value = userInfo;
    this._securedApi = SecuredApi(
      userInfo.accessToken
    );
  }

  static final AuthService _instance = AuthService._internal();

  factory AuthService() {
    return _instance;
  }

  AuthService._internal();

  void listen( Function() onUserInfoUpdated ) {
    this.userInfoValueNotifier.addListener(onUserInfoUpdated);
  }

  void unListen( Function() onUserInfoUpdated ) {
    this.userInfoValueNotifier.removeListener(onUserInfoUpdated);
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
    await userInfo.save();
    updateUserInfo(userInfo);

  }

  Future sendPurchaseInfoToServer(PurchaserInfo purchaserInfo) {
    //TODO: Implement sending to server!
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