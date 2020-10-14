import 'package:flutter/material.dart';
import 'package:ikleeralles/constants.dart';
import 'package:ikleeralles/network/models/exercise_list.dart';
import 'package:ikleeralles/ui/background_builder.dart';
import 'package:ikleeralles/ui/tables/operation_based.dart';
import 'package:ikleeralles/ui/cells/search_exercise_list.dart';
import 'package:ikleeralles/logic/managers/operation.dart';

class SearchTable extends OperationBasedTable {

  final Function(ExerciseList) onExerciseListPressed;

  SearchTable ({ @required OperationManager operationManager, GlobalKey<SearchTableState> key, this.onExerciseListPressed  }) : super(operationManager, key: key);

  @override
  State<StatefulWidget> createState() {
    return SearchTableState();
  }

}

class SearchTableState extends OperationBasedTableState<SearchTable> {

  @override
  void initState() {
    backgroundColor = BrandColors.lightGreyBackgroundColor;
    super.initState();
  }

  @override
  Widget listBuilder(BuildContext context, result) {
    return ListView.builder(
      itemCount: result.length,
      padding: EdgeInsets.only(
        top: 8
      ),
      itemBuilder: (BuildContext context, int position) {
        return Container(
          margin: EdgeInsets.symmetric(
            vertical: 3,
            horizontal: 6
          ),
          child: SearchExerciseListCell(
            result[position],
            onPressed: (exerciseList) => widget.onExerciseListPressed(result[position]),
          ),
        );
      },
    );
  }

  @override
  Widget noResultsBackgroundBuilder(BuildContext context) {
    return BackgroundBuilder.defaults.noResults(context);
  }

  @override
  Widget loadingBackgroundBuilder(BuildContext context) {
    return BackgroundBuilder.defaults.loadingDetailed(context);
  }

  @override
  Widget errorBackgroundBuilder(BuildContext context, error) {
    return BackgroundBuilder.defaults.error(context);
  }


}