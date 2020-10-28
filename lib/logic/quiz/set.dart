import 'dart:math';

import 'package:ikleeralles/logic/quiz/input.dart';

class QuizAnswers {

  final List<QuizQuestion> correctAnsweredQuestions = [];
  final List<QuizQuestion> incorrectAnsweredQuestions = [];

  void markCorrectAnswer(QuizQuestion question) {
    correctAnsweredQuestions.add(question);
  }

  void markIncorrectAnswer(QuizQuestion question) {
    incorrectAnsweredQuestions.add(question);
  }

  void unMarkIncorrectAnswer(QuizQuestion question) {
    incorrectAnsweredQuestions.removeWhere((question) => question == question);
  }
}

class QuizSet {

  final QuizAnswers answers = QuizAnswers();

  final List<QuizQuestion> inputQuestions;

  final bool repeatQuestionsTillAllCorrect;

  List<QuizQuestion> _upcomingQuestions;

  QuizQuestion _lastAnsweredQuestion;

  QuizSet (this.inputQuestions, { this.repeatQuestionsTillAllCorrect = false }) {
    _upcomingQuestions = this.inputQuestions;
    randomizeQuestions();
  }

  QuizQuestion get currentQuestion {
    if (_upcomingQuestions.length > 0) {
      return _upcomingQuestions.first;
    }
    return null;
  }

  int get totalQuestionsCount {
    return answeredQuestionsCount + upcomingQuestionsCount;
  }

  int get upcomingQuestionsCount {
    return _upcomingQuestions.length;
  }

  int get errorCount {
    return answers.incorrectAnsweredQuestions.length;
  }

  int get answeredQuestionsCount {
    return answers.incorrectAnsweredQuestions.length + answers.correctAnsweredQuestions.length + 1;
  }

  void randomizeQuestions() {
    _upcomingQuestions.shuffle();
  }

  void unMarkAsIncorrectAnswer() {
    this.answers.unMarkIncorrectAnswer(_lastAnsweredQuestion);
    _upcomingQuestions.removeWhere((value) => value == _lastAnsweredQuestion);
  }

  void repeatQuestionSomewhere(QuizQuestion question) {
    _upcomingQuestions.insert(Random().nextInt(_upcomingQuestions.length), question);
  }

  void answerQuestion(bool isCorrect) {

    if (!isCorrect) {
      this.answers.markIncorrectAnswer(currentQuestion);
      if (this.repeatQuestionsTillAllCorrect) {
        repeatQuestionSomewhere(currentQuestion);
      }
    } else {
      this.answers.markCorrectAnswer(currentQuestion);
    }

    _lastAnsweredQuestion = currentQuestion;

  }

  void nextQuestion() {
    _upcomingQuestions.remove(currentQuestion);
  }


}