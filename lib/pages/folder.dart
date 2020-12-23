import 'package:flutter/material.dart';
import 'package:ikleeralles/logic/managers/extensions.dart';
import 'package:ikleeralles/logic/managers/operation.dart';
import 'package:ikleeralles/logic/operations/exercises.dart';
import 'package:ikleeralles/logic/operations/folders.dart';
import 'package:ikleeralles/network/models/exercise_list.dart';
import 'package:ikleeralles/network/models/folder.dart';
import 'package:ikleeralles/logic/managers/platform.dart';
import 'package:ikleeralles/pages/exercises_overview.dart';
import 'package:ikleeralles/ui/logout_handler.dart';
import 'package:ikleeralles/ui/tables/exercises_overview.dart';
import 'package:ikleeralles/ui/themed/appbar.dart';
import 'package:scoped_model/scoped_model.dart';

class FolderPage extends StatefulWidget {

  final Folder folder;
  final PlatformDataProvider platformDataProvider;

  FolderPage (this.folder, { @required this.platformDataProvider });

  @override
  State<StatefulWidget> createState() {
    return _FolderPageState();
  }

}

class _FolderPageState extends State<FolderPage> {


  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  LogoutHandler _logoutHandler;

  ExercisesOverviewController _overviewController;

  ExercisesOverviewBuilder _overviewBuilder;

  @override
  void dispose() {
    super.dispose();
    _logoutHandler.unListen();
  }

  @override
  void initState() {
    super.initState();
    _logoutHandler = LogoutHandler(
      context
    );
    _logoutHandler.listen();
    _overviewController = ExercisesOverviewController(
        foldersOperationManager: OperationManager(
            operationBuilder: () {
              return FoldersDownloadOperation();
            }
        ),
        exercisesOperationManager: OperationManager(
            operationBuilder: () {
              return ExercisesDownloadOperation(folderId: widget.folder.id);
            },
            onReset: () {
              if (_overviewController != null) {
                _overviewController.resetSelection();
              }
            }
        ),
        platformDataProvider: widget.platformDataProvider
    );
    _overviewBuilder = ExercisesOverviewBuilder(_overviewController);

  }

  @override
  Widget build(BuildContext context) {
    return ScopedModel(
      model: _overviewController.selectionManager,
      child: ScopedModelDescendant<SelectionManager<ExerciseList>>(
        builder: (BuildContext context, Widget widget, SelectionManager manager) {
          return Scaffold(
              key: _scaffoldKey,
              appBar: ThemedAppBar(
                title: this.widget.folder.name,
              ),
              body: ExercisesTable(
                operationManager: _overviewController.exercisesOperationManager,
                key: _overviewController.exercisesTableKey,
                selectionManager: _overviewController.selectionManager,
                onExerciseListPressed: (exerciseList) => _overviewController.onExerciseListPressed(context, exerciseList),
                platformDataProvider: this.widget.platformDataProvider,
                tablePadding: EdgeInsets.all(0),
                showBackground: true,
              ),
              floatingActionButton: _overviewBuilder.floatingActionButton(context),
              bottomNavigationBar: _overviewBuilder.bottomNavigationBar(context)
          );;
        },
      ),
    );
  }


}
