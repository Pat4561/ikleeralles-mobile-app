import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:ikleeralles/constants.dart';
import 'package:ikleeralles/logic/managers/exercises/actions.dart';
import 'package:ikleeralles/logic/managers/extensions.dart';
import 'package:ikleeralles/logic/managers/operation.dart';
import 'package:ikleeralles/logic/managers/platform.dart';
import 'package:ikleeralles/logic/operations/exercises.dart';
import 'package:ikleeralles/logic/operations/folders.dart';
import 'package:ikleeralles/logic/quiz/input.dart';
import 'package:ikleeralles/network/models/exercise_list.dart';
import 'package:ikleeralles/network/models/folder.dart';
import 'package:ikleeralles/pages/exercise_list.dart';
import 'package:ikleeralles/pages/folder.dart';
import 'package:ikleeralles/ui/bottomsheets/folders.dart';
import 'package:ikleeralles/ui/bottomsheets/quiz_options.dart';
import 'package:ikleeralles/ui/bottomsheets/trash.dart';
import 'package:ikleeralles/ui/dialogs/create_folder.dart';
import 'package:ikleeralles/ui/dialogs/premium_lock.dart';
import 'package:ikleeralles/ui/snackbar.dart';
import 'package:ikleeralles/ui/tables/exercises_overview.dart';
import 'package:ikleeralles/ui/tables/folders.dart';
import 'package:ikleeralles/ui/tables/trash.dart';
import 'package:ikleeralles/ui/themed/appbar.dart';
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

class ExercisesOverviewController {

  final SelectionManager<ExerciseList> selectionManager = SelectionManager<ExerciseList>();

  final ExercisesActionsManager actionsManager = ExercisesActionsManager();

  final GlobalKey<ExercisesTableState> exercisesTableKey = GlobalKey<ExercisesTableState>();

  final GlobalKey<FoldersTableState> foldersTableKey = GlobalKey<FoldersTableState>();

  final GlobalKey<TrashTableState> trashTableKey = GlobalKey<TrashTableState>();

  final PremiumLocker premiumLocker = PremiumLocker();

  final OperationManager foldersOperationManager;

  final OperationManager exercisesOperationManager;

  final OperationManager trashOperationManager;

  final PlatformDataProvider platformDataProvider;

  ExercisesOverviewController ({
    this.foldersOperationManager,
    this.trashOperationManager,
    @required this.exercisesOperationManager,
    @required this.platformDataProvider
  });

  void onMovePressed(BuildContext context, List<ExerciseList> exercises) {
    LoadingMessageHandler loadingMessageHandler = LoadingMessageHandler();

    FoldersBottomSheetPresenter(
        operationManager: foldersOperationManager,
        onFolderPressed: (folder) {
          Navigator.pop(context);
          loadingMessageHandler.show(context);
          actionsManager.move(exercises, folder: folder).then((_) {
            loadingMessageHandler.clear(callback: () {
              showToast(FlutterI18n.translate(context, TranslationKeys.itemsAddedToFolderSuccess, {
                "count": exercises.length.toString(),
                "folderName": folder.name
              }),
                backgroundColor: Colors.green,
                textColor: Colors.white,
              );
            });

          }).catchError((e) {
            loadingMessageHandler.clear(callback: () {
              showToast(FlutterI18n.translate(context, TranslationKeys.errorSubTitle));
            });
          });

        }
    ).show(context);
  }

  void onMergePressed(BuildContext context, List<ExerciseList> exercises) {

    if (!premiumLocker.isPremium) {
      premiumLocker.schedulePresentation(context);
      return;
    }


    LoadingMessageHandler loadingMessageHandler = LoadingMessageHandler();
    loadingMessageHandler.show(context);
    actionsManager.merge(
        exercises,
        name: FlutterI18n.translate(context, TranslationKeys.newMergedListName)
    ).then((exerciseList) {
      exercisesTableKey.currentState.insertObject(
          exerciseList,
          index: 0
      );
      loadingMessageHandler.clear(
          callback: () {
            showToast(FlutterI18n.translate(context, TranslationKeys.successMerged),
              backgroundColor: Colors.green,
              textColor: Colors.white,
            );
          }
      );

    }).catchError((e){
      loadingMessageHandler.clear(
          callback: () {
            showToast(FlutterI18n.translate(context, TranslationKeys.errorSubTitle));
          }
      );
    }).whenComplete(() {
      selectionManager.unSelectAll();
    });
  }

  void onDeletePressed(BuildContext context, List<ExerciseList> exercises) {

    List resultList = exercisesTableKey.currentState.widget.operationManager.currentState.result;
    List copiedList = List.from(resultList);
    exercisesTableKey.currentState.removeObjects(exercises);
    selectionManager.unSelectAll();
    actionsManager.deleteExercises(
        exercises
    ).catchError((e) {
      exercisesTableKey.currentState.restoreResult(
          copiedList
      );
      showToast(FlutterI18n.translate(context, TranslationKeys.errorSubTitle));
    });

  }

  void onStartPressed(BuildContext context, List<ExerciseList> exercises) {
    var quizInput = QuizInput(exercises, platformDataProvider: platformDataProvider);
    quizInput.initialize(context);
    QuizOptionsBottomSheetPresenter(
        quizInput: quizInput
    ).show(context);
  }

  void onExerciseListPressed(BuildContext context, ExerciseList exerciseList) {
    Navigator.push(context, MaterialPageRoute(
        builder: (BuildContext context) {
          return ExerciseEditorPage(exerciseList: exerciseList, platformDataProvider: platformDataProvider);
        }
    ));
  }

  void onAddPressed(BuildContext context) {
    Navigator.push(context, MaterialPageRoute(
        builder: (BuildContext context) {
          return ExerciseEditorPage(platformDataProvider: platformDataProvider);
        }
    ));
  }

  void onRecoverPressed(BuildContext context, ExerciseList exerciseList) {
    Navigator.pop(context);
    int index = trashTableKey.currentState.removeObject(exerciseList);
    exercisesTableKey.currentState.insertObject(exerciseList, index: 0);
    actionsManager.restoreExerciseList(exerciseList).catchError((e) {
      exercisesTableKey.currentState.removeObject(exerciseList);
      trashTableKey.currentState.insertObject(exerciseList, index: index);
      showToast(FlutterI18n.translate(context, TranslationKeys.restoreError));
    });
  }

  void onFolderPressed(BuildContext context, Folder folder) {
    Navigator.push(context, MaterialPageRoute(
        builder: (BuildContext context) {
          return FolderPage(folder, platformDataProvider: platformDataProvider);
        }
    ));
  }

  void onDeleteFolderPressed(BuildContext context, Folder folder) {
    int index = foldersTableKey.currentState.removeObject(folder);
    actionsManager.deleteFolder(folder).catchError((e) {
      foldersTableKey.currentState.insertObject(folder, index: index);
      showToast(FlutterI18n.translate(context, TranslationKeys.folderDeleteError));
    });
  }

  void createFolderPressed(BuildContext context) {
    CreateFolderDialog.show(
        context,
        onCreatePressed: (value) {
          Navigator.pop(context);

          Folder folder = Folder.create(name: value);
          foldersTableKey.currentState.insertObject(folder, index: 0);

          actionsManager.createFolder(value).catchError((e) {
            foldersTableKey.currentState.removeObject(folder);
            showToast(FlutterI18n.translate(context, TranslationKeys.folderCreateError));
          });
        }
    );
  }

  void onMyFoldersPressed(BuildContext context) {
    FoldersBottomSheetPresenter(
        key: foldersTableKey,
        operationManager: foldersOperationManager,
        onFolderPressed: (folder) => onFolderPressed(context, folder),
        onDeleteFolderPressed: (folder) => onDeleteFolderPressed(context, folder),
        createFolderPressed: () => createFolderPressed(context)
    ).show(context);
  }

  void onTrashPressed(BuildContext context) {
    TrashBottomSheetPresenter(
        key: trashTableKey,
        operationManager: trashOperationManager,
        onRecoverPressed: onRecoverPressed
    ).show(context);
  }

  void resetSelection() {
    selectionManager.unSelectAll();
  }

}

class ExercisesOverviewBuilder {


  final ExercisesOverviewController controller;

  ExercisesOverviewBuilder (this.controller);

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
    } else {
      return FloatingActionButton(
        onPressed: () => controller.onAddPressed(context),
        child: SvgPicture.asset(
            AssetPaths.add
        ),
      );
    }
  }

  Widget bottomNavigationBar(BuildContext context) {
    return Visibility(
      child: SelectionBar(
        selectionCount: controller.selectionManager.objects.length,
        onMovePressed: () {
          controller.onMovePressed(context, controller.selectionManager.objects);
        },
        onDeletePressed: () {
          controller.onDeletePressed(context, controller.selectionManager.objects);
        },
        onMergePressed: () {
          controller.onMergePressed(context, controller.selectionManager.objects);
        },
      ),
      visible: controller.selectionManager.objects.length > 0,
    );
  }

}



