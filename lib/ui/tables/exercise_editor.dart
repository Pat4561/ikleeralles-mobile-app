import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ikleeralles/constants.dart';
import 'package:ikleeralles/ui/cells/exercise_set.dart';
import 'package:ikleeralles/ui/exercise_controller.dart';
import 'package:ikleeralles/ui/tables/base.dart';
import 'package:ikleeralles/ui/themed/button.dart';

class ExerciseEditorList extends StatelessWidget {

  final ExerciseSetsController controller;
  final String term;
  final String definition;

  ExerciseEditorList ({ @required this.controller, @required this.term, @required this.definition });

  @override
  Widget build(BuildContext context) {
    return TableView(
        TableViewBuilder(
            sectionHeaderBuilder: (int section) {
              return Container(
                height: 10,
              );
            },
            numberOfRows: (int section) {
              return controller.sets.length;
            },
            itemBuilder: (BuildContext context, int row, int section) {
              return ExerciseSetCell(
                controller.sets[row],
                rowNumber: row + 1,
                definition: definition,
                term: term,
              );
            },
            sectionFooterBuilder: (int section) {
              return Container(
                margin: EdgeInsets.only(bottom: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    ThemedButton(
                        "Nieuwe velden",
                        buttonColor: Colors.white,
                        labelColor: BrandColors.textColorLighter,
                        fontSize: 15,
                        icon: Icons.add_circle_outline,
                        iconSize: 24,
                        contentPadding: EdgeInsets.all(12),
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        borderSide: BorderSide(
                            color: BrandColors.borderColor
                        ),
                        onPressed: () => controller.addMore()
                    )
                  ],
                ),
              );
            }
        )
    );
  }

}