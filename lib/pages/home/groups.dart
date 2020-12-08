import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:ikleeralles/constants.dart';
import 'package:ikleeralles/logic/managers/operation.dart';
import 'package:ikleeralles/logic/managers/platform.dart';
import 'package:ikleeralles/logic/operations/groups.dart';
import 'package:ikleeralles/pages/group.dart';
import 'package:ikleeralles/ui/navigation_drawer.dart';
import 'package:ikleeralles/ui/tables/my_groups.dart';


class GroupsSubPage extends NavigationDrawerContentChild {

  final PlatformDataProvider platformDataProvider;

  OperationManager _myGroupsOperationManager;

  GroupsSubPage (NavigationDrawerController controller, String key, { this.platformDataProvider }) : super(controller, key: key) {
    _myGroupsOperationManager = OperationManager(
      operationBuilder: () {
        return GroupsOperation();
      }
    );
  }

  @override
  Widget body(BuildContext context) {
    return MyGroupsTable(_myGroupsOperationManager, onGroupPressed: (group) {
      Navigator.push(context, MaterialPageRoute(
        builder: (context) {
          return GroupPage(
            group,
            platformDataProvider: platformDataProvider,
          );
        }
      ));
    });
  }

  @override
  String title(BuildContext context) {
    return FlutterI18n.translate(context, TranslationKeys.myGroups);
  }


}

