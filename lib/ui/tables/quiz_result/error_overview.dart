import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:ikleeralles/constants.dart';
import 'package:ikleeralles/logic/quiz/input.dart';
import 'package:ikleeralles/logic/quiz/result.dart';

class ErrorOverviewList extends StatelessWidget {

  final List<QuizQuestion> items;
  final QuizResult result;

  ErrorOverviewList ({ @required this.items, @required this.result });

  @override
  Widget build(BuildContext context) {

    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Container(
            padding: EdgeInsets.symmetric(
                vertical: 12,
                horizontal: 20
            ),
            child: Text(FlutterI18n.translate(context, TranslationKeys.errorsMade), style: TextStyle(fontFamily: Fonts.ubuntu, fontWeight: FontWeight.bold, fontSize: 15)),
          ),
          Container(
            constraints: BoxConstraints(
                maxWidth: 400
            ), //Could be calculated field
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: items.length,
              itemBuilder: (BuildContext context, int position) {
                QuizQuestion question = items[position];
                int count = result.resultMap.value[question.exerciseList].find(question).incorrectAnswersCount;
                return Container(
                  margin: EdgeInsets.symmetric(vertical: 8, horizontal: 20),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            Text(question.title, style: TextStyle(fontFamily: Fonts.ubuntu, fontWeight: FontWeight.bold, color: BrandColors.textColorLighter)),
                            Text(question.answers.join(", "), style: TextStyle(fontFamily: Fonts.ubuntu))
                          ],
                        ),
                      ),
                      Text("${count}x", style: TextStyle(fontFamily: Fonts.ubuntu, fontWeight: FontWeight.bold, color: BrandColors.textColorLighter))
                    ],
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }

}