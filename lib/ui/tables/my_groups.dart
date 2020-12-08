import 'package:flutter/material.dart';
import 'package:ikleeralles/constants.dart';
import 'package:ikleeralles/logic/managers/operation.dart';
import 'package:ikleeralles/ui/tables/operation_based.dart';
import 'package:ikleeralles/ui/background_builder.dart';
import 'package:ikleeralles/ui/cells/group.dart';
import 'package:ikleeralles/network/models/group.dart';


class MyGroupsTable extends OperationBasedTable {

  final Function(Group) onGroupPressed;

  MyGroupsTable(OperationManager operationManager, { @required this.onGroupPressed }) : super(operationManager);

  @override
  State<StatefulWidget> createState() {
    return MyGroupsTableState();
  }

}


class MyGroupsTableState extends OperationBasedTableState<MyGroupsTable> {

  @override
  void initState() {
    backgroundColor = BrandColors.lightGreyBackgroundColor.withOpacity(0.6);
    super.initState();
  }


  @override
  Widget listBuilder(BuildContext context, result) {
    List<Group> groups = result;
    return ListView.builder(
      itemCount: groups.length,
      itemBuilder: (BuildContext context, int position) {
        return GroupCell(
          groups[position],
          onPressed: widget.onGroupPressed,
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