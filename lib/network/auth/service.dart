import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:ikleeralles/network/auth/userinfo.dart';
import 'package:ikleeralles/network/api/base.dart';
import 'package:ikleeralles/pages/register/registration.dart';
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


  Future tryLoginFromCache() async {
    Completer completer = Completer();
    try {
      var cachedUserInfo = await UserInfo.loadCached();
      if (cachedUserInfo != null) {

        var loginResult = await Api().authorize(
            username: cachedUserInfo.credentials.usernameOrEmail,
            password: cachedUserInfo.credentials.password
        );
        var accessToken = AccessToken(loginResult.accessToken);
        var userResult = await SecuredApi(accessToken).getUser();
        var purchaserInfo = await Purchases.getPurchaserInfo();
        var userInfo = UserInfo(
            accessToken: accessToken,
            userResult: userResult,
            credentials: cachedUserInfo.credentials,
            activeIAPSubs: purchaserInfo.activeSubscriptions
        );

        await userInfo.save();
        updateUserInfo(userInfo);

      }
      completer.complete();
    } catch (e) {
      completer.complete(e);
    }
    return completer.future;
  }

  Future<UserInfo> saveNewUserInfo(UserInfo userInfo) async {
    updateUserInfo(userInfo);
    await userInfo.save();
    return userInfo;
  }

  Future<UserInfo> createUserInfo({ @required Credentials credentials, @required String accessToken }) async {
    var accessTokenObj = AccessToken(accessToken);
    var userResult = await SecuredApi(accessTokenObj).getUser();
    var purchaserInfo = await Purchases.getPurchaserInfo();
    var userInfo = UserInfo(
        accessToken: accessTokenObj,
        userResult: userResult,
        credentials: credentials,
        activeIAPSubs: purchaserInfo.activeSubscriptions
    );
    return userInfo;
  }

  Future login({ String usernameOrEmail, String password }) async {

    var loginResult = await Api().authorize(
        username: usernameOrEmail,
        password: password
    );

    var credentials = Credentials(usernameOrEmail: usernameOrEmail, password: password);
    var userInfo = await createUserInfo(credentials: credentials, accessToken: loginResult.accessToken);
    await saveNewUserInfo(userInfo);

  }

  Future register(Registration registration) async {

    var registerResult = await Api().register(
      registration
    );

    var credentials = Credentials(
      usernameOrEmail: registration.username,
      password: registration.password
    );

    var userInfo = await createUserInfo(credentials: credentials, accessToken: registerResult.accessToken);
    await saveNewUserInfo(userInfo);

  }

  Future logout() async  {
    await UserInfo.clearCache();
    this.userInfoValueNotifier.value = null;
    this._securedApi = null;
  }

  Future sendPurchaseInfoToServer(PurchaserInfo purchaserInfo) {
    //TODO: Implement sending to server!
  }





}