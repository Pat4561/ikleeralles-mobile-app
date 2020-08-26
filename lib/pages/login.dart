import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:ikleeralles/constants.dart';
import 'package:ikleeralles/ui/hyperlink.dart';
import 'package:ikleeralles/ui/logo.dart';
import 'package:ikleeralles/ui/textfield.dart';
import 'package:ikleeralles/ui/button.dart';

//TODO: manager class and open webviews and response codes

class LoginPage extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    return LoginPageState();
  }

}

class LoginPageState extends State<LoginPage> {

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> loginFormKey = GlobalKey<FormState>();

  Validators _validators;

  Widget wrapElement({ double verticalMargin = 15, Widget child }) {
    return Container(
      margin: EdgeInsets.symmetric(
          vertical: verticalMargin
      ),
      child: child,
    );
  }

  Widget usernameTextField() {
    return ThemedTextField(
      labelText: FlutterI18n.translate(context, TranslationKeys.usernameOrEmail),
      hintText: FlutterI18n.translate(context, TranslationKeys.usernameHint),
      validator: _validators.notEmptyValidator,
    );
  }

  Widget passwordTextField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        ThemedTextField(
          labelText: FlutterI18n.translate(context, TranslationKeys.password),
          hintText: "******",
          validator: _validators.notEmptyValidator,
        ),
        Align(
          alignment: Alignment.centerRight,
          child: TextHyperlink(
            baseColor: BrandColors.labelColorYellow,
            highlightedColor: Colors.white,
            title: FlutterI18n.translate(context, TranslationKeys.forgotPassword),
            onPressed: onForgotPasswordPressed,
          ),
        )
      ],
    );
  }

  Widget signInButton() {
    return ThemedButton(
      FlutterI18n.translate(context, TranslationKeys.signIn),
      buttonColor: BrandColors.primaryButtonColor,
      labelColor: Colors.white,
      fontSize: 20,
      contentPadding: EdgeInsets.all(18),
      borderRadius: BorderRadius.all(Radius.circular(20)),
      onPressed: onSignInPressed,
    );
  }

  Widget signUpButton() {
    return ThemedButton(
      FlutterI18n.translate(context, TranslationKeys.createAnAccount),
      buttonColor: Colors.transparent,
      labelColor: Colors.white,
      contentPadding: EdgeInsets.symmetric(
          vertical: 12,
          horizontal: 24
      ),
      fontSize: 14,
      borderRadius: BorderRadius.all(Radius.circular(20)),
      borderSide: BorderSide(color: Colors.white),
      onPressed: onCreateAccountPressed,
    );
  }

  @override
  void initState() {
    super.initState();
    _validators = Validators(this.context);
  }

  void onForgotPasswordPressed() {

  }

  void onSignInPressed() {
    if (loginFormKey.currentState.validate()) {
      loginFormKey.currentState.save();
    }
  }

  void onCreateAccountPressed() {

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: scaffoldKey,
        backgroundColor: BrandColors.themeColor,
        body: Center(
            child: SingleChildScrollView(
              child: Container(
                margin: EdgeInsets.all(15),
                constraints: BoxConstraints(
                    maxWidth: 350
                ),
                child: Form(
                  key: loginFormKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      wrapElement(verticalMargin: 35, child: Logo(fontSize: 60)),
                      wrapElement(
                          verticalMargin: 6,
                          child: usernameTextField()
                      ),
                      wrapElement(
                          verticalMargin: 6,
                          child: passwordTextField()
                      ),
                      wrapElement(
                          verticalMargin: 25,
                          child: signInButton()
                      ),
                      wrapElement(
                          verticalMargin: 0,
                          child: Center(
                              child: signUpButton()
                          )
                      )
                    ],
                  ),
                )
              ),
            )
        )
    );
  }

}



