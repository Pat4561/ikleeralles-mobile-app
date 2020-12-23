import 'package:flutter/material.dart';
import 'package:ikleeralles/network/auth/service.dart';
import 'package:ikleeralles/pages/login.dart';

class LogoutHandler {

  final BuildContext context;

  LogoutHandler (this.context);

  void _onLogoutCheck() {
    if (AuthService().userInfo == null) {
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
          builder: (BuildContext context) {
            return LoginPage();
          }
      ), (route) => false);
    }
  }

  void listen() {
    AuthService().listen(_onLogoutCheck);
  }

  void unListen() {
    AuthService().unListen(_onLogoutCheck);
  }

}