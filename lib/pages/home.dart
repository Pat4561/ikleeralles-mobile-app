import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ikleeralles/constants.dart';
import 'package:ikleeralles/logic/managers/operation.dart';
import 'package:ikleeralles/logic/managers/platform.dart';
import 'package:ikleeralles/logic/operations/exercises.dart';
import 'package:ikleeralles/logic/operations/folders.dart';
import 'package:ikleeralles/logic/operations/search.dart';
import 'package:ikleeralles/logic/operations/trash.dart';
import 'package:ikleeralles/network/models/exercise_list.dart';
import 'package:ikleeralles/pages/exercise_list.dart';
import 'package:ikleeralles/pages/exercises_overview.dart';
import 'package:ikleeralles/ui/tables/exercises_overview.dart';
import 'package:ikleeralles/ui/tables/search.dart';
import 'package:ikleeralles/ui/themed/appbar.dart';

class HomePage extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    return _HomePageState();
  }

}

class _HomePageDrawer extends StatelessWidget {

  static const String keyMyLists = "myLists";
  static const String keyGroups = "groups";
  static const String keyPublicLists = "publicLists";
  static const String keyPremium = "premium";
  static const String keyLogout = "logout";

  final Function(String) onPressed;
  final NavigationDrawerController drawerController;

  _HomePageDrawer (this.drawerController, { @required this.onPressed });

  Widget _header(BuildContext context) {
    return SafeArea(
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
              Text(Constants.appName, style: TextStyle(fontFamily: Fonts.justAnotherHand, fontSize: 38))
            ],
          ),
        )
    );
  }

  Widget _menuItem(BuildContext context, { @required IconData iconData, @required String title, @required String key }) {
    bool isActive = drawerController.activeChild.key == key;
    Color color = isActive ? BrandColors.secondaryButtonColor : Colors.black;
    return ListTile(
      leading: Icon(iconData, color: color),
      title: Text(title, style: TextStyle(fontFamily: Fonts.ubuntu, fontSize: 16, fontWeight: FontWeight.bold, color: color)),
      onTap: () {
        onPressed(key);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: <Widget>[
          _header(context),
          _menuItem(context, iconData: Icons.person, title: "Mijn lijsten", key: _HomePageDrawer.keyMyLists),
          _menuItem(context, iconData: Icons.group, title: "Groepen", key: _HomePageDrawer.keyGroups),
          _menuItem(context, iconData: Icons.public, title: "Publieke lijsten", key: _HomePageDrawer.keyPublicLists),
          _menuItem(context, iconData: Icons.monetization_on, title: "Premium", key: _HomePageDrawer.keyPremium),
          ListTile(
            title: Text('Uitloggen', style: TextStyle(fontFamily: Fonts.ubuntu, fontSize: 16, fontWeight: FontWeight.bold)),
            trailing: Icon(Icons.exit_to_app, color: Colors.red),
            onTap: () => onPressed(keyLogout),
          )
        ],
      ),
    );
  }

}


abstract class NavigationDrawerContentChild {

  final String key;
  final NavigationDrawerController navigationDrawerController;

  String get title;

  Widget body(BuildContext context);

  Widget bottomNavigationBar(BuildContext context) {
    return null;
  }

  Widget floatingActionButton(BuildContext context) {
    return null;
  }

  Widget appBar(BuildContext context, GlobalKey<ScaffoldState> scaffoldKey) {
    return navigationDrawerController.appBar(context, scaffoldKey, title);
  }
   
  NavigationDrawerContentChild (this.navigationDrawerController, { @required this.key });

}

class NavigationDrawerController {

  ValueNotifier<NavigationDrawerContentChild> _notifier;

  ValueNotifier<NavigationDrawerContentChild> get notifier => _notifier;

  NavigationDrawerContentChild get activeChild => _notifier.value;

  set activeChild (NavigationDrawerContentChild child) => _notifier.value = child;

  NavigationDrawerController () {
    _notifier = ValueNotifier<NavigationDrawerContentChild>(null);
  }

  Widget appBar(BuildContext context, GlobalKey<ScaffoldState> scaffoldKey, String title) {

    return ThemedAppBar(
      title: title,
      disablePopping: true,
      showUserInfo: true,
      leading: IconButton(
        padding: EdgeInsets.all(0),
        icon: Icon(Icons.menu, color: Colors.white),
        onPressed: () => scaffoldKey.currentState.openDrawer(),
      ),
    );
  }

}

class _PremiumInfoSubPage extends NavigationDrawerContentChild {


  _PremiumInfoSubPage (NavigationDrawerController controller, String key) : super(controller, key: key);

  @override
  String get title => "Premium";

  @override
  Widget body(BuildContext context) {
    return Container();
  }

}

class _GroupsSubPage extends NavigationDrawerContentChild {

  _GroupsSubPage (NavigationDrawerController controller, String key) : super(controller, key: key);

