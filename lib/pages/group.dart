import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ikleeralles/constants.dart';
import 'package:ikleeralles/logic/managers/extensions.dart';
import 'package:ikleeralles/logic/managers/operation.dart';
import 'package:ikleeralles/logic/operations/exercises.dart';
import 'package:ikleeralles/network/models/exercise_list.dart';
import 'package:ikleeralles/logic/managers/platform.dart';
import 'package:ikleeralles/network/models/group.dart';
import 'package:ikleeralles/pages/exercises_overview.dart';
import 'package:ikleeralles/ui/logout_handler.dart';
import 'package:ikleeralles/ui/tables/exercises_overview.dart';
import 'package:ikleeralles/ui/themed/appbar.dart';
import 'package:scoped_model/scoped_model.dart';

class GroupPage extends StatefulWidget {

  final Group group;
  final PlatformDataProvider platformDataProvider;

  GroupPage (this.group, { @required this.platformDataProvider });

  @override
  State<StatefulWidget> createState() {
    return GroupPageState();
  }

}

class GroupExercisesOverviewBuilder extends ExercisesOverviewBuilder {

  GroupExercisesOverviewBuilder (ExercisesOverviewController controller) : super(controller);

  @override
  Widget bottomNavigationBar(BuildContext context) {
    return Visibility(visible: false, child: BottomAppBar());
  }

  @override
  Widget floatingActionButton(BuildContext context) {
    if (controller.selectionManager.objects.length > 0) {
      return FloatingActionButton(
        onPressed: () {
          controller.onStartPressed(context, controller.selectionManager.objects);
        },
        child: SvgPicture.asset(
            AssetPaths.start
        ),
      );
    }
    return Container();
  }

}

class GroupPageState extends State<GroupPage> {


  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  ExercisesOverviewController _overviewController;

  ExercisesOverviewBuilder _overviewBuilder;

  LogoutHandler _logoutHandler;

  @override
  void initState() {
    super.initState();
    _logoutHandler = LogoutHandler(
      context
    );
    _logoutHandler.listen();
    _overviewController = ExercisesOverviewController(
        exercisesOperationManager: OperationManager(
            operationBuilder: () {
              return ExercisesDownloadOperation(groupId: widget.group.id);
            },
            onReset: () {
              if (_overviewController != null) {
                _overviewController.resetSelection();
              }
            }
        ),
        platformDataProvider: widget.platformDataProvider
    );
    _overviewBuilder = GroupExercisesOverviewBuilder(_overviewController);

  }

  @override
  void dispose() {
    super.dispose();
    _logoutHandler.unListen();
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
                title: this.widget.group.name,
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
              bottomNavigationBar: _overviewBuilder.bottomNavigationBar(context),
          );;
        },
      ),
    );
  }


}
