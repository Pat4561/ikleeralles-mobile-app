import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:ikleeralles/constants.dart';
import 'package:ikleeralles/managers/extensions.dart';
import 'package:ikleeralles/managers/login.dart';
import 'package:ikleeralles/network/auth/userinfo.dart';
import 'package:ikleeralles/network/models/login_result.dart';
import 'package:ikleeralles/pages/webview.dart';
import 'package:ikleeralles/ui/alert.dart';
import 'package:ikleeralles/ui/hyperlink.dart';
import 'package:ikleeralles/ui/loading_overlay.dart';
import 'package:ikleeralles/ui/logo.dart';
import 'package:ikleeralles/ui/snackbar.dart';
import 'package:ikleeralles/ui/textfield.dart';
import 'package:ikleeralles/ui/button.dart';
import 'package:scoped_model/scoped_model.dart';

class LoginPage extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    return LoginPageState();
  }

}

//TODO: Show a loading overlay, and redirect to the home screen

class LoginPageState extends State<LoginPage> {

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> loginFormKey = GlobalKey<FormState>();

  final TextEditingController usernameTextController = TextEditingController();
  final TextEditingController passwordTextController = TextEditingController();

  final LoginManager loginManager = LoginManager();

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

  void onWebEventReceived(BuildContext webPageContext, Map map) {
    loginManager.handleWebEvent(
        map,
        onPasswordForgot: () {

          FlutterWebviewPlugin().hide();
          SimpleAlert.show(
              webPageContext,
              title: FlutterI18n.translate(webPageContext, TranslationKeys.emailSent),
              message: FlutterI18n.translate(webPageContext, TranslationKeys.recoverEmailSentMessage),
              onOkayPressed: (BuildContext alertContext) {
                Navigator.of(alertContext).pop();
                Navigator.of(webPageContext).pop();
              }
          );

        },
        onRegisteredAccount: (LoginResult loginResult, Credentials credentials) {
          Navigator.of(webPageContext).pop();
          loginManager.register(
            loginResult: loginResult,
            credentials: credentials
          ).catchError((e) {
            showSnackBar(buildContext: context, message: FlutterI18n.translate(context, TranslationKeys.registrationError), isError: true);
          });
        }
    );
  }

  void onForgotPasswordPressed() {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (BuildContext context) {
          return WebViewPage(
              title: FlutterI18n.translate(context, TranslationKeys.forgotPassword),
              url: WebUrls.forgotPassword,
              onEventReceived: onWebEventReceived,
          );
        }
    ));
  }

  void onSignInPressed() {
    if (loginFormKey.currentState.validate()) {
      loginFormKey.currentState.save();
    }

    loginManager.login(
      usernameOrEmail: this.usernameTextController.text,
      password: this.passwordTextController.text,
    ).catchError((e) {
      showSnackBar(buildContext: context, message: FlutterI18n.translate(context, TranslationKeys.loginError), isError: true);
    });
  }

  void onCreateAccountPressed() {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (BuildContext context) {
        return WebViewPage(
            title: FlutterI18n.translate(context, TranslationKeys.register),
            url: WebUrls.register,
            onEventReceived: onWebEventReceived,
        );
      }
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: scaffoldKey,
        backgroundColor: BrandColors  .themeColor,
        body: Stack(
          children: <Widget>[
            Center(
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
            ),
            ScopedModel(
              model: loginManager.loadingDelegate,
              child: ScopedModelDescendant<LoadingDelegate>(
                  builder: (BuildContext context, Widget widget, LoadingDelegate loadingDelegate) {
                    return Visibility(
                      visible: loginManager.loadingDelegate.isLoading,
                      child: LoadingOverlay(),
                    );
                  }
              )
            )
          ],
        )
    );
  }

}