  @override
  String get title => "Groepen";

  @override
  Widget body(BuildContext context) {
    return Container();
  }

}

class _MyExercisesSubPage extends NavigationDrawerContentChild {


  @override
  String get title => "Mijn overhoringen";

  ExercisesOverviewController _overviewController;

  ExercisesOverviewBuilder _overviewBuilder;

  _MyExercisesSubPage (NavigationDrawerController controller, String key, { @required PlatformDataProvider platformDataProvider }) : super(controller, key: key) {
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

  @override
  Widget bottomNavigationBar(BuildContext context) {
    return _overviewBuilder.bottomNavigationBar(context);
  }

  @override
  Widget floatingActionButton(BuildContext context) {
    return _overviewBuilder.floatingActionButton(context);
  }

}






class _PublicSearchSubPage extends NavigationDrawerContentChild {

  final GlobalKey<SearchTableState> _searchTableKey = GlobalKey<SearchTableState>();

  final SearchQuery _searchQuery = SearchQuery();

  final PlatformDataProvider platformDataProvider;

  OperationManager _operationManager;

  @override
  String get title => "Publieke lijsten";

  _PublicSearchSubPage (NavigationDrawerController controller, String key, { @required this.platformDataProvider }) : super(controller, key: key) {
    _searchQuery.update(
        level: this.platformDataProvider.levels.first,
        year: this.platformDataProvider.years.first
    );
    _operationManager = OperationManager(
        operationBuilder: () {
          return SearchOperation(_searchQuery);
        }
    );
  }

  void _onExerciseListPressed(BuildContext context, ExerciseList exerciseList) {
    Navigator.push(context, MaterialPageRoute(
        builder: (BuildContext context) {
          return ExerciseEditorPage(exerciseList: exerciseList, readOnly: true, platformDataProvider: platformDataProvider);
        }
    ));
  }

  @override
  Widget body(BuildContext context) {
    return SearchTable(
      key: _searchTableKey,
      onExerciseListPressed: (exerciseList) => _onExerciseListPressed(context, exerciseList),
      operationManager: _operationManager,
      platformDataProvider: platformDataProvider,
    );
  }

  @override
  Widget appBar(BuildContext context, GlobalKey<ScaffoldState> scaffoldKey) {

    return ThemedSearchAppBar(
        platformDataProvider: platformDataProvider,
        onPerformSearch: (String search, String year, String level) {
          _searchQuery.update(
              search: search,
              year: year,
              level: level
          );
          _searchTableKey.currentState.showRefresh();
        },
        leading: IconButton(
          padding: EdgeInsets.all(0),
          icon: Icon(Icons.menu, color: Colors.white),
          onPressed: () => scaffoldKey.currentState.openDrawer(),
        ),
    );

  }
}

class _HomePageState extends State<HomePage> {

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  final PlatformDataProvider platformDataProvider = PlatformDataProvider();

  NavigationDrawerController _navigationDrawerController;

  NavigationDrawerContentChild _getContentChild(String key) {
    switch (key) {
      case _HomePageDrawer.keyMyLists:
        return _MyExercisesSubPage(_navigationDrawerController, _HomePageDrawer.keyMyLists, platformDataProvider: platformDataProvider);
      case _HomePageDrawer.keyGroups:
        return _GroupsSubPage(_navigationDrawerController, _HomePageDrawer.keyGroups);
      case _HomePageDrawer.keyPublicLists:
        return _PublicSearchSubPage(_navigationDrawerController, _HomePageDrawer.keyPublicLists, platformDataProvider: platformDataProvider);
      case _HomePageDrawer.keyPremium:
        return _PremiumInfoSubPage(_navigationDrawerController, _HomePageDrawer.keyPremium);
    }
    return null;
  }

  @override
  void initState() {
    platformDataProvider.load();
    _navigationDrawerController = NavigationDrawerController();
    _navigationDrawerController.activeChild = _getContentChild(_HomePageDrawer.keyMyLists);
    super.initState();
  }

  void _onNavigationOptionPressed(String key) {
    if (key == _HomePageDrawer.keyLogout) {

    } else {
      _navigationDrawerController.activeChild = _getContentChild(key);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: _navigationDrawerController.notifier,
      builder: (BuildContext context, NavigationDrawerContentChild child, Widget widget) {
        return Scaffold(
            key: scaffoldKey,
            appBar: _navigationDrawerController.activeChild.appBar(context, scaffoldKey),
            body: _navigationDrawerController.activeChild.body(context),
            drawer: _HomePageDrawer(
              _navigationDrawerController,
              onPressed: _onNavigationOptionPressed,
            ),
            floatingActionButton: _navigationDrawerController.activeChild.floatingActionButton(context),
            bottomNavigationBar: _navigationDrawerController.activeChild.bottomNavigationBar(context)
        );
      },
    );
  }

}




