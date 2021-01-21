import 'package:flutter/material.dart';
import 'package:ikleeralles/logic/managers/platform.dart';
import 'package:ikleeralles/pages/register/forms/base.dart';
import 'package:ikleeralles/pages/register/registration.dart';

class TeacherRegisterForm extends RegisterForm {

  TeacherRegisterForm ( { PlatformDataProvider platformDataProvider, Function(TeacherRegistration) onSignInPressed } ) : super(
      platformDataProvider: platformDataProvider,
      onSignInPressed: onSignInPressed
  );

  @override
  State<StatefulWidget> createState() {
    return TeacherRegisterFormState();
  }

}

class TeacherRegisterFormState extends RegisterFormState<TeacherRegistration> {

  @override
  TeacherRegistration getData() {
    return TeacherRegistration(
        email: emailTextController.text,
        password: passwordTextController.text,
        username: usernameTextController.text
    );
  }

}
