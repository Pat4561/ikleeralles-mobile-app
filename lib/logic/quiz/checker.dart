import 'package:flutter/material.dart';
import 'package:diacritic/diacritic.dart';
import 'package:ikleeralles/logic/quiz/input.dart';
import 'package:ikleeralles/logic/quiz/options.dart';

class AnswerChecker {

  final QuizCorrectionOptions options;

  AnswerChecker ({ @required this.options });

  String _prepare(String value) {
    value = value.trim();

    if (!options.correctCapitals) {
      value = value.toLowerCase();
    }

    if (!options.correctAccents) {
      value = removeDiacritics(value);
    }

    return value;
  }

  bool _equals(String compareA, String compareB) {
    return _prepare(compareA) == _prepare(compareB);
  }

  bool correct(QuizQuestion question, String input) {
    var possibleAnswers = question.answers;

    for (var answer in possibleAnswers) {
      if (_equals(answer, input)) {
        return true;
      }
    }

    return false;
  }

}