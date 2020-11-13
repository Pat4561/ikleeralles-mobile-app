import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:ikleeralles/constants.dart';
import 'package:ikleeralles/logic/quiz/result.dart';
import 'package:ikleeralles/network/models/exercise_list.dart';
import 'package:ikleeralles/ui/custom/quiz/grade_color.dart';
import 'package:ikleeralles/ui/hyperlink.dart';

class SubExerciseResultCell extends StatelessWidget {

  final ExerciseList exerciseList;
  final int totalCount;
  final int errorCount;
  final double grade;
  final Function(BuildContext) showDetails;

  SubExerciseResultCell(this.exerciseList, { @required this.totalCount, @required this.errorCount, @required this.grade, @required this.showDetails });

  @override
  Widget build(BuildContext context) {
    return Material(
      child: InkWell(
        onTap: () => showDetails(context),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          child: Row(
            children: <Widget>[
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(this.exerciseList.name, style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, fontFamily: Fonts.ubuntu)),
                    SizedBox(height: 5),
                    Wrap(
                      children: <Widget>[
                        Text(FlutterI18n.translate(context, TranslationKeys.questions, { "count": totalCount.toString() }),
                            style: TextStyle(
                                fontSize: 13,
                                fontFamily: Fonts.ubuntu
                            )
                        )
                      ],
                    )
                  ],
                ),
              ),
              Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    Text(this.grade.toString(), style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, fontFamily: Fonts.ubuntu, color: GradeColor(this.grade).value)),
                    SizedBox(height: 5),
                    Hyperlink(
                      baseColor: Colors.red,
                      highlightedColor: BrandColors.secondaryButtonColor,
                      builder: (bool highlighted, Color color) {
                        return Text(FlutterI18n.translate(context, TranslationKeys.showErrors, { "count": errorCount.toString() }),
                            style: TextStyle(
                                fontSize: 13,
                                fontFamily: Fonts.ubuntu,
                                fontWeight: FontWeight.bold,
                                color: color
                            )
                        );
                      },
                      onPressed: () => showDetails(context),
                    )
                  ],
                ),
              )

            ],
          ),
        ),
      ),
      color: Colors.transparent,
    );
  }

}



class CombinedResultDetailsList extends StatelessWidget {

  final QuizResult result;
  final Function(BuildContext, ExerciseList) showDetails;

  CombinedResultDetailsList(this.result, { @required this.showDetails });

  @override
  Widget build(BuildContext context) {
    List<ExerciseList> exerciseLists = result.resultMap.value.keys.toList();
    return ListView.builder(
      shrinkWrap: true,
      itemBuilder: (BuildContext context, int position) {
        ExerciseList exerciseList = exerciseLists[position];
        return SubExerciseResultCell(
          exerciseList,
          totalCount: result.resultMap.value[exerciseList].totalAnswersCount,
          errorCount: result.resultMap.value[exerciseList].incorrectAnswersCount,
          grade: result.resultMap.value[exerciseList].generateGrade().value,
          showDetails: (BuildContext context) => showDetails(context, exerciseList),
        );
      },
      itemCount: exerciseLists.length,
    );
  }

}