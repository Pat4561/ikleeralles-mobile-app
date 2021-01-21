import 'package:flutter/foundation.dart';
import 'package:ikleeralles/pages/register/registration.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:ikleeralles/logic/managers/extensions.dart';
import 'package:ikleeralles/network/auth/service.dart';
import 'package:ikleeralles/network/keys.dart';
import 'package:ikleeralles/network/auth/webresponse.dart';
import 'package:ikleeralles/network/auth/userinfo.dart';
import 'package:ikleeralles/network/models/login_result.dart';

class LoginManager extends Model {

  final LoadingDelegate loadingDelegate = LoadingDelegate();

  void handleWebEvent(Map map, { @required Function onPasswordForgot }) {
    var response = WebResponse(map);
    switch (response.eventType) {
      case WebResponseEventType.forgotPassword: {
        onPasswordForgot();
      }
      break;
      default:
        break;
    }
  }

  Future login({ String usernameOrEmail, String password }) {
    Future future = AuthService().login(
        usernameOrEmail: usernameOrEmail,
        password: password
    );
    loadingDelegate.attachFuture(future);
    return future;
  }


  Future register(Registration registration) {
    Future future = AuthService().register(
      registration
    );
    loadingDelegate.attachFuture(future);
    return future;
  }


}