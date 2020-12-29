import 'dart:math';
import 'package:flutter/material.dart';
import 'package:ikleeralles/logic/quiz/input.dart';
import 'package:ikleeralles/network/models/exercise_list.dart';
import 'package:scoped_model/scoped_model.dart';

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

class QuestionResponse {

  final QuizQuestion question;
  final bool isCorrect;

  QuestionResponse (this.question, { @required this.isCorrect });

}

class QuizSet extends Model {

  QuizAnswers answers = QuizAnswers();

  final List<QuizQuestion> inputQuestions;

  final bool repeatQuestionsTillAllCorrect;

  int _askedQuestionsCount = 1;

  List<QuizQuestion> _upcomingQuestions;

  QuestionResponse _lastAnswered;

  QuizSet (this.inputQuestions, { this.repeatQuestionsTillAllCorrect = false }) {
    _upcomingQuestions = List.of(this.inputQuestions);
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

  int get askedQuestionsCount {
    return _askedQuestionsCount;
  }

  bool get previousAnswerWasIncorrect {
    return _lastAnswered != null ? !_lastAnswered.isCorrect : false;
  }

  void randomizeQuestions() {
    _upcomingQuestions.shuffle();
  }

  void unMarkAsIncorrectAnswer() {
    this.answers.unMarkIncorrectAnswer(_lastAnswered.question);
    _upcomingQuestions.removeWhere((value) => value == _lastAnswered.question);
    notifyListeners();
  }

  QuizSet filter(ExerciseList exerciseList) {
    return QuizSet(
      inputQuestions.where((quizQuestion) => quizQuestion.exerciseList == exerciseList).toList(),
      repeatQuestionsTillAllCorrect: repeatQuestionsTillAllCorrect
    );
  }

  void repeatQuestionSomewhere(QuizQuestion question) {
    //first question is the current question now

    if (_upcomingQuestions.length > 1) {
      int min = 1;
      int randomIndex = min + Random().nextInt(_upcomingQuestions.length - min);
      _upcomingQuestions.insert(randomIndex, question);
    } else {
      _upcomingQuestions.add(question);
    }

    notifyListeners();

  }

  void answerQuestion(bool isCorrect) {

    if (!isCorrect) {
      this.answers.markIncorrectAnswer(currentQuestion);
    } else {
      this.answers.markCorrectAnswer(currentQuestion);
    }

    _lastAnswered = QuestionResponse(currentQuestion, isCorrect: isCorrect);
    notifyListeners();

  }

  void quizErrors(List<QuizQuestion> questions) {


    List<String> questionTitles = questions.map((e) => e.title).toList();

    List<QuizQuestion> questionsToAsk = this.inputQuestions.where((element) {
      return questionTitles.contains(element.title);
    }).toList();

    _upcomingQuestions = List.of(questionsToAsk);
    _lastAnswered = null;
    _askedQuestionsCount = 0;
    answers = QuizAnswers();
    randomizeQuestions();
    notifyListeners();
  }

  void reset() {
    _upcomingQuestions = List.of(this.inputQuestions);
    _lastAnswered = null;
    _askedQuestionsCount = 0;
    answers = QuizAnswers();
    randomizeQuestions();
    notifyListeners();
  }

  void nextQuestion() {
    _upcomingQuestions.remove(currentQuestion);
    _askedQuestionsCount += 1;
    if (!_lastAnswered.isCorrect) {
      if (this.repeatQuestionsTillAllCorrect) {
        repeatQuestionSomewhere(_lastAnswered.question);
      }
    }
    notifyListeners();
  }



}
