import 'package:flutter/material.dart';
import 'package:ikleeralles/logic/quiz/checker.dart';
import 'package:ikleeralles/logic/quiz/hint.dart';
import 'package:ikleeralles/logic/quiz/input.dart';
import 'package:ikleeralles/logic/quiz/options.dart';
import 'package:ikleeralles/logic/quiz/result.dart';
import 'package:ikleeralles/logic/quiz/set.dart';
import 'package:ikleeralles/ui/custom/quiz/answer_check.dart';
import 'package:ikleeralles/ui/custom/quiz/answer_form/abstract.dart';
import 'package:ikleeralles/ui/custom/quiz/answer_form/open_answer_form.dart';

abstract class QuizBuilder {

  final QuizOptions options;

  final QuizInput quizInput;

  AnswerChecker _answerChecker;

  AnswerChecker get answerChecker => _answerChecker;

  HintGenerator _hintGenerator;

  HintGenerator get hintGenerator => _hintGenerator;

  QuizSet _quizSet;

  QuizSet get quizSet => _quizSet;

  QuizBuilder ({ this.quizInput, this.options }) {
    _quizSet = QuizSet(
        quizInput.select(
            range: options.range,
            directionType: options.directionType
        ),
        repeatQuestionsTillAllCorrect: options.mainOptions.repeatQuestionsTillAllCorrect
    );

    _hintGenerator = HintGenerator(
        showFirstLetter: options.hintOptions.showFirstLetterAsHint,
        showVowels: options.hintOptions.showVowelsAsHint
    );

    _answerChecker = AnswerChecker(
      options: options.correctionOptions
    );
  }

  QuizResult getResult() {
    return QuizResult(
      _quizSet,
      input: this.quizInput,
      options: this.options,
    );
  }

  static QuizBuilder create({ QuizOptions options, QuizInput quizInput }) {
    QuizBuilder builder;
    if (options.quizType == QuizType.inMind) {
      builder = CardQuizBuilder(
          options: options,
          quizInput: quizInput
      );
    } else if (options.quizType == QuizType.quiz) {
      builder = StandardQuizBuilder(
          options: options,
          quizInput: quizInput
      );
    }
    return builder;
  }

  AnswerForm formBuilder({ GlobalKey<AnswerFormState> key, Function onEnterPressed });

  AnswerCheckActions actionsBuilder({ AnswerCheckCallback onIncorrectAnswer, AnswerCheckCallback onCorrectAnswer, AnswerGetterDelegate answerGetter });


}

class CardQuizBuilder extends QuizBuilder {

  CardQuizBuilder ({ QuizInput quizInput, QuizOptions options }) : super(quizInput: quizInput, options: options);

  @override
  AnswerCheckActions actionsBuilder({ AnswerCheckCallback onIncorrectAnswer, AnswerCheckCallback onCorrectAnswer, AnswerGetterDelegate answerGetter}) {
    return ManualAnswerCheckActions(
      _quizSet.currentQuestion,
      onIncorrectAnswer: onIncorrectAnswer,
      onCorrectAnswer: onCorrectAnswer,
    );
  }

  @override
  AnswerForm formBuilder({GlobalKey<AnswerFormState> key, Function onEnterPressed}) {
    return null;
  }

}

class StandardQuizBuilder extends QuizBuilder {

  StandardQuizBuilder ({ QuizInput quizInput, QuizOptions options }) : super(quizInput: quizInput, options: options);

  @override
  AnswerCheckActions actionsBuilder({AnswerCheckCallback onIncorrectAnswer, AnswerCheckCallback onCorrectAnswer, AnswerGetterDelegate answerGetter }) {
    return AutomaticAnswerCheckActions(
      quizSet.currentQuestion,
      checker: answerChecker,
      answerGetter: answerGetter,
      onIncorrectAnswer: onIncorrectAnswer,
      onCorrectAnswer: onCorrectAnswer,
    );
  }

  @override
  AnswerForm formBuilder({GlobalKey<AnswerFormState> key, Function onEnterPressed}) {
    return OpenAnswerForm(
      key: key,
      onEnterPressed: onEnterPressed
    );
  }

}