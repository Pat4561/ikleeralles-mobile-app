import 'package:flutter/material.dart';
import 'package:ikleeralles/constants.dart';
import 'package:ikleeralles/dates.dart';
import 'package:ikleeralles/logic/managers/platform.dart';
import 'package:ikleeralles/network/models/exercise_list.dart';

class SearchExerciseListCell extends StatelessWidget {

  final ExerciseList exerciseList;
  final PlatformDataProvider platformDataProvider;
  final Function(ExerciseList) onPressed;

  SearchExerciseListCell (this.exerciseList, { this.onPressed, @required this.platformDataProvider });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(
          8
        )
      ),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(
            8
          )
        ),
        child: Material(
          child: InkWell(
            onTap: () {
              onPressed(this.exerciseList);
            },
            child: Container(
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.only(
                        left: 14,
                        top: 17,
                        bottom: 17
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.only(
                              bottom: 5
                            ),
                            child: Text(
                              exerciseList.name,
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontFamily: Fonts.ubuntu,
                                fontSize: 16
                              ),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(
                              bottom: 20
                            ),
                            child: Text(
                              "${platformDataProvider.languageData.get(exerciseList.original)} - ${platformDataProvider.languageData.get(exerciseList.translated)}",
                              style: TextStyle(
                                  color: BrandColors.textColorLighter,
                                  fontSize: 13,
                                  fontFamily: Fonts.ubuntu
                              ),
                            ),
                          ),
                          Container(
                            child: Text(
                              Dates.format(
                                exerciseList.date
                              ),
                              style: TextStyle(
                                color: BrandColors.textColorLighter,
                                fontSize: 13,
                                fontFamily: Fonts.ubuntu
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(
                      left: 10,
                      right: 15
                    ),
                    child: Icon(Icons.chevron_right, color: Colors.grey),
                  )
                ],
              )
            ),
          ),
          color: Colors.transparent,
        ),
      ),
    );
  }


}