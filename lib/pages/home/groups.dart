import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:ikleeralles/constants.dart';
import 'package:ikleeralles/ui/navigation_drawer.dart';

class GroupsSubPage extends NavigationDrawerContentChild {

  GroupsSubPage (NavigationDrawerController controller, String key) : super(controller, key: key);

  @override
  Widget body(BuildContext context) {
    return Container();
  }

  @override
  String title(BuildContext context) {
    return FlutterI18n.translate(context, TranslationKeys.myGroups);
  }


}

