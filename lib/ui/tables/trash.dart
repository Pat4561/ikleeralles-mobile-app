import 'package:flutter/material.dart';
import 'package:ikleeralles/constants.dart';
import 'package:ikleeralles/logic/managers/operation.dart';
import 'package:ikleeralles/logic/operations/abstract.dart';
import 'package:ikleeralles/logic/operations/trash.dart';
import 'package:ikleeralles/network/models/exercise_list.dart';
import 'package:ikleeralles/ui/background_builder.dart';
import 'package:ikleeralles/ui/cells/deleted_exercise_list.dart';
import 'package:ikleeralles/ui/tables/operation_based.dart';

class TrashTable extends OperationBasedTable {

  final Function(ExerciseList) onRecoverPressed;

  TrashTable ({ @required OperationManager operationManager,  @required this.onRecoverPressed, GlobalKey<TrashTableState> key }) : super(operationManager, key: key);

  @override
  State<StatefulWidget> createState() {
    return TrashTableState();
  }


}

class TrashTableState extends OperationBasedTableState<TrashTable> {

  @override
  void initState() {
    backgroundColor = BrandColors.lightGreyBackgroundColor.withOpacity(0.6);
    super.initState();
  }

  @override
  Operation newOperation() {
    return TrashDownloadOperation();
  }

  @override
  Widget listBuilder(BuildContext context, result) {
    List<ExerciseList> exercisesLists = result;
    return ListView.builder(
      itemCount: exercisesLists.length,
      itemBuilder: (BuildContext context, int position) {
        return DeletedExerciseListCell(
          exercisesLists[position],
          onRecoverPressed: widget.onRecoverPressed
        );
      },
    );
  }

  @override
  Widget noResultsBackgroundBuilder(BuildContext context) {
    return BackgroundBuilder.defaults.noResults(context, alignment: Alignment.topCenter);
  }

  @override
  Widget errorBackgroundBuilder(BuildContext context, error) {
    return BackgroundBuilder.defaults.error(context, alignment: Alignment.topCenter);
  }

  @override
  Widget loadingBackgroundBuilder(BuildContext context) {
    return BackgroundBuilder.defaults.loadingSimple(context);
  }
}