import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ikleeralles/constants.dart';
import 'package:ikleeralles/logic/managers/exercises/actions.dart';
import 'package:ikleeralles/logic/managers/extensions.dart';
import 'package:ikleeralles/logic/managers/operation.dart';
import 'package:ikleeralles/logic/operations/folders.dart';
import 'package:ikleeralles/network/models/exercise_list.dart';
import 'package:ikleeralles/ui/bottomsheets/folders.dart';
import 'package:ikleeralles/ui/snackbar.dart';
import 'package:ikleeralles/ui/tables/exercise_list.dart';
import 'package:scoped_model/scoped_model.dart';


class SelectionBar extends StatelessWidget {

  final int selectionCount;
  final Function onMovePressed;
  final Function onMergePressed;
  final Function onDeletePressed;

  SelectionBar ({ @required this.selectionCount, @required this.onMovePressed,
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
            width: 26,
            height: 26,
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
                assetPath: AssetPaths.move,
                onPressed: this.onMovePressed
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

  final ExercisesActionsManager actionsManager = ExercisesActionsManager();

  final GlobalKey<ExercisesTableState> exercisesTableKey = GlobalKey<ExercisesTableState>();

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  OperationManager _exercisesOperationManager;

  OperationManager _foldersOperationManager;

  OperationManager get exercisesOperationManager {
    return _exercisesOperationManager;
  }

  OperationManager get foldersOperationManager {
    return _foldersOperationManager;
  }

  @override
  void initState() {
    _exercisesOperationManager = createExercisesOperationManager();
    _foldersOperationManager = OperationManager(
        operationBuilder: () {
          return FoldersDownloadOperation();
        }
    );
    super.initState();
  }

  void onMovePressed(List<ExerciseList> exercises) {
    FoldersBottomSheetPresenter(
        operationManager: foldersOperationManager,
        onFolderPressed: (folder) {
          Navigator.pop(context);
          var toast = showLoadingToast(context, timeOutDuration: Duration(seconds: 30));
          actionsManager.move(exercises, folder: folder).then((_) {
            toast.removeCustomToast();
            Future.delayed(Duration(milliseconds: 150), () {
              showToast(FlutterI18n.translate(context, TranslationKeys.itemsAddedToFolderSuccess, {
                "count": exercises.length.toString(),
                "folderName": folder.name
              }),
                backgroundColor: Colors.green,
                textColor: Colors.white,
              );
            });
          }).catchError((e) {
            toast.removeCustomToast();
            Future.delayed(Duration(milliseconds: 150), () {
              showToast(FlutterI18n.translate(context, TranslationKeys.errorSubTitle));
            });
          });

        }
    ).show(context);
  }

  void onMergePressed(List<ExerciseList> exercises) {
    FToast toast = showLoadingToast(context);
    actionsManager.merge(
      exercises
    ).then((_) {
      toast.removeCustomToast();
      Future.delayed(Duration(milliseconds: 150), () {
        showToast(FlutterI18n.translate(context, TranslationKeys.successMerged),
          backgroundColor: Colors.green,
          textColor: Colors.white,
        );
      });
    }).catchError((e){
      toast.removeCustomToast();
      Future.delayed(Duration(milliseconds: 150), () {
        showToast(FlutterI18n.translate(context, TranslationKeys.errorSubTitle));
      });
    });
  }

  void onDeletePressed(List<ExerciseList> exercises) {

    List resultList = exercisesTableKey.currentState.widget.operationManager.currentState.result;
    List copiedList = List.from(resultList);
    exercisesTableKey.currentState.removeObjects(exercises);
    actionsManager.deleteExercises(
      exercises
    ).catchError((e) {
      exercisesTableKey.currentState.restoreResult(
        copiedList
      );
      showToast(FlutterI18n.translate(context, TranslationKeys.errorSubTitle));
    });

  }

  void onStartPressed(List<ExerciseList> exercises) {

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
              floatingActionButton: () {
                if (selectionManager.objects.length > 0) {
                  return FloatingActionButton(
                    onPressed: () {
                      onStartPressed(selectionManager.objects);
                    },
                    child: SvgPicture.asset(
                        AssetPaths.start
                    ),
                  );
                } else {
                  return FloatingActionButton(
                    onPressed: onAddPressed,
                    child: SvgPicture.asset(
                        AssetPaths.add
                    ),
                  );
                }
              }(),
              bottomNavigationBar: Visibility(
                child: SelectionBar(
                  selectionCount: selectionManager.objects.length,
                  onMovePressed: () {
                    onMovePressed(selectionManager.objects);
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