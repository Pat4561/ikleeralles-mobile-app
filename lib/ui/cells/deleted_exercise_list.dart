import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:ikleeralles/constants.dart';
import 'package:ikleeralles/dates.dart';
import 'package:ikleeralles/network/models/exercise_list.dart';
import 'package:ikleeralles/ui/themed/button.dart';

class DeletedExerciseListCell extends StatelessWidget {

  final Function(ExerciseList) onRecoverPressed;
  final ExerciseList exerciseList;

  DeletedExerciseListCell (this.exerciseList, { this.onRecoverPressed });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: 10,
        horizontal: 20
      ),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Container(
              margin: EdgeInsets.symmetric(
                vertical: 10
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Text(this.exerciseList.name, style: TextStyle(
                      fontFamily: Fonts.ubuntu,
                      fontWeight: FontWeight.w600,
                      fontSize: 15
                  )),
                  SizedBox(height: 10),
                  Container(
                    child: Text(
                        Dates.format(this.exerciseList.date),
                        style: TextStyle(
                            fontFamily: Fonts.ubuntu,
                            fontSize: 13
                        )
                    ),
                  )
                ],
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(
              horizontal: 10
            ),
            child: ThemedButton(
              FlutterI18n.translate(context, TranslationKeys.recover),
              buttonColor: BrandColors.secondaryButtonColor,
              fontSize: 13,
              contentPadding: EdgeInsets.symmetric(
                horizontal: 10
              ),
              borderRadius: BorderRadius.circular(15),
              onPressed: () {
                onRecoverPressed(this.exerciseList);
              },
            ),
          )
        ],
      ),
      decoration: BoxDecoration(
        color: BrandColors.lightGreyBackgroundColor,
        border: Border(
          bottom: BorderSide(
            width: 1,
            color: Colors.white
          )
        )
      ),
    );
  }

}