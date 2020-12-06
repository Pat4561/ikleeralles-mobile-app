import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ikleeralles/constants.dart';
import 'package:ikleeralles/logic/managers/extensions.dart';
import 'package:ikleeralles/logic/managers/operation.dart';
import 'package:ikleeralles/logic/managers/platform.dart';
import 'package:ikleeralles/logic/operations/exercises.dart';
import 'package:ikleeralles/logic/operations/folders.dart';
import 'package:ikleeralles/logic/operations/search.dart';
import 'package:ikleeralles/logic/operations/trash.dart';
import 'package:ikleeralles/network/models/exercise_list.dart';
import 'package:ikleeralles/pages/exercise_list.dart';
import 'package:ikleeralles/pages/exercises_overview.dart';
import 'package:ikleeralles/ui/navigation_drawer.dart';
import 'package:ikleeralles/ui/tables/exercises_overview.dart';
import 'package:ikleeralles/ui/tables/search.dart';
import 'package:ikleeralles/ui/themed/appbar.dart';
import 'package:ikleeralles/ui/themed/button.dart';
import 'package:scoped_model/scoped_model.dart';

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
          _menuItem(context, iconData: Icons.person, title: FlutterI18n.translate(context, TranslationKeys.myLists), key: _HomePageDrawer.keyMyLists),
          _menuItem(context, iconData: Icons.group, title: FlutterI18n.translate(context, TranslationKeys.myGroups), key: _HomePageDrawer.keyGroups),
          _menuItem(context, iconData: Icons.public, title: FlutterI18n.translate(context, TranslationKeys.publicLists), key: _HomePageDrawer.keyPublicLists),
          _menuItem(context, iconData: Icons.shopping_basket, title: FlutterI18n.translate(context, TranslationKeys.premium), key: _HomePageDrawer.keyPremium),
          ListTile(
            title: Text(FlutterI18n.translate(context, TranslationKeys.signOut), style: TextStyle(fontFamily: Fonts.ubuntu, fontSize: 16, fontWeight: FontWeight.bold)),
            trailing: Icon(Icons.exit_to_app, color: Colors.red),
            onTap: () => onPressed(keyLogout),
          )
        ],
      ),
    );
  }

}

class _PremiumInfoCard extends StatelessWidget {

  final String title;
  final String subtitle;
  final String iconAssetPath;
  final List<String> labels;

  _PremiumInfoCard (this.title, { @required this.iconAssetPath, @required this.subtitle, @required this.labels });

  Widget _label(String text) {
    return Container(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            child: Icon(Icons.check, color: Colors.green),
            width: 40,
            height: 20,
          ),
          Expanded(
            child: Text(text, style: TextStyle(
                fontFamily: Fonts.ubuntu,
                fontSize: 16
            )),
          ),
          Container(
            width: 40,
            height: 20,
          )
        ],
      ),
      margin: EdgeInsets.only(
        bottom: 6
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(5),
      decoration: BoxDecoration(
          color: BrandColors.lightGreyBackgroundColor,
          borderRadius: BorderRadius.circular(10)
      ),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(5),
            child: Row(
              children: [
                Container(
                    child: SvgPicture.asset(
                      iconAssetPath,
                      width: 50,
                      height: 50,
                    )
                ),
                Expanded(
                  child: Container(
                    margin: EdgeInsets.symmetric(
                      horizontal: 10
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                            child: Text(title, style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontFamily: Fonts.ubuntu,
                                fontSize: 22
                            ))
                        ),
                        Container(
                            child: Text(subtitle, style: TextStyle(
                                fontFamily: Fonts.ubuntu,
                                fontWeight: FontWeight.bold
                            ))
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(vertical: 10),
            child: Column(
              children: () {
                return labels.map((e) => _label(e)).toList();
              }(),
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: 10, bottom: 5, right: 10),
            child: ThemedButton(
              "Kiezen",
              icon: Icons.check_circle_outline,
              iconSize: 18,
              buttonColor: BrandColors.secondaryButtonColor,
              fontSize: 13,
              contentPadding: EdgeInsets.symmetric(
                  horizontal: 10
              ),
              borderRadius: BorderRadius.circular(15),
              onPressed: () {

              },
            ),
          )
        ],
      ),
    );
  }

}

class _PremiumInfoSubPage extends NavigationDrawerContentChild {


  _PremiumInfoSubPage (NavigationDrawerController controller, String key) : super(controller, key: key);

  @override
  Widget body(BuildContext context) {
    return Container(
      child: ListView(
        padding: EdgeInsets.all(20),
        children: [
          _PremiumInfoCard("Plus",
              iconAssetPath: "assets/svg/sub_plus.svg",
              subtitle: "€ 1,99 /maand",
              labels: [
                "20 Woordenlijsten scannen",
                "Woordjes achteraf goedrekenen",
                "Woordenlijsten samenvoegen",
                "Uitgebreide overhoortijd",
                "Met Enter naar volgende woord",
                "Herstellen uit prullenbak",
                "Aantal vragen instellen",
                "Toegang tot toekomstige optie"
              ]
          ),
          SizedBox(height: 20),
          _PremiumInfoCard("Pro",
              iconAssetPath: "assets/svg/sub_pro.svg",
              subtitle: "€ 11,99 /jaar",
              labels: [
                "Onbeperkt woordenlijsten scannen",
                "Alle functionaliteit van Plus",
                "Korting van 50%!"
              ]
          )
        ],
      ),
    );
  }

  @override
  String title(BuildContext context) {
    return FlutterI18n.translate(context, TranslationKeys.premium);
  }

}

class _GroupsSubPage extends NavigationDrawerContentChild {

  _GroupsSubPage (NavigationDrawerController controller, String key) : super(controller, key: key);

  @override
  Widget body(BuildContext context) {
    return Container();
  }

  @override
  String title(BuildContext context) {
    return FlutterI18n.translate(context, TranslationKeys.myGroups);
  }


}

class _MyExercisesSubPage extends NavigationDrawerContentChild {



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


class _PublicSearchSubPage extends NavigationDrawerContentChild {

  final GlobalKey<SearchTableState> _searchTableKey = GlobalKey<SearchTableState>();

  final SearchQuery _searchQuery = SearchQuery();

  final PlatformDataProvider platformDataProvider;

  OperationManager _operationManager;


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

  @override
  String title(BuildContext context) {
    return FlutterI18n.translate(context, TranslationKeys.publicLists);
  }


}

class _HomePageState extends State<HomePage> {

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  final PlatformDataProvider platformDataProvider = PlatformDataProvider();

  NavigationDrawerController _navigationDrawerController;

  NavigationDrawerContentChild _getContentChild(String key) {
    switch (key) {
      case _HomePageDrawer.keyMyLists:
        return _MyExercisesSubPage(_navigationDrawerController, _HomePageDrawer.keyMyLists,
            platformDataProvider: platformDataProvider);
      case _HomePageDrawer.keyGroups:
        return _GroupsSubPage(_navigationDrawerController, _HomePageDrawer.keyGroups);
      case _HomePageDrawer.keyPublicLists:
        return _PublicSearchSubPage(_navigationDrawerController, _HomePageDrawer.keyPublicLists,
            platformDataProvider: platformDataProvider);
      case _HomePageDrawer.keyPremium:
        return _PremiumInfoSubPage(
            _navigationDrawerController, _HomePageDrawer.keyPremium);
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




