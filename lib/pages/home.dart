import 'dart:async';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ikleeralles/constants.dart';
import 'package:ikleeralles/logic/managers/extensions.dart';
import 'package:ikleeralles/network/models/exercise_list.dart';
import 'package:ikleeralles/ui/tables/exercise_list.dart';
import 'package:ikleeralles/ui/themed/appbar.dart';
import 'package:scoped_model/scoped_model.dart';

class HomePage extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    return _HomePageState();
  }

}

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

class _HomePageState extends State<HomePage> {

  final SelectionManager<ExerciseList> selectionManager = SelectionManager<ExerciseList>();

  final GlobalKey<ExercisesTableState> exercisesTableKey = GlobalKey<ExercisesTableState>();

  @override
  void initState() {
    super.initState();
  }

  void _onStartPressed(List<ExerciseList> exercises) {

  }

  void _onMergePressed(List<ExerciseList> exercises) {

  }

  void _onDeletePressed(List<ExerciseList> exercises) {

  }

  void _onExerciseListPressed(ExerciseList exerciseList) {

  }

  void _onMyFoldersPressed() {

  }

  void _onPublicListsPressed() {

  }

  void _onTrashPressed() {

  }

  void _onAddPressed() {

  }

  @override
  Widget build(BuildContext context) {
    return ScopedModel(
      model: selectionManager,
      child: ScopedModelDescendant<SelectionManager<ExerciseList>>(
        builder: (BuildContext context, Widget widget, SelectionManager manager) {
          return Scaffold(
            appBar: ThemedAppBar(
              title: FlutterI18n.translate(context, TranslationKeys.myLists),
            ),
            body: ExercisesTable(
              key: exercisesTableKey,
              selectionManager: selectionManager,
              onExerciseListPressed: _onExerciseListPressed,
              onMyFolderPressed: _onMyFoldersPressed,
              onPublicListsPressed: _onPublicListsPressed,
              onTrashPressed: _onTrashPressed,
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: _onAddPressed,
              child: SvgPicture.asset(
                  AssetPaths.add
              ),
            ),
            bottomNavigationBar: Visibility(
              child: SelectionBar(
                selectionCount: selectionManager.objects.length,
                onStartPressed: () {
                  _onStartPressed(selectionManager.objects);
                },
                onDeletePressed: () {
                  _onDeletePressed(selectionManager.objects);
                },
                onMergePressed: () {
                  _onMergePressed(selectionManager.objects);
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