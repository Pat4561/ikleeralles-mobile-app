import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:ikleeralles/constants.dart';
import 'package:ikleeralles/logic/managers/operation.dart';
import 'package:ikleeralles/logic/operations/abstract.dart';
import 'package:ikleeralles/logic/operations/exercises.dart';
import 'package:ikleeralles/logic/operations/folders.dart';
import 'package:ikleeralles/logic/operations/trash.dart';
import 'package:ikleeralles/network/models/exercise_list.dart';
import 'package:ikleeralles/network/models/folder.dart';
import 'package:ikleeralles/pages/exercises_overview.dart';
import 'package:ikleeralles/pages/folder.dart';
import 'package:ikleeralles/pages/search.dart';
import 'package:ikleeralles/ui/bottomsheets/folders.dart';
import 'package:ikleeralles/ui/bottomsheets/trash.dart';
import 'package:ikleeralles/ui/tables/exercise_list.dart';
import 'package:ikleeralles/ui/tables/folders.dart';
import 'package:ikleeralles/ui/tables/trash.dart';
import 'package:ikleeralles/ui/themed/appbar.dart';

class HomePage extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    return _HomePageState();
  }

}



class _HomePageState extends ExercisesOverviewPageState<HomePage> {

  final GlobalKey<FoldersTableState> foldersTableKey = GlobalKey<FoldersTableState>();

  final GlobalKey<TrashTableState> trashTableKey = GlobalKey<TrashTableState>();

  OperationManager _foldersOperationManager;
  OperationManager _trashOperationManager;

  @override
  void initState() {
    _foldersOperationManager = OperationManager(
      operationBuilder: () {
        return FoldersDownloadOperation();
      }
    );
    _trashOperationManager = OperationManager(
      operationBuilder: () {
        return TrashDownloadOperation();
      }
    );
    super.initState();
  }

  void _onRecoverPressed(ExerciseList exerciseList) {

  }

  void _onFolderPressed(Folder folder) {
    Navigator.push(context, MaterialPageRoute(
      builder: (BuildContext context) {
        return FolderPage(folder);
      }
    ));
  }

  void _onDeleteFolderPressed(Folder folder) {

  }

  void _createFolderPressed() {

  }

  void _onMyFoldersPressed() {
    FoldersBottomSheetPresenter(
      key: foldersTableKey,
      operationManager: _foldersOperationManager,
      onFolderPressed: _onFolderPressed,
      onDeleteFolderPressed: _onDeleteFolderPressed,
      createFolderPressed: _createFolderPressed
    ).show(context);
  }

  void _onTrashPressed() {
    TrashBottomSheetPresenter(
      key: trashTableKey,
      operationManager: _trashOperationManager,
      onRecoverPressed: _onRecoverPressed
    ).show(context);
  }

  void _onPublicListsPressed() {
    Navigator.push(context, MaterialPageRoute(
      builder: (BuildContext context) {
        return SearchPage();
      }
    ));
  }



  @override
  Widget appBar(BuildContext context) {
    return ThemedAppBar(
      title: FlutterI18n.translate(context, TranslationKeys.myLists),
      disablePopping: true,
      showUserInfo: true,
    );
  }

  @override
  Widget body(BuildContext context) {
    return ExercisesTable(
      key: exercisesTableKey,
      selectionManager: selectionManager,
      operationManager: exercisesOperationManager,
      onExerciseListPressed: onExerciseListPressed,
      onMyFolderPressed: _onMyFoldersPressed,
      onPublicListsPressed: _onPublicListsPressed,
      onTrashPressed: _onTrashPressed,
    );
  }

  @override
  OperationManager<Operation> createExercisesOperationManager() {
    return OperationManager(
      operationBuilder: () {
        return ExercisesDownloadOperation();
      }
    );
  }



}

