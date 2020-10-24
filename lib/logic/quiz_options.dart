import 'package:flutter/foundation.dart';
import 'package:ikleeralles/logic/quiz_input.dart';

class QuizSelectionRange {

  final int startIndex;
  final int endIndex;

  QuizSelectionRange ({ @required this.startIndex, @required this.endIndex });

}

class QuizHintOptions {

  final bool showVowelsAsHint;
  final bool showFirstLetterAsHint;

  QuizHintOptions ({ @required this.showVowelsAsHint, @required this.showFirstLetterAsHint });

}

class QuizCorrectionOptions {

  final bool correctCapitals;
  final bool correctAccents;

  QuizCorrectionOptions ({ @required this.correctAccents, @required this.correctCapitals });
}

class QuizMainOptions {

  final bool repeatQuestionsTillAllCorrect;

  QuizMainOptions ({ @required this.repeatQuestionsTillAllCorrect });

}

class QuizQuestionVisibilityOptions {

  final bool useEnterToGoToNext;
  final int timeCorrectAnswerVisible;
  final int timeIncorrectAnswerVisible;

  QuizQuestionVisibilityOptions ({ @required this.useEnterToGoToNext, @required this.timeCorrectAnswerVisible, @required this.timeIncorrectAnswerVisible });

}


class QuizOptions {

  final QuizType quizType;
  final QuizDirectionType directionType;
  final QuizSelectionRange range;
  final QuizHintOptions hintOptions;
  final QuizCorrectionOptions correctionOptions;
  final QuizMainOptions mainOptions;
  final QuizQuestionVisibilityOptions visibilityOptions;

  QuizOptions ({ @required this.quizType, @required this.directionType, @required this.range, @required this.hintOptions, @required this.correctionOptions, @required this.mainOptions, @required this.visibilityOptions });

}
