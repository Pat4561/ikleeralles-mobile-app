import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:ikleeralles/logic/quiz_options.dart';
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

  QuizQuestion ({ @required this.exerciseList, @required this.set });

}

class QuizInput {

  final List<ExerciseList> exerciseLists;

  QuizDirectionTypeGenerator _directionTypeGenerator;

  Map<QuizDirectionType, QuizDirection> _directionNamesMap;

  Map<QuizType, String> _quizTypes;

  Map<ExerciseList, ExerciseDetails> _questionsInfo = Map<ExerciseList, ExerciseDetails>();

  QuizInput (this.exerciseLists) {
    _directionTypeGenerator = QuizDirectionTypeGenerator(this.exerciseLists.first);
  }

  void initialize(BuildContext context) {
    for (ExerciseList exerciseList in this.exerciseLists) {
      _questionsInfo[exerciseList] = ExerciseDetails(exerciseList.content);
    }
    _directionNamesMap = _directionTypeGenerator.generate(context);
    _quizTypes = {
      QuizType.inMind: FlutterI18n.translate(context, TranslationKeys.quizTypeInMind),
      QuizType.quiz: FlutterI18n.translate(context, TranslationKeys.quizTypeTest)
    };
  }


  List<QuizQuestion> select(QuizSelectionRange range) {
    List<QuizQuestion> questions = [];
    _questionsInfo.forEach((exerciseList, details) {
     var listQuestions = details.sets.map((ExerciseSet set) => QuizQuestion(
       exerciseList: exerciseList,
       set: set
     )).toList();
     questions.addAll(listQuestions);
    });
    return questions.getRange(range.startIndex, range.endIndex).toList();
  }

  Map<QuizDirectionType, QuizDirection> get directionNamesMapping => _directionNamesMap;

  int get questionsCount {
    int sum = 0;
    _questionsInfo.forEach((k, v) => sum += v.sets.length);
    return sum;
  }

  int get divisions {
    int count = this.questionsCount;
    if (count < 10) {
      return 2;
    } else if (count < 30) {
      return 5;
    } else {
      return 10;
    }
  }

  Map<QuizType, String> get quizTypes => _quizTypes;




}