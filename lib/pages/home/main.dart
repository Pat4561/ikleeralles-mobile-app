import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:ikleeralles/constants.dart';
import 'package:ikleeralles/logic/managers/extensions.dart';
import 'package:ikleeralles/logic/managers/operation.dart';
import 'package:ikleeralles/logic/managers/platform.dart';
import 'package:ikleeralles/logic/operations/exercises.dart';
import 'package:ikleeralles/logic/operations/folders.dart';
import 'package:ikleeralles/logic/operations/search.dart';
import 'package:ikleeralles/logic/operations/trash.dart';
import 'package:ikleeralles/network/auth/service.dart';
import 'package:ikleeralles/network/models/exercise_list.dart';
import 'package:ikleeralles/pages/exercise_list.dart';
import 'package:ikleeralles/pages/exercises_overview.dart';
import 'package:ikleeralles/pages/home/groups.dart';
import 'package:ikleeralles/pages/home/my_exercises.dart';
import 'package:ikleeralles/pages/home/premium.dart';
import 'package:ikleeralles/pages/home/public.dart';
import 'package:ikleeralles/pages/login.dart';
import 'package:ikleeralles/ui/logout_handler.dart';
import 'package:ikleeralles/ui/navigation_drawer.dart';
import 'package:ikleeralles/ui/tables/exercises_overview.dart';
import 'package:ikleeralles/ui/tables/search.dart';
import 'package:ikleeralles/ui/themed/appbar.dart';
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


class _HomePageState extends State<HomePage> {

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  final PlatformDataProvider platformDataProvider = PlatformDataProvider();

  NavigationDrawerController _navigationDrawerController;

  LogoutHandler _logoutHandler;

  NavigationDrawerContentChild _getContentChild(String key) {
    switch (key) {
      case _HomePageDrawer.keyMyLists:
        return MyExercisesSubPage(_navigationDrawerController, _HomePageDrawer.keyMyLists,
            platformDataProvider: platformDataProvider);
      case _HomePageDrawer.keyGroups:
        return GroupsSubPage(_navigationDrawerController, _HomePageDrawer.keyGroups, platformDataProvider: platformDataProvider);
      case _HomePageDrawer.keyPublicLists:
        return PublicSearchSubPage(_navigationDrawerController, _HomePageDrawer.keyPublicLists,
            platformDataProvider: platformDataProvider);
      case _HomePageDrawer.keyPremium:
        return PremiumInfoSubPage(
            _navigationDrawerController, _HomePageDrawer.keyPremium);
    }
    return null;
  }



  @override
  void initState() {
    platformDataProvider.load();
    _navigationDrawerController = NavigationDrawerController();
    _navigationDrawerController.activeChild = _getContentChild(_HomePageDrawer.keyMyLists);
    _logoutHandler = LogoutHandler(context);
    _logoutHandler.listen();



    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _logoutHandler.unListen();
  }

  void _onNavigationOptionPressed(String key) {
    if (key == _HomePageDrawer.keyLogout) {
      AuthService().logout();
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




