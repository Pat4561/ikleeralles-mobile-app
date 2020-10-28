import 'package:flutter/material.dart';
import 'package:ikleeralles/constants.dart';
import 'package:ikleeralles/logic/quiz/checker.dart';
import 'package:ikleeralles/logic/quiz/input.dart';
import 'package:ikleeralles/ui/themed/button.dart';

typedef AnswerCheckCallback = Function(QuizQuestion);

abstract class AnswerCheckActions extends StatelessWidget {

  final AnswerCheckCallback onIncorrectAnswer;
  final AnswerCheckCallback onCorrectAnswer;
  final QuizQuestion question;

  AnswerCheckActions (this.question, { @required this.onCorrectAnswer, @required this.onIncorrectAnswer });

}

class ManualAnswerCheckActions extends AnswerCheckActions {

  ManualAnswerCheckActions (QuizQuestion question, { AnswerCheckCallback onIncorrectAnswer, AnswerCheckCallback onCorrectAnswer }) : super(question, onIncorrectAnswer: onIncorrectAnswer, onCorrectAnswer: onCorrectAnswer);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          child: ThemedButton(
            "Goed",
            buttonColor: Colors.green,
            borderRadius: BorderRadius.circular(12),
            onPressed: () => onCorrectAnswer(this.question),
          ),
        ),
        SizedBox(width: 30),
        Expanded(
          child: ThemedButton(
            "Fout",
            buttonColor: Colors.red,
            borderRadius: BorderRadius.circular(12),
            onPressed: () => onIncorrectAnswer(this.question),
          ),
        )
      ],
    );
  }

}


typedef AnswerGetterDelegate = String Function();

class AutomaticAnswerCheckActions extends AnswerCheckActions {

  final AnswerChecker checker;

  final AnswerGetterDelegate answerGetter;

  final QuizQuestion question;

  AutomaticAnswerCheckActions (this.question, { @required this.answerGetter, @required this.checker, AnswerCheckCallback onIncorrectAnswer, AnswerCheckCallback onCorrectAnswer }) : super(question, onIncorrectAnswer: onIncorrectAnswer, onCorrectAnswer: onCorrectAnswer);

  void _onPressed(BuildContext context) {
    String answer = answerGetter();
    if (checker.correct(question, answer)) {
      onCorrectAnswer(question);
    } else {
      onIncorrectAnswer(question);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ThemedButton(
      "Controleer",
      buttonColor: BrandColors.secondaryButtonColor,
      borderRadius: BorderRadius.circular(12),
      onPressed: () => _onPressed(context),
    );
  }

}