import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:ikleeralles/logic/quiz/options.dart';
import 'package:ikleeralles/network/models/exercise_list.dart';
import 'package:ikleeralles/constants.dart';

enum QuizDirectionType {
  originalToTranslation,
  translationToOriginal,
  mixed
}

class QuizDirection {

  final String hint;
  final String name;

  QuizDirection ({ @required this.name, @required this.hint});

}

class QuizDirectionTypeGenerator {

  final ExerciseList exerciseList;

  QuizDirectionTypeGenerator (this.exerciseList);

  Map<QuizDirectionType, QuizDirection> generate(BuildContext context) {
    String original = "${exerciseList.original} - ${exerciseList.translated}";
    String translated = "${exerciseList.translated} - ${exerciseList.original}";
    return {
      QuizDirectionType.originalToTranslation: QuizDirection(
          name: original,
          hint: FlutterI18n.translate(context, TranslationKeys.termToDefinition)
      ),
      QuizDirectionType.translationToOriginal: QuizDirection(
          name: translated,
          hint: FlutterI18n.translate(context, TranslationKeys.definitionToTerm)
      ),
      QuizDirectionType.mixed: QuizDirection(
          name: FlutterI18n.translate(context, TranslationKeys.mixed),
          hint: FlutterI18n.translate(context, TranslationKeys.bothDirections)
      )
    };
  }

}

enum QuizType {
  quiz,
  inMind
}

class QuizQuestion {

  final ExerciseList exerciseList;
  final ExerciseSet set;
  final String title;
  final String language;
  final List<String> answers;

  QuizQuestion ({ @required this.exerciseList, @required this.set, @required this.title, @required this.answers, @required this.language });

}

class QuizQuestionCollection {

  Map<ExerciseList, ExerciseDetails> _questionsInfo = Map<ExerciseList, ExerciseDetails>();

  List<QuizQuestion> _reversedQuestions = [];
  List<QuizQuestion> _defaultQuestions = [];

  void initialize(List<ExerciseList> exerciseLists) {
    for (ExerciseList exerciseList in exerciseLists) {
      _questionsInfo[exerciseList] = ExerciseDetails(exerciseList.content);
    }

    List<QuizQuestion> defaultQuestions = [];
    List<QuizQuestion> reversedQuestions = [];
    _questionsInfo.forEach((exerciseList, details) {

      details.sets.forEach((set) {
        defaultQuestions.add(QuizQuestion(
            exerciseList: exerciseList,
            set: set,
            title: set.original.join(", "),
            language: exerciseList.original,
            answers: set.translated
        ));

        reversedQuestions.add(QuizQuestion(
            exerciseList: exerciseList,
            set: set,
            title: set.translated.join(", "),
            language: exerciseList.translated,
            answers: set.original
        ));
      });

    });

    _defaultQuestions = defaultQuestions;
    _reversedQuestions = reversedQuestions;
  }

  List<QuizQuestion> get({ @required QuizDirectionType directionType }) {
    List<QuizQuestion> questions = [];
    if (directionType == QuizDirectionType.originalToTranslation) {
      questions.addAll(_defaultQuestions);
    } else if (directionType == QuizDirectionType.translationToOriginal) {
      questions.addAll(_reversedQuestions);
    } else if (directionType == QuizDirectionType.mixed) {
      questions.addAll(_defaultQuestions);
      questions.addAll(_reversedQuestions);
    }
    return questions;
  }

  int count({ @required QuizDirectionType directionType }) {
    if (directionType == QuizDirectionType.mixed) {
      return _defaultQuestions.length + _reversedQuestions.length;
    } else if (directionType == QuizDirectionType.translationToOriginal) {
      return _reversedQuestions.length;
    } else if (directionType == QuizDirectionType.originalToTranslation) {
      return _defaultQuestions.length;
    }
    throw Exception("Not valid type!");
  }



}

class QuizInput {


  final List<ExerciseList> exerciseLists;

  final QuizQuestionCollection _questionCollection = QuizQuestionCollection();

  QuizDirectionTypeGenerator _directionTypeGenerator;

  Map<QuizDirectionType, QuizDirection> _directionNamesMap;

  Map<QuizType, String> _quizTypes;

  String _title;


  QuizInput (this.exerciseLists) {
    _directionTypeGenerator = QuizDirectionTypeGenerator(this.exerciseLists.first);
  }

  void initialize(BuildContext context) {

    _questionCollection.initialize(this.exerciseLists);

    _directionNamesMap = _directionTypeGenerator.generate(context);

    _quizTypes = {
      QuizType.inMind: FlutterI18n.translate(context, TranslationKeys.quizTypeInMind),
      QuizType.quiz: FlutterI18n.translate(context, TranslationKeys.quizTypeTest)
    };

    if (this.exerciseLists.length > 1) {
      _title = FlutterI18n.translate(context, TranslationKeys.combinedQuiz);
    } else if (this.exerciseLists.length == 1) {
      _title = this.exerciseLists.first.name;
    }

  }

  QuizInput filter(ExerciseList exerciseList) {
    return QuizInput([exerciseList]);
  }

  List<QuizQuestion> select({ @required QuizSelectionRange range, @required QuizDirectionType directionType }) {
    List<QuizQuestion> questions = _questionCollection.get(
      directionType: directionType
    );
    return questions.getRange(range.startIndex, range.endIndex).toList();
  }

  Map<QuizDirectionType, QuizDirection> get directionNamesMapping => _directionNamesMap;

  int count ({ @required QuizDirectionType directionType }) {
    return this._questionCollection.count(directionType: directionType);
  }

  int divisions ({ @required QuizDirectionType directionType }) {
    int count = this.count(directionType: directionType);
    if (count < 10) {
      return 2;
    } else if (count < 30) {
      return 5;
    } else {
      return 10;
    }
  }

  String get title {
    return _title;
  }

  Map<QuizType, String> get quizTypes => _quizTypes;




}