import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:ikleeralles/constants.dart';
import 'package:ikleeralles/logic/quiz/set.dart';
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
                              child: QuizQuestionPresentation(
                                  widget.builder.quizSet.currentQuestion,
                                  key: _quizQuestionPresentationKey,
                                  hint: widget.builder.hintGenerator.generate(widget.builder.quizSet.currentQuestion),
                                  formBuilder: (BuildContext context) {
                                    return widget.builder.formBuilder(key: _answerFormKey, onEnterPressed:  _onEnterPressed);
                                  }
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            bottomNavigationBar: BottomAppBar(
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
                child: widget.builder.actionsBuilder(
                    onIncorrectAnswer: (question) => _answerQuestion(isCorrect: false, transitionDelay: widget.builder.options.visibilityOptions.timeIncorrectAnswerVisible),
                    onCorrectAnswer: (question) => _answerQuestion(isCorrect: true, transitionDelay: widget.builder.options.visibilityOptions.timeCorrectAnswerVisible),
                    answerGetter: () {
                      return _answerFormKey.currentState.getAnswer();
                    }
                ),
              ),
            ),
          );
        },
      ),
    );
  }

}