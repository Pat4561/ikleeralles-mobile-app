import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:ikleeralles/constants.dart';
import 'package:ikleeralles/logic/managers/platform.dart';
import 'package:ikleeralles/pages/register/forms/base.dart';
import 'package:ikleeralles/pages/register/registration.dart';
import 'package:ikleeralles/ui/themed/select.dart';

class ScholarRegisterForm extends RegisterForm {

  ScholarRegisterForm ( { PlatformDataProvider platformDataProvider, Function(ScholarRegistration) onSignInPressed } ) : super(
    platformDataProvider: platformDataProvider,
    onSignInPressed: onSignInPressed
  );

  @override
  State<StatefulWidget> createState() {
    return ScholarRegisterFormState();
  }

}

class ScholarRegisterFormState extends RegisterFormState<ScholarRegistration> {

  ValueNotifier<String> _yearNotifier;

  ValueNotifier<String> _levelNotifier;

  @override
  void initState() {

    _yearNotifier = ValueNotifier<String>(widget.platformDataProvider.years.first);
    _levelNotifier = ValueNotifier<String>(widget.platformDataProvider.levels.first);

    super.initState();
  }

  Widget yearSelectBox() {
    return ThemedSelect.selectBox(
      labelText: FlutterI18n.translate(context, TranslationKeys.year),
      options: this.widget.platformDataProvider.years,
      notifier: _yearNotifier,
    );
  }

  Widget levelSelectBox() {
    return ThemedSelect.selectBox(
      labelText: FlutterI18n.translate(context, TranslationKeys.level),
      options: this.widget.platformDataProvider.levels,
      notifier: _levelNotifier,
    );
  }

  @override
  List<Widget> children(BuildContext context) {
    return <Widget>[
      usernameTextField(),
      passwordTextField(),
      emailTextField(),
      levelSelectBox(),
      yearSelectBox(),
      signUpButton()
    ];
  }



  @override
  ScholarRegistration getData() {
    return ScholarRegistration(
      email: emailTextController.text,
      password: passwordTextController.text,
      username: usernameTextController.text,
      level: _levelNotifier.value,
      year: int.parse(_yearNotifier.value),
    );
  }

}
