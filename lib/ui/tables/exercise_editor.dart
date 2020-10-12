import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ikleeralles/constants.dart';
import 'package:ikleeralles/network/models/exercise_list.dart';
import 'package:ikleeralles/ui/cells/exercise_set.dart';
import 'package:ikleeralles/ui/exercise_controller.dart';
import 'package:ikleeralles/ui/tables/base.dart';
import 'package:ikleeralles/ui/themed/button.dart';
import 'package:keyboard_actions/keyboard_actions.dart';

class ExerciseEditorList extends StatelessWidget {

  final ExerciseSetsController controller;
  final String term;
  final String definition;

  final FocusNode focusNode = FocusNode();

  ExerciseEditorList ({ @required this.controller, @required this.term, @required this.definition });

  KeyboardActionsConfig _keyboardActionsConfig(BuildContext context) {
    return KeyboardActionsConfig(
        keyboardActionsPlatform: KeyboardActionsPlatform.ALL,
        keyboardBarColor: Colors.grey[200],
        nextFocus: true,
        actions: [
          KeyboardActionsItem(
              focusNode: focusNode,
              toolbarButtons: [
                    (node) {
                  return GestureDetector(
                    onTap: () => node.unfocus(),
                    child: Container(
                      color: Colors.white,
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        "CLOSE",
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                  );
                }
              ]
          ),
        ]
    );
  }

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
                onDeletePressed: (BuildContext context) {
                  FocusScope.of(context).unfocus();
                  controller.remove(controller.sets[row]);
                },
                onAddNewEntryPressed: (BuildContext context, { ExerciseSetInputSide side }) {
                  FocusScope.of(context).unfocus();
                  controller.addFieldEntry(controller.sets[row], side: side);
                },
                onFieldChange: (BuildContext context, String newText, { int index, ExerciseSetInputSide side }) {
                  controller.changeField(controller.sets[row], newText, fieldIndex: index, side: side);
                },
                onDeleteField: (BuildContext context, { int index, ExerciseSetInputSide side }) {
                  controller.removeField(controller.sets[row], fieldIndex: index, side: side);
                },
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