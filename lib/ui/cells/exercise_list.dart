import 'package:flutter/material.dart';
import 'package:ikleeralles/constants.dart';
import 'package:ikleeralles/dates.dart';
import 'package:ikleeralles/logic/managers/platform.dart';
import 'package:ikleeralles/network/models/exercise_list.dart';
import 'package:ikleeralles/ui/cells/inner.dart';
import 'package:ikleeralles/ui/themed/checkbox.dart';

class ExerciseListCell extends StatelessWidget {

  final ExerciseList exerciseList;
  final PlatformDataProvider platformDataProvider;
  final Function(ExerciseList) onPressed;
  final Function(ExerciseList exerciseList, bool isSelected) onSelectionChange;
  final bool isSelected;

  ExerciseListCell (this.exerciseList, { @required this.onPressed, @required this.onSelectionChange, @required this.platformDataProvider, @required this.isSelected });

  @override
  Widget build(BuildContext context) {
    return Material(child: InkWell(
      borderRadius: BorderRadius.all(Radius.circular(6)),
      child: Container(
        child: InnerCell(
          leading: ThemedCheckBox(
              size: 25,
              isSelected: isSelected,
              onChange: (newValue) {
                this.onSelectionChange(this.exerciseList, newValue);
              }
          ),
          title: exerciseList.name,
          subTitle: "${platformDataProvider.languageData.get(exerciseList.original)} - ${platformDataProvider.languageData.get(exerciseList.translated)}",
          trailing: Text(
            Dates.format(exerciseList.date),
            style: TextStyle(
                fontSize: 11,
                fontFamily: Fonts.ubuntu,
                color: BrandColors.textColorLighter
            ),
          ),
        ),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(6)),
            border: Border.all(
                color: BrandColors.borderColor,
                width: 1
            )
        ),
      ),
      onTap: () => onPressed(exerciseList),
    ), color: Colors.white);
  }

}