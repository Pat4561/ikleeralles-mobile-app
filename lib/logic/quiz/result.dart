import 'package:flutter/material.dart';
import 'package:ikleeralles/logic/quiz/input.dart';
import 'package:ikleeralles/logic/quiz/options.dart';
import 'package:ikleeralles/logic/quiz/set.dart';
import 'package:ikleeralles/network/models/exercise_list.dart';

class Grade {

  double _value;

  double get value => _value;

  final int correctAnsweredQuestionsCount;
  final int incorrectAnsweredQuestionsCount;

  Grade ({ this.correctAnsweredQuestionsCount, this.incorrectAnsweredQuestionsCount }) {
    _value = _calculate();
  }

  static Grade fromQuizAnswers(QuizAnswers answers) {
    return Grade(
      correctAnsweredQuestionsCount: answers.correctAnsweredQuestions.length,
      incorrectAnsweredQuestionsCount: answers.incorrectAnsweredQuestions.length
    );
  }

  double _calculate() {
    double v = (correctAnsweredQuestionsCount / (correctAnsweredQuestionsCount + incorrectAnsweredQuestionsCount)) * 10;
    double n = num.parse(v.toStringAsFixed(1));
    return n;
  }
}

class SummedAnswerOverview {

  int correctAnswersCount = 0;
  int incorrectAnswersCount = 0;

}

class ExerciseResultOverview {

  final Map<QuizQuestion, SummedAnswerOverview> _map = Map<QuizQuestion, SummedAnswerOverview>();

  int _incorrectAnswersCount = 0;
  int get incorrectAnswersCount => _incorrectAnswersCount;

  int _correctAnswersCount = 0;
  int get correctAnswersCount => _correctAnswersCount;

  int get totalAnswersCount => _incorrectAnswersCount + _correctAnswersCount;

  Grade generateGrade() {
    return Grade(
      correctAnsweredQuestionsCount: _correctAnswersCount,
      incorrectAnsweredQuestionsCount: _incorrectAnswersCount
    );
  }

  SummedAnswerOverview find(QuizQuestion question) {
    return _map[question];
  }

  void report(QuizQuestion question, { @required bool isCorrect }) {
    if (!_map.containsKey(question)) {
      _map[question] = SummedAnswerOverview();
    }

    if (isCorrect) {
      _map[question].correctAnswersCount += 1;
      _correctAnswersCount += 1;
    } else {
      _map[question].incorrectAnswersCount += 1;
      _incorrectAnswersCount += 1;
    }


  }




}

class QuizResultMap {

  Map<ExerciseList, ExerciseResultOverview> _resultMap = Map<ExerciseList, ExerciseResultOverview>();

  Map<ExerciseList, ExerciseResultOverview> get value => _resultMap;

  final QuizSet set;

  QuizResultMap (this.set) {
    set.answers.incorrectAnsweredQuestions.forEach((question) => _saveInMap(question, isCorrect: false));
    set.answers.correctAnsweredQuestions.forEach((question) => _saveInMap(question, isCorrect: true));
  }

  void _saveInMap(QuizQuestion question, { bool isCorrect = false }) {
    if (!_resultMap.containsKey(question.exerciseList)) {
      _resultMap[question.exerciseList] = ExerciseResultOverview();
    }

    ExerciseResultOverview resultOverview = _resultMap[question.exerciseList];
    resultOverview.report(
      question,
      isCorrect: isCorrect
    );

  }

  bool get isCombined => _resultMap.keys.length > 1;


}

class QuizResult {

  Grade _grade;
  Grade get grade => _grade;

  QuizResultMap _resultMap;
  QuizResultMap get resultMap => _resultMap;

  String get title => input.title;

  final QuizSet set;
  final QuizOptions options;
  final QuizInput input;

  QuizResult (this.set, { @required this.options, @required this.input }) {
    _grade = Grade.fromQuizAnswers(set.answers);
    _resultMap = QuizResultMap(this.set);
  }

  bool get isCombined => _resultMap.isCombined;

  QuizResult filter(ExerciseList exerciseList) {
    return QuizResult(
      set.filter(exerciseList),
      options: options,
      input: input.filter(exerciseList)
    );
  }

}