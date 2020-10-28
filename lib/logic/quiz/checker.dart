import 'package:flutter/material.dart';
import 'package:ikleeralles/logic/quiz/input.dart';
import 'package:ikleeralles/logic/quiz/options.dart';

class AnswerChecker {

  final QuizCorrectionOptions options;

  AnswerChecker ({ @required this.options });

  bool correct(QuizQuestion question, String input) {
    var possibleAnswers = question.answers;
    //TODO: Discuss and implemtn correciton mechanism

    if (options.correctCapitals) {

    }

    if (options.correctAccents) {

    }

    return true;
  }

}