import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:ikleeralles/constants.dart';
import 'package:ikleeralles/logic/managers/platform.dart';
import 'package:ikleeralles/logic/quiz/input.dart';
import 'package:ikleeralles/logic/quiz/result.dart';
import 'package:ikleeralles/network/models/exercise_list.dart';
import 'package:ikleeralles/ui/custom/quiz/grade_color.dart';
import 'package:ikleeralles/ui/dialogs/navigation_dialog.dart';
import 'package:ikleeralles/ui/tables/quiz_result/combined.dart';
import 'package:ikleeralles/ui/tables/quiz_result/error_overview.dart';
import 'package:ikleeralles/ui/themed/button.dart';


abstract class QuizResultFactory {

  final QuizResult result;

  final Function redoQuiz;

  final Function quizErrors;

  DialogFragmentsManager _manager;

  DialogFragmentsManager get manager => _manager;

  QuizResultFactory (this.result, { @required this.redoQuiz, @required this.quizErrors }) {
    _manager = createManager();
  }

  DialogFragmentsManager createManager();

}

abstract class MainResultFragment extends DialogFragment {

  final QuizResult result;

  final Function redoQuiz;
  final Function(List<QuizQuestion>) quizErrors;

  MainResultFragment (this.result, { @required this.redoQuiz, @required this.quizErrors });

  Widget actionsBar(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 20, right: 20, bottom: 10, top: 10),
      child: Row(
        children: <Widget>[
          ThemedButton(
            FlutterI18n.translate(context, TranslationKeys.again),
            buttonColor: BrandColors.secondaryButtonColor,
            borderRadius: BorderRadius.circular(8),
            onPressed: redoQuiz,
          ),
          SizedBox(width: 10),
          Visibility(child: Expanded(child: ThemedButton(
            FlutterI18n.translate(context, TranslationKeys.quizErrors),
            buttonColor: BrandColors.secondaryButtonColor,
            borderRadius: BorderRadius.circular(8),
            onPressed: () => quizErrors(result.set.answers.incorrectAnsweredQuestions),
          )), visible: result.set.answers.incorrectAnsweredQuestions.length > 0)
        ],
      ),
    );
  }

}

class SingleQuizResultFragment extends MainResultFragment {

  SingleQuizResultFragment (QuizResult result, { Function redoQuiz, Function quizErrors }) : super(result, redoQuiz: redoQuiz, quizErrors: quizErrors);

  @override
  Widget builder(BuildContext context) {
    return Column(
      children: <Widget>[
        _MainResultCell(
          translated: result.input.exerciseLists.first.translated,
          directionType: result.input.directionNamesMapping[result.options.directionType].hint,
          original: result.input.exerciseLists.first.original,
          totalQuestionsCount: result.set.totalQuestionsCount,
          grade: result.grade.value,
          platformDataProvider: result.input.platformDataProvider,
          name: result.title,
        ),
        Visibility(child: ErrorOverviewList(
          result: result,
          items: result.set.answers.incorrectAnsweredQuestions.toSet().toList(),
        ), visible: result.set.answers.incorrectAnsweredQuestions.length > 0),
        actionsBar(context)
      ],
    );
  }

}

class CombinedQuizResultFragment extends MainResultFragment {

  final Function(BuildContext context, ExerciseList) showDetails;

  CombinedQuizResultFragment (QuizResult result, { Function redoQuiz, Function quizErrors, this.showDetails }) : super(result, redoQuiz: redoQuiz, quizErrors: quizErrors);

  @override
  Widget builder(BuildContext context) {
    return Column(
      children: <Widget>[
        _MainResultCell(
          translated: result.input.exerciseLists.first.translated,
          directionType: result.input.directionNamesMapping[result.options.directionType].hint,
          original: result.input.exerciseLists.first.original,
          totalQuestionsCount: result.set.totalQuestionsCount,
          grade: result.grade.value,
          name: result.title,
          platformDataProvider: result.input.platformDataProvider,
        ),
        CombinedResultDetailsList(
          result,
          showDetails: showDetails,
        ),
        actionsBar(context)
      ],
    );
  }

}

class ErrorDetailsFragment extends DialogFragment {

  final QuizResult resultOverview;

  final Function(List<QuizQuestion> questions) quizErrors;

  ErrorDetailsFragment (this.resultOverview, { @required this.quizErrors });

