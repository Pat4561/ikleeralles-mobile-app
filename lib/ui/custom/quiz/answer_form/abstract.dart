import 'package:flutter/material.dart';

abstract class AnswerForm extends StatefulWidget {

  AnswerForm ({ GlobalKey key }) : super(key: key);

}

abstract class AnswerFormState<T, Z extends AnswerForm> extends State<Z> {

  T getAnswer();

}
