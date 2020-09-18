import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:ikleeralles/constants.dart';
import 'package:ikleeralles/logic/managers/extensions.dart';
import 'package:ikleeralles/logic/operations/exercises.dart';
import 'package:ikleeralles/network/models/exercise_list.dart';
import 'package:ikleeralles/ui/background_builder.dart';
import 'package:ikleeralles/ui/cells/actions.dart';
import 'package:ikleeralles/ui/cells/exercise_list.dart';
import 'package:ikleeralles/ui/tables/base.dart';
import 'package:ikleeralles/ui/tables/operation_based.dart';
import 'package:ikleeralles/logic/operations/abstract.dart';
import 'package:ikleeralles/ui/themed/button.dart';

class ExercisesTable extends StatefulWidget {

  final int folderId;
  final Function onTrashPressed;
  final Function onMyFolderPressed;
  final Function onPublicListsPressed;
  final Function(ExerciseList) onExerciseListPressed;
  final EdgeInsets tablePadding;
  final SelectionManager selectionManager;

  ExercisesTable ({ this.folderId, this.onTrashPressed, this.onMyFolderPressed, this.onPublicListsPressed, @required this.selectionManager, @required this.onExerciseListPressed, this.tablePadding, Key key }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return ExercisesTableState();
  }

}

class MultiSelectionButton extends StatelessWidget {

  final bool allSelected;
  final Function(bool) onChange;

  MultiSelectionButton ({ @required this.allSelected, @required this.onChange });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 28,
      child: ThemedButton(
        FlutterI18n.translate(context, allSelected ? TranslationKeys.unSelectAll : TranslationKeys.selectAll),
        contentPadding: EdgeInsets.symmetric(
            vertical: 0,
            horizontal: 15
        ),
        fontSize: 13,
        buttonColor: BrandColors.themeColor,
        filled: allSelected,
        borderRadius: BorderRadius.circular(10),
        onPressed: () {
          onChange(!allSelected);
        },
      ),
    );
  }

}

class ExercisesTableState extends OperationBasedTableState<ExercisesTable> {

  @override
  Operation newOperation() {
    return ExercisesDownloadOperation(
      folderId: widget.folderId
    );
  }

  @override
  Widget background(BuildContext context){
    Widget background = super.background(context);
    if (operationManager.currentState.result == null) {
      return background;
    }
    return Container();
  }

  @override
  Widget noResultsBackgroundBuilder(BuildContext context) {
    return BackgroundBuilder.buildWithTitles(
      title: FlutterI18n.translate(context, TranslationKeys.noResults),
      subTitle: FlutterI18n.translate(context, TranslationKeys.noResultsSubTitle),
    );
  }

  @override
  Widget loadingBackgroundBuilder(BuildContext context) {
    return BackgroundBuilder.buildWithColumn(
      children: [
        Container(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(BrandColors.secondaryButtonColor),
            strokeWidth: 3,
          ),
        ),
        Container(
          margin: EdgeInsets.symmetric(vertical: 15),
          child: Text(
            FlutterI18n.translate(context, TranslationKeys.busyLoading),
            style: TextStyle(
              fontSize: 18,
              fontFamily: Fonts.montserrat
            ),
          ),
        ),
      ]
    );
  }

  @override
  Widget errorBackgroundBuilder(BuildContext context, error) {
    return BackgroundBuilder.buildWithTitles(
      title: FlutterI18n.translate(context, TranslationKeys.error),
      subTitle: FlutterI18n.translate(context, TranslationKeys.errorSubTitle),
    );
  }

  @override
  Widget list(BuildContext context) {
    if (operationManager.currentState.result == null) {
      return ListView();
    } else {
      return listBuilder(context, operationManager.currentState.result);
    }
  }

  Widget objectCell(int row) {
    ExerciseList exerciseList = operationManager.currentState.result[row];
    return Container(
      child: ExerciseListCell(
          exerciseList,
          isSelected: widget.selectionManager.objects.contains(exerciseList),
          onSelectionChange: (exerciseList, isSelected) {
            widget.selectionManager.toggle(exerciseList);
          },
          onPressed: widget.onExerciseListPressed(exerciseList),
      ),
      margin: EdgeInsets.symmetric(
          vertical: 5,
          horizontal: 15
      ),
    );
  }

  Widget actionCell(Widget cellWidget) {
    return Container(
      child: cellWidget,
      margin: EdgeInsets.symmetric(
          vertical: 8,
          horizontal: 15
      ),
    );
  }

  @override
  Widget listBuilder(BuildContext context, result) {
    return TableView(
      TableViewBuilder(
        sectionCount: 2,
        numberOfRows: (int section) {
          if (section == 0) {
            return 3;
          } else if (section == 1) {
            return operationManager.currentState.result.length;
          }
        },
        itemBuilder: (BuildContext context, int row, int section) {
          if (section == 0) {
            if (row == 0) {
              return Visibility(child: actionCell(
                TrashActionCell(onPressed: widget.onTrashPressed)
              ), visible: widget.onTrashPressed != null);
            } else if (row == 1) {
              return Visibility(child: actionCell(
                MyFoldersActionCell(onPressed: widget.onMyFolderPressed)
              ), visible: widget.onMyFolderPressed != null);
            } else if (row == 2) {
              return Visibility(
                child: actionCell(
                    PublicListsActionCell(onPressed: widget.onPublicListsPressed)
                ),
                visible: widget.onPublicListsPressed != null,
              );
            }
          } else if (section == 1) {
            return objectCell(row);
          }

          throw Exception("Not implemented correctly (row, section combi)");
        },
        sectionHeaderBuilder: (int section) {
          if (section == 1) {
            return Container(
              margin: EdgeInsets.only(
                left: 15,
                right: 15,
                top: 25,
                bottom: 10
              ),
              child: Row(
                children: <Widget>[
                  MultiSelectionButton(
                    allSelected: () {
                      if (operationManager.currentState.result != null) {
                        var length = operationManager.currentState.result.length;
                        return length == widget.selectionManager.objects.length && length > 0;
                      }
                      return false;
                    }(),
                    onChange: (allSelected) {
                      if (allSelected) {
                        widget.selectionManager.selectAll(operationManager.currentState.result);
                      } else {
                        widget.selectionManager.unSelectAll();
                      }
                    },
                  )
                ],
              ),
            );
          }
          return Container();
        }
      ),
      padding: widget.tablePadding ?? EdgeInsets.only(top: 25),
    );
  }

}