import 'package:flutter/material.dart';
import 'package:ikleeralles/constants.dart';
import 'package:ikleeralles/logic/managers/operation.dart';
import 'package:ikleeralles/network/models/folder.dart';
import 'package:ikleeralles/ui/background_builder.dart';
import 'package:ikleeralles/ui/cells/folder.dart';
import 'package:ikleeralles/ui/tables/operation_based.dart';

class FoldersTable extends OperationBasedTable {

  final Function(Folder) onDeleteFolderPressed;
  final Function(Folder) onFolderPressed;

  FoldersTable ({ @required OperationManager operationManager,  @required this.onDeleteFolderPressed, @required this.onFolderPressed, GlobalKey<FoldersTableState> key }) : super(operationManager, key: key);

  @override
  State<StatefulWidget> createState() {
    return FoldersTableState();
  }


}

class FoldersTableState extends OperationBasedTableState<FoldersTable> {

  @override
  void initState() {
    backgroundColor = BrandColors.lightGreyBackgroundColor.withOpacity(0.6);
    super.initState();
  }


  @override
  Widget listBuilder(BuildContext context, result) {
    List<Folder> folders = result;
    return ListView.builder(
      itemCount: folders.length,
      itemBuilder: (BuildContext context, int position) {
        return FolderCell(
          folders[position],
          onPressed: this.widget.onFolderPressed,
          onDeletePressed: this.widget.onDeleteFolderPressed,
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