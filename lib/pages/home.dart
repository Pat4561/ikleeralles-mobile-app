import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:ikleeralles/constants.dart';
import 'package:ikleeralles/logic/managers/operation.dart';
import 'package:ikleeralles/logic/managers/platform.dart';
import 'package:ikleeralles/logic/operations/abstract.dart';
import 'package:ikleeralles/logic/operations/exercises.dart';
import 'package:ikleeralles/logic/operations/trash.dart';
import 'package:ikleeralles/network/models/exercise_list.dart';
import 'package:ikleeralles/network/models/folder.dart';
import 'package:ikleeralles/pages/exercises_overview.dart';
import 'package:ikleeralles/pages/folder.dart';
import 'package:ikleeralles/pages/search.dart';
import 'package:ikleeralles/ui/badge.dart';
import 'package:ikleeralles/ui/bottomsheets/folders.dart';
import 'package:ikleeralles/ui/bottomsheets/trash.dart';
import 'package:ikleeralles/ui/dialogs/create_folder.dart';
import 'package:ikleeralles/ui/snackbar.dart';
import 'package:ikleeralles/ui/tables/exercises_overview.dart';
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

  final PlatformDataProvider platformDataProvider = PlatformDataProvider();

  OperationManager _trashOperationManager;


  @override
  PlatformDataProvider getPlatformDataProvider() => platformDataProvider;

  @override
  void initState() {

    _trashOperationManager = OperationManager(
      operationBuilder: () {
        return TrashDownloadOperation();
      }
    );



    platformDataProvider.load();

    super.initState();
  }

  void _onRecoverPressed(ExerciseList exerciseList) {
    Navigator.pop(context);
    int index = trashTableKey.currentState.removeObject(exerciseList);
    exercisesTableKey.currentState.insertObject(exerciseList, index: 0);
    actionsManager.restoreExerciseList(exerciseList).catchError((e) {
      exercisesTableKey.currentState.removeObject(exerciseList);
      trashTableKey.currentState.insertObject(exerciseList, index: index);
      showToast(FlutterI18n.translate(context, TranslationKeys.restoreError));
    });
  }

  void _onFolderPressed(Folder folder) {
    Navigator.push(context, MaterialPageRoute(
      builder: (BuildContext context) {
        return FolderPage(folder, platformDataProvider: platformDataProvider);
      }
    ));
  }

  void _onDeleteFolderPressed(Folder folder) {
    int index = foldersTableKey.currentState.removeObject(folder);
    actionsManager.deleteFolder(folder).catchError((e) {
      foldersTableKey.currentState.insertObject(folder, index: index);
      showToast(FlutterI18n.translate(context, TranslationKeys.folderDeleteError));
    });
  }

  void _createFolderPressed() {
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

  void _onMyFoldersPressed() {
    FoldersBottomSheetPresenter(
      key: foldersTableKey,
      operationManager: foldersOperationManager,
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
        return SearchPage(
          platformDataProvider: platformDataProvider
        );
      }
    ));
  }



  @override
  Widget appBar(BuildContext context) {
    return ThemedAppBar(
      title: FlutterI18n.translate(context, TranslationKeys.myLists),
      disablePopping: true,
      showUserInfo: true,
      leading: IconButton(
        padding: EdgeInsets.all(0),
        icon: Icon(Icons.menu, color: Colors.white),
        onPressed: () => scaffoldKey.currentState.openDrawer(),
      ),
    );
  }

  Widget drawer(BuildContext context) {
    return Drawer(
      child: ListView(
        children: <Widget>[
          SafeArea(
            top: true,
            child: Container(
              decoration: BoxDecoration(
                  border: Border(
                      bottom: BorderSide(
                          color: BrandColors.borderColor,
                          width: 0.5
                      )
                  )
              ),
              padding: EdgeInsets.symmetric(
                  vertical: 25,
                  horizontal: 10
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text("Ikleeralles.nl", style: TextStyle(fontFamily: Fonts.justAnotherHand, fontSize: 38),)
                ],
              ),
            )
          ),
          ListTile(
            leading: Icon(Icons.person, color: BrandColors.secondaryButtonColor),
            title: Text('Mijn lijsten', style: TextStyle(fontFamily: Fonts.ubuntu, fontSize: 16, fontWeight: FontWeight.bold, color: BrandColors.secondaryButtonColor)),
            onTap: () {
              // Update the state of the app.
              // ...
            },
          ),
          ListTile(
            leading: Icon(Icons.group, color: Colors.black),
            title: Text('Groepen', style: TextStyle(fontFamily: Fonts.ubuntu, fontSize: 16, fontWeight: FontWeight.bold)),
            onTap: () {
              // Update the state of the app.
              // ...
            },
          ),
          ListTile(
            leading: Icon(Icons.list, color: Colors.black),
            title: Text('Publieke lijsten', style: TextStyle(fontFamily: Fonts.ubuntu, fontSize: 16, fontWeight: FontWeight.bold)),
            trailing: Text(
              "10.000+",
              style: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                  fontFamily: Fonts.ubuntu
              ),
            ),
            onTap: () {
              // Update the state of the app.
              // ...
            },
          ),
          ListTile(
            leading: Icon(Icons.monetization_on, color: Colors.black),
            title: Text('Premium', style: TextStyle(fontFamily: Fonts.ubuntu, fontSize: 16, fontWeight: FontWeight.bold)),
            onTap: () {
              // Update the state of the app.
              // ...
            },
          ),
          ListTile(
            title: Text('Uitloggen', style: TextStyle(fontFamily: Fonts.ubuntu, fontSize: 16, fontWeight: FontWeight.bold)),
            trailing: Icon(Icons.exit_to_app, color: Colors.red),
            onTap: () {
              // Update the state of the app.
              // ...
            },
          )
        ],
      ),
    );
  }

  @override
  Widget scaffold(BuildContext context) {
    return Scaffold(
        key: scaffoldKey,
        appBar: appBar(context),
        body: body(context),
        drawer: drawer(context),
        floatingActionButton: floatingActionButton(context),
        bottomNavigationBar: bottomNavigationBar(context)
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
      platformDataProvider: platformDataProvider,
      tablePadding: EdgeInsets.only(
        top: 25,
        bottom: 25
      ),
    );
  }

  @override
  OperationManager<Operation> createExercisesOperationManager() {
    return OperationManager(
      operationBuilder: () {
        return ExercisesDownloadOperation();
      },
      onReset: () {
        selectionManager.unSelectAll();
      }
    );
  }



}

