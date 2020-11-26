import 'package:flutter/material.dart';
import 'package:ikleeralles/ui/themed/appbar.dart';

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