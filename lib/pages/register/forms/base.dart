import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:ikleeralles/constants.dart';
import 'package:ikleeralles/logic/managers/platform.dart';
import 'package:ikleeralles/ui/themed/button.dart';
import 'package:ikleeralles/ui/themed/textfield.dart';

abstract class RegisterForm<T> extends StatefulWidget {

  final Function onSignInPressed;

  final PlatformDataProvider platformDataProvider;

  RegisterForm ({ this.onSignInPressed, this.platformDataProvider });

}

abstract class RegisterFormState<T> extends State<RegisterForm> {


  Validators _validators;

  TextEditingController _usernameTextController = TextEditingController();
  TextEditingController get usernameTextController => _usernameTextController;

  TextEditingController _passwordTextController = TextEditingController();
  TextEditingController get passwordTextController => _passwordTextController;

  TextEditingController _emailTextController = TextEditingController();
  TextEditingController get emailTextController => _emailTextController;

  @override
  void initState() {
    _validators = Validators(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Form(child: ListView(
      padding: EdgeInsets.all(15),
      children: children(context),
    ));
  }

  List<Widget> children(BuildContext context) {
    return <Widget>[
      usernameTextField(),
      passwordTextField(),
      emailTextField(),
      signUpButton()
    ];
  }

  T getData();

  Widget usernameTextField() {
    return ThemedTextField(
      labelText: FlutterI18n.translate(context, TranslationKeys.username),
      labelColor: Colors.black,
      borderRadius: 15,
      borderColor: Color.fromRGBO(210, 210, 210, 1),
      validator: _validators.notEmptyValidator,
      textEditingController: _usernameTextController,
    );
  }

  Widget passwordTextField() {
    return ThemedTextField(
      labelText: FlutterI18n.translate(context, TranslationKeys.password),
      labelColor: Colors.black,
      borderRadius: 15,
      borderColor: Color.fromRGBO(210, 210, 210, 1),
      textEditingController: _passwordTextController,
      validator: _validators.notEmptyValidator,
    );
  }

  Widget emailTextField() {
    return ThemedTextField(
      labelText: FlutterI18n.translate(context, TranslationKeys.email),
      labelColor: Colors.black,
      borderRadius: 15,
      borderColor: Color.fromRGBO(210, 210, 210, 1),
      textEditingController: _emailTextController,
      validator: _validators.notEmptyValidator,
    );
  }

  Widget signUpButton() {
    return Container(
      child: ThemedButton(
        FlutterI18n.translate(context, TranslationKeys.signIn),
        buttonColor: BrandColors.primaryButtonColor,
        labelColor: Colors.white,
        fontSize: 17,
        contentPadding: EdgeInsets.symmetric(
            vertical: 15,
            horizontal: 20
        ),
        borderRadius: BorderRadius.all(Radius.circular(20)),
        onPressed: () {
          widget.onSignInPressed(getData());
        },
      ),
      margin: EdgeInsets.only(
          top: 10
      ),
    );
  }

}



