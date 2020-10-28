import 'dart:math';
import 'package:flutter/material.dart';
import 'package:ikleeralles/constants.dart';
import 'package:ikleeralles/ui/custom/quiz/answer_form/abstract.dart';
import 'package:ikleeralles/ui/custom/quiz/builder.dart';
import 'package:ikleeralles/ui/custom/quiz/question_presentation.dart';
import 'package:ikleeralles/ui/themed/button.dart';

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
  final int answeredQuestionsCount;

  _StatusBar ({ @required this.upcomingQuestionsCount, @required this.errorCount, @required this.answeredQuestionsCount });

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
            text: "Te gaan"
          ),
          _box(
            value: errorCount.toString(),
            text: "Fouten"
          ),
          _box(
            value: answeredQuestionsCount.toString(),
            text: "Gevraagd"
          )
        ],
      ),
    );
  }

}

class QuizPageState extends State<QuizPage> {

  final GlobalKey<AnswerFormState> _answerFormKey = GlobalKey<AnswerFormState>();

  void _unMarkAsIncorrectAnswer() {

  }

  void _onEnterPressed() {

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
              answeredQuestionsCount: widget.builder.quizSet.answeredQuestionsCount,
              upcomingQuestionsCount: widget.builder.quizSet.upcomingQuestionsCount,
              errorCount: widget.builder.quizSet.errorCount,
            ),
            Container(
              padding: EdgeInsets.all(20),
              child: Row(
                children: <Widget>[
                  ThemedButton(
                    "Vorig antwoord goedrekenen",
                    buttonColor: BrandColors.primaryButtonColor,
                    icon: Icons.undo,
                    borderRadius: BorderRadius.circular(20),
                    onPressed: () => _unMarkAsIncorrectAnswer(),
                  )
                ],
              ),
            ),
            Expanded(
              child: Container(
                margin: EdgeInsets.all(20),
                child: QuizQuestionPresentation(
                  widget.builder.quizSet.currentQuestion,
                  hint: widget.builder.hintGenerator.generate(widget.builder.quizSet.currentQuestion),
                  formBuilder: (BuildContext context) {
                    return widget.builder.formBuilder(key: _answerFormKey, onEnterPressed:  _onEnterPressed);
                  }
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
            onIncorrectAnswer: (question) {

            },
            onCorrectAnswer: (question) {

            },
            answerGetter: () {
              return _answerFormKey.currentState.getAnswer();
            }
          ),
        ),
      ),
    );
  }

}