import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ikleeralles/constants.dart';
import 'package:ikleeralles/logic/quiz/set.dart';
import 'package:ikleeralles/ui/background_builder.dart';
import 'package:ikleeralles/ui/custom/quiz/answer_form/abstract.dart';
import 'package:ikleeralles/ui/custom/quiz/builder.dart';
import 'package:ikleeralles/ui/custom/quiz/question_presentation.dart';
import 'package:ikleeralles/ui/themed/button.dart';
import 'package:scoped_model/scoped_model.dart';

class QuizPage extends StatefulWidget {

  final QuizBuilder builder;

  QuizPage ({ @required this.builder });

  @override
  State<StatefulWidget> createState() {
    return QuizPageState();
  }

}


class _StatusBar extends StatelessWidget {

  final int upcomingQuestionsCount;
  final int errorCount;
  final int askedQuestionsCount;

  _StatusBar ({ @required this.upcomingQuestionsCount, @required this.errorCount, @required this.askedQuestionsCount });

  Widget _box({ @required String text, @required String value }) {
    return Expanded(
        child: Container(
          margin: EdgeInsets.all(20),
          child: Column(
            children: <Widget>[
              Container(
                child: Text(value.toString(), style: TextStyle(
                    fontFamily: Fonts.ubuntu,
                    fontWeight: FontWeight.bold,
                    fontSize: 24
                )),
                margin: EdgeInsets.only(
                    bottom: 5
                ),
              ),
              Text(text, style: TextStyle(
                fontFamily: Fonts.ubuntu,
                fontSize: 15,
              ))
            ],
          ),
        )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          border: Border(
              bottom: BorderSide(
                  width: 1,
                  color: BrandColors.borderColor
              )
          )
      ),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          _box(
            value: upcomingQuestionsCount.toString(),
            text: FlutterI18n.translate(context, TranslationKeys.upcoming)
          ),
          _box(
            value: errorCount.toString(),
            text: FlutterI18n.translate(context, TranslationKeys.errors)
          ),
          _box(
            value: askedQuestionsCount.toString(),
            text: FlutterI18n.translate(context, TranslationKeys.asked)
          )
        ],
      ),
    );
  }

}

abstract class _PresentationState {

  final QuizBuilder builder;

  _PresentationState (this.builder);

  Widget body(BuildContext context);

  Widget bottomBar(BuildContext context);

  Widget baseBottomBar({ @required Widget child }) {
    return BottomAppBar(
      color: Colors.white,
      elevation: 0,
      child: Container(
        decoration: BoxDecoration(
            border: Border(
                top: BorderSide(
                    color: BrandColors.borderColor,
                    width: 1
                )
            )
        ),
        padding: EdgeInsets.symmetric(
            horizontal: 15,
            vertical: 5
        ),
        child: child,
      ),
    );
  }

}

class _ActivePresentationState extends _PresentationState {


  final GlobalKey<QuizQuestionPresentationState> questionPresentationKey;
  final GlobalKey<AnswerFormState> answerFormKey;
  final Function onEnterPressed;
  final Function({ @required bool isCorrect, @required int transitionDelay }) answerQuestion;

  _ActivePresentationState (QuizBuilder builder, { this.questionPresentationKey, this.answerFormKey, this.onEnterPressed, this.answerQuestion }) : super(builder);

  @override
  Widget body(BuildContext context) {
    return QuizQuestionPresentation(
        builder.quizSet.currentQuestion,
        key: questionPresentationKey,
        hint: builder.hintGenerator.generate(builder.quizSet.currentQuestion),
        formBuilder: (BuildContext context) {
          return builder.formBuilder(key: answerFormKey, onEnterPressed:  onEnterPressed);
        }
    );
  }

  @override
  Widget bottomBar(BuildContext context) {
    return baseBottomBar(
      child: builder.actionsBuilder(
          onIncorrectAnswer: (question) => answerQuestion(isCorrect: false, transitionDelay: builder.options.visibilityOptions.timeIncorrectAnswerVisible),
          onCorrectAnswer: (question) => answerQuestion(isCorrect: true, transitionDelay: builder.options.visibilityOptions.timeCorrectAnswerVisible),
          answerGetter: () {
            return answerFormKey.currentState.getAnswer();
          }
      )
    );
  }
}

class _FinishedPresentationState extends _PresentationState {

  final Function(BuildContext) onFinishPressed;

  _FinishedPresentationState (QuizBuilder builder, { this.onFinishPressed }) : super(builder);

