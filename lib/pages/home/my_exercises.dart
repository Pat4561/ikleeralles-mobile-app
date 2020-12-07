import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:ikleeralles/constants.dart';
import 'package:ikleeralles/logic/managers/extensions.dart';
import 'package:ikleeralles/logic/managers/operation.dart';
import 'package:ikleeralles/logic/managers/platform.dart';
import 'package:ikleeralles/logic/operations/exercises.dart';
import 'package:ikleeralles/logic/operations/folders.dart';
import 'package:ikleeralles/logic/operations/trash.dart';
import 'package:ikleeralles/pages/exercises_overview.dart';
import 'package:ikleeralles/ui/navigation_drawer.dart';
import 'package:ikleeralles/ui/tables/exercises_overview.dart';
import 'package:scoped_model/scoped_model.dart';

class MyExercisesSubPage extends NavigationDrawerContentChild {



  ExercisesOverviewController _overviewController;

  ExercisesOverviewBuilder _overviewBuilder;

  MyExercisesSubPage (NavigationDrawerController controller, String key, { @required PlatformDataProvider platformDataProvider }) : super(controller, key: key) {
    _overviewController = ExercisesOverviewController(
        foldersOperationManager: OperationManager(
            operationBuilder: () {
              return FoldersDownloadOperation();
            }
        ),
        exercisesOperationManager: OperationManager(
            operationBuilder: () {
              return ExercisesDownloadOperation();
            }
        ),
        trashOperationManager: OperationManager(
            operationBuilder: () {
              return TrashDownloadOperation();
            }
        ),
        platformDataProvider: platformDataProvider
    );

    _overviewBuilder = ExercisesOverviewBuilder(
        _overviewController
    );
  }

  @override
  Widget body(BuildContext context) {
    return ScopedModel<SelectionManager>(
      model: _overviewController.selectionManager,
      child: ScopedModelDescendant<SelectionManager>(
          builder: (BuildContext context, Widget widget, SelectionManager manager) {
            return ExercisesTable(
              key: _overviewController.exercisesTableKey,
              selectionManager: _overviewController.selectionManager,
              operationManager: _overviewController.exercisesOperationManager,
              onExerciseListPressed: (exerciseList) => _overviewController.onExerciseListPressed(context, exerciseList),
              onMyFolderPressed: () => _overviewController.onMyFoldersPressed(context),
              onTrashPressed: () => _overviewController.onTrashPressed(context),
              platformDataProvider: _overviewController.platformDataProvider,
              tablePadding: EdgeInsets.only(
                  top: 25,
                  bottom: 25
              ),
            );
          }
      ),
    );

  }

  @override
  Widget bottomNavigationBar(BuildContext context) {
    return ScopedModel<SelectionManager>(
      model: _overviewController.selectionManager,
      child: ScopedModelDescendant<SelectionManager>(
          builder: (BuildContext context, Widget widget, SelectionManager manager) {
            return _overviewBuilder.bottomNavigationBar(context);
          }
      ),
    );
  }

  @override
  Widget floatingActionButton(BuildContext context) {
    return ScopedModel<SelectionManager>(
      model: _overviewController.selectionManager,
      child: ScopedModelDescendant<SelectionManager>(
          builder: (BuildContext context, Widget widget, SelectionManager manager) {
            return _overviewBuilder.floatingActionButton(context);
          }
      ),
    );
  }

  @override
  String title(BuildContext context) {
    return FlutterI18n.translate(context, TranslationKeys.myLists);
  }


}