  @override
  Widget builder(BuildContext context) {
    return Column(
      children: <Widget>[
        ErrorOverviewList(
          result: resultOverview,
          items: resultOverview.set.answers.incorrectAnsweredQuestions.toSet().toList(),
        ),
        Container(
          padding: EdgeInsets.only(left: 20, right: 20, bottom: 10, top: 10),
          child: Row(
            children: <Widget>[
              Visibility(child: Expanded(child: ThemedButton(
                FlutterI18n.translate(context, TranslationKeys.quizErrors),
                buttonColor: BrandColors.secondaryButtonColor,
                borderRadius: BorderRadius.circular(8),
                onPressed: () => quizErrors(resultOverview.set.answers.incorrectAnsweredQuestions),
              )), visible: resultOverview.set.answers.incorrectAnsweredQuestions.length > 0)
            ],
          ),
        )
      ],
    );
  }

}

class SingleQuizResultFactory extends QuizResultFactory {


  SingleQuizResultFactory(QuizResult result, { Function redoQuiz, Function quizErrors }) : super(result, redoQuiz: redoQuiz, quizErrors: quizErrors);

  @override
  DialogFragmentsManager createManager() {
    return DialogFragmentsManager(SingleQuizResultFragment(result, redoQuiz: redoQuiz, quizErrors: quizErrors));
  }

}

class CombinedQuizResultFactory extends QuizResultFactory {

  CombinedQuizResultFactory(QuizResult result, { Function redoQuiz, Function quizErrors }) : super(result, redoQuiz: redoQuiz, quizErrors: quizErrors);

  void _showDetails(context, exerciseList) {
    manager.presentNew(
      ErrorDetailsFragment(
        result.filter(exerciseList),
        quizErrors: quizErrors
      )
    );
  }

  @override
  DialogFragmentsManager createManager() {
    return DialogFragmentsManager(CombinedQuizResultFragment(
        result,
        redoQuiz: redoQuiz,
        quizErrors: quizErrors,
        showDetails: _showDetails
    ));
  }

}


class _MainResultCell extends StatelessWidget {

  final String name;
  final String original;
  final String translated;
  final double grade;
  final int totalQuestionsCount;
  final String directionType;
  final PlatformDataProvider platformDataProvider;

  _MainResultCell ({ @required this.name, @required this.original, @required this.translated, @required this.grade, @required this.totalQuestionsCount, @required this.directionType, @required this.platformDataProvider });

  Widget _gradeBox(String text, { double size, TextStyle textStyle, BoxDecoration decoration }) {
    return Container(
      width: size,
      height: size,
      decoration: decoration,
      child: Center(
        child: Text(text, style: textStyle),
      ),
    );
  }

  Widget _languageLabel({ String language, String caption }) {
    return Row(
      children: <Widget>[
        Text(
          caption,
          style: TextStyle(
              fontFamily: Fonts.ubuntu,
              fontWeight: FontWeight.bold,
              fontSize: 13
          ),
        ),
        SizedBox(width: 6),
        Text(
          language,
          style: TextStyle(
              fontFamily: Fonts.ubuntu,
              fontSize: 13
          ),
        )
      ],
    );
  }


  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
          border: Border(
              bottom: BorderSide(
                  color: BrandColors.borderColor
              )
          )
      ),
      child: Row(
        children: <Widget>[
          Container(
            constraints: BoxConstraints(
              maxWidth: 70
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                _gradeBox(this.grade.toString(),
                    size: 50,
                    decoration: BoxDecoration(
                        color: GradeColor(this.grade).value,
                        borderRadius: BorderRadius.circular(25)
                    ),
                    textStyle: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        fontFamily: Fonts.ubuntu
                    )
                ),
                SizedBox(height: 6),
                Text(FlutterI18n.translate(context, TranslationKeys.questions, { "count": totalQuestionsCount.toString() }), style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                    fontFamily: Fonts.ubuntu
                ), textAlign: TextAlign.center)
              ],
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.only(left: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Container(
                        child: Text(this.name, style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            fontFamily: Fonts.ubuntu
                        )),
                        margin: EdgeInsets.only(
                            bottom: 5
                        ),
                      ),
                      _languageLabel(language: platformDataProvider.languageData.get(this.original), caption: FlutterI18n.translate(context, TranslationKeys.term)),
                      _languageLabel(language: platformDataProvider.languageData.get(this.translated), caption: FlutterI18n.translate(context, TranslationKeys.definition)),
                      Container(
                        margin: EdgeInsets.only(
                          top: 10
                        ),
                        child: Text(
                          directionType,
                          style: TextStyle(
                              fontFamily: Fonts.ubuntu,
                              fontSize: 13
                          ),
                        ),
                      )

                    ],
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

}