  @override
  Widget body(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxWidth: 350
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          SvgPicture.asset(
            AssetPaths.finish,
            width: 150,
            height: 150,
          ),
          Container(
            margin: EdgeInsets.symmetric(
              vertical: 20
            ),
            child: Text("Einde van de overhoring", style: TextStyle(
                fontFamily: Fonts.ubuntu,
                fontWeight: FontWeight.bold,
                fontSize: 25,

            ), textAlign: TextAlign.center),
          ),
          Text("Je hebt alle vragen beantwoord, klik op afronden om je resultaat te zien en verder te gaan", style: TextStyle(
              fontFamily: Fonts.ubuntu,
              fontWeight: FontWeight.w400,
              fontSize: 14
          ), textAlign: TextAlign.center)
        ],
      ),
    );
  }

  @override
  Widget bottomBar(BuildContext context) {
    return baseBottomBar(
        child: ThemedButton(
          "Afronden",
          buttonColor: BrandColors.secondaryButtonColor,
          onPressed: () => onFinishPressed(context),
          borderRadius: BorderRadius.circular(12),
        )
    );
  }


}

class QuizPageState extends State<QuizPage> {

  final GlobalKey<AnswerFormState> _answerFormKey = GlobalKey<AnswerFormState>();

  final GlobalKey<QuizQuestionPresentationState> _quizQuestionPresentationKey = GlobalKey<QuizQuestionPresentationState>();

  void _unMarkAsIncorrectAnswer() {
    widget.builder.quizSet.unMarkAsIncorrectAnswer();
  }

  void _onEnterPressed() {
    if (!widget.builder.options.visibilityOptions.useEnterToGoToNext) {
      return;
    }
    String answer = _answerFormKey.currentState.getAnswer();
    bool isCorrect = widget.builder.answerChecker.correct(widget.builder.quizSet.currentQuestion, answer);
    _answerQuestion(
      isCorrect: isCorrect,
      transitionDelay: isCorrect ? widget.builder.options.visibilityOptions.timeCorrectAnswerVisible : widget.builder.options.visibilityOptions.timeIncorrectAnswerVisible
    );
  }

  void _answerQuestion({ @required bool isCorrect, @required int transitionDelay }) {
    _quizQuestionPresentationKey.currentState.showFeedback(QuizQuestionUserResponse(
        correctlyAnswered: isCorrect
    ));
    widget.builder.quizSet.answerQuestion(isCorrect);
    Future.delayed(Duration(seconds: transitionDelay)).then((_) {
      _quizQuestionPresentationKey.currentState.restore();
      widget.builder.quizSet.nextQuestion();
    });
  }

  Widget _progressBar() {
    return LinearProgressIndicator(
      backgroundColor: Color.fromRGBO(220, 220, 220, 1),
      value: max(widget.builder.quizSet.answeredQuestionsCount.toDouble() / widget.builder.quizSet.totalQuestionsCount.toDouble(), 0.05),
      valueColor: AlwaysStoppedAnimation<Color>(
          BrandColors.secondaryButtonColor
      ),
    );
  }

  _PresentationState get presentation {
    if (widget.builder.quizSet.currentQuestion == null) {
      return _FinishedPresentationState(widget.builder);
    } else {
      return _ActivePresentationState(
        widget.builder,
        onEnterPressed: _onEnterPressed,
        answerFormKey: _answerFormKey,
        questionPresentationKey: _quizQuestionPresentationKey,
        answerQuestion: _answerQuestion
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModel<QuizSet>(
      model: widget.builder.quizSet,
      child: ScopedModelDescendant<QuizSet>(
        builder: (BuildContext context, Widget childWidget, QuizSet quizSet) {
          return Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              centerTitle: true,
              title: Text(
                widget.builder.quizInput.title,
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    fontFamily: Fonts.ubuntu
                ),
              ),
              elevation: 0,
            ),
            body: Container(
              child: Column(
                children: <Widget>[
                  _progressBar(),
                  _StatusBar(
                    askedQuestionsCount: widget.builder.quizSet.askedQuestionsCount,
                    upcomingQuestionsCount: widget.builder.quizSet.upcomingQuestionsCount,
                    errorCount: widget.builder.quizSet.errorCount,
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Container(
                        child: Column(
                          children: <Widget>[
                            Container(
                              padding: EdgeInsets.all(20),
                              child: Row(
                                children: <Widget>[
                                  Visibility(
                                    visible: widget.builder.quizSet.previousAnswerWasIncorrect,
                                    child: ThemedButton(
                                      FlutterI18n.translate(context, TranslationKeys.markPreviousAnswerCorrect),
                                      buttonColor: BrandColors.primaryButtonColor,
                                      icon: Icons.undo,
                                      borderRadius: BorderRadius.circular(20),
                                      onPressed: () => _unMarkAsIncorrectAnswer(),
                                    ),
                                  ),

                                ],
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.all(20),
                              child: presentation.body(context),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            bottomNavigationBar: presentation.bottomBar(context),
          );
        },
      ),
    );
  }

}