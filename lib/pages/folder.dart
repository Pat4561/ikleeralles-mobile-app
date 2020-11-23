import 'package:flutter/material.dart';
import 'package:ikleeralles/logic/managers/platform.dart';
import 'package:ikleeralles/logic/managers/operation.dart';
import 'package:ikleeralles/logic/operations/abstract.dart';
import 'package:ikleeralles/logic/operations/exercises.dart';
import 'package:ikleeralles/network/models/folder.dart';
import 'package:ikleeralles/pages/exercises_overview.dart';
import 'package:ikleeralles/ui/tables/exercises_overview.dart';
import 'package:ikleeralles/ui/themed/appbar.dart';

class FolderPage extends StatefulWidget {

  final Folder folder;
  final PlatformDataProvider platformDataProvider;

  FolderPage (this.folder, { @required this.platformDataProvider });

  @override
  State<StatefulWidget> createState() {
    return _FolderPageState();
  }

}

class _FolderPageState extends ExercisesOverviewPageState<FolderPage> {

  @override
  Widget appBar(BuildContext context) {
    return ThemedAppBar(
      title: widget.folder.name,
    );
  }

  @override
  PlatformDataProvider getPlatformDataProvider() => widget.platformDataProvider;

  @override
  Widget body(BuildContext context) {
    return ExercisesTable(
      operationManager: exercisesOperationManager,
      key: exercisesTableKey,
      selectionManager: selectionManager,
      onExerciseListPressed: onExerciseListPressed,
      tablePadding: EdgeInsets.all(0),
      platformDataProvider: widget.platformDataProvider,
      showBackground: true,
    );
  }

  @override
  OperationManager<Operation> createExercisesOperationManager() {
    return OperationManager(
        operationBuilder: () {
          return ExercisesDownloadOperation(folderId: widget.folder.id);
        },
        onReset: () {
          selectionManager.unSelectAll();
        }
    );
  }

}