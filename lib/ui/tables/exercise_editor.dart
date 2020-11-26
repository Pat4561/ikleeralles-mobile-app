
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:ikleeralles/constants.dart';
import 'package:ikleeralles/network/models/exercise_list.dart';
import 'package:ikleeralles/ui/cells/exercise_set.dart';
import 'package:ikleeralles/ui/custom/exercise_controller.dart';
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
              if (controller.readOnly) {
                return Container(height: 12);
              } else {
                return Container(
                  margin: EdgeInsets.only(
                      top: 12,
                      left: 20
                  ),
                  child: Row(
                    children: <Widget>[
                      Switch(
                        activeColor: BrandColors.secondaryButtonColor,
                        onChanged: (newValue) => controller.autoTranslationEnabled = newValue,
                        value: controller.autoTranslationEnabled,
                      ),
                      Text(
                        FlutterI18n.translate(context, TranslationKeys.translateAutomatically),
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            fontFamily: Fonts.ubuntu
                        ),
                      )
                    ],
                  ),
                );
              }
            },
            numberOfRows: (int section) {
              return controller.sets.length;
            },
            itemBuilder: (BuildContext context, int row, int section) {
              return ExerciseSetCell(
                controller.sets[row],
                rowNumber: row + 1,
                readOnly: controller.readOnly,
                definition: definition,
                platformDataProvider: controller.platformDataProvider,
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
                onFieldEditingEnded: (BuildContext context, { int index, ExerciseSetInputSide side }) {
                  FocusScope.of(context).unfocus();
                  if (side == ExerciseSetInputSide.term && index == 0) {
                    controller.autoTranslate(controller.sets[row]);
                  }
                },
              );
            },
            sectionFooterBuilder: (int section) {
              return Container(
                margin: EdgeInsets.only(bottom: 20),
                padding: EdgeInsets.symmetric(
                  horizontal: 20
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Visibility(child: ThemedButton(
                        FlutterI18n.translate(context, TranslationKeys.addSets),
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
                    ), visible: !controller.readOnly),
                  ],
                ),
              );
            }
        )
    );
  }

}