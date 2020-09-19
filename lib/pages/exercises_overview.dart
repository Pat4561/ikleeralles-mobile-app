import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:ikleeralles/constants.dart';
import 'package:ikleeralles/logic/managers/extensions.dart';
import 'package:ikleeralles/logic/managers/operation.dart';
import 'package:ikleeralles/network/models/exercise_list.dart';
import 'package:ikleeralles/ui/tables/exercise_list.dart';
import 'package:scoped_model/scoped_model.dart';


class SelectionBar extends StatelessWidget {

  final int selectionCount;
  final Function onStartPressed;
  final Function onMergePressed;
  final Function onDeletePressed;

  SelectionBar ({ @required this.selectionCount, @required this.onStartPressed,
    @required this.onMergePressed, @required this.onDeletePressed });

  Widget iconButton({ @required Function onPressed, @required String assetPath }) {
    return Container(
        margin: EdgeInsets.only(
            left: 15
        ),
        child: IconButton(
          icon: SvgPicture.asset(
            assetPath,
            color: Colors.white,
          ),
          onPressed: onPressed,
        )
    );
  }

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      color: BrandColors.themeColor,
      child: Container(
        margin: EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 4
        ),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Expanded(child: Container(
              child: AutoSizeText(
                FlutterI18n.translate(context, TranslationKeys.selectedLists, { "count": selectionCount.toString() }),
                minFontSize: 11,
                style: TextStyle(
                    fontFamily: Fonts.ubuntu,
                    fontSize: 14,
                    color: Colors.white
                ),
              ),
            )),
            iconButton(
                assetPath: AssetPaths.start,
                onPressed: this.onStartPressed
            ),
            iconButton(
                assetPath: AssetPaths.merge,
                onPressed: this.onMergePressed
            ),
            iconButton(
                assetPath: AssetPaths.trashSolid,
                onPressed: this.onDeletePressed
            )
          ],
        ),
      ),
    );
  }

}

abstract class ExercisesOverviewPageState<T extends StatefulWidget> extends State<T> {

  final SelectionManager<ExerciseList> selectionManager = SelectionManager<ExerciseList>();

  final GlobalKey<ExercisesTableState> exercisesTableKey = GlobalKey<ExercisesTableState>();

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  OperationManager _exercisesOperationManager;

  OperationManager get exercisesOperationManager {
    return _exercisesOperationManager;
  }

  @override
  void initState() {
    _exercisesOperationManager = createExercisesOperationManager();
    super.initState();
  }

  void onStartPressed(List<ExerciseList> exercises) {

  }

  void onMergePressed(List<ExerciseList> exercises) {

  }

  void onDeletePressed(List<ExerciseList> exercises) {

  }

  void onExerciseListPressed(ExerciseList exerciseList) {

  }

  void onAddPressed() {

  }

  Widget appBar(BuildContext context);

  Widget body(BuildContext context);

  OperationManager createExercisesOperationManager();

  @override
  Widget build(BuildContext context) {
    return ScopedModel(
      model: selectionManager,
      child: ScopedModelDescendant<SelectionManager<ExerciseList>>(
        builder: (BuildContext context, Widget widget, SelectionManager manager) {
          return Scaffold(
              key: scaffoldKey,
              appBar: appBar(context),
              body: body(context),
              floatingActionButton: FloatingActionButton(
                onPressed: onAddPressed,
                child: SvgPicture.asset(
                    AssetPaths.add
                ),
              ),
              bottomNavigationBar: Visibility(
                child: SelectionBar(
                  selectionCount: selectionManager.objects.length,
                  onStartPressed: () {
                    onStartPressed(selectionManager.objects);
                  },
                  onDeletePressed: () {
                    onDeletePressed(selectionManager.objects);
                  },
                  onMergePressed: () {
                    onMergePressed(selectionManager.objects);
                  },
                ),
                visible: selectionManager.objects.length > 0,
              )
          );
        },
      ),
    );
  }
}