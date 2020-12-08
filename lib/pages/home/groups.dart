import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:ikleeralles/constants.dart';
import 'package:ikleeralles/logic/managers/operation.dart';
import 'package:ikleeralles/logic/operations/groups.dart';
import 'package:ikleeralles/network/models/group.dart';
import 'package:ikleeralles/ui/background_builder.dart';
import 'package:ikleeralles/ui/navigation_drawer.dart';
import 'package:ikleeralles/ui/tables/operation_based.dart';

class MyGroupsTable extends OperationBasedTable {

  MyGroupsTable(OperationManager operationManager) : super(operationManager);

  @override
  State<StatefulWidget> createState() {
    return MyGroupsTableState();
  }

}

class GroupCell extends StatelessWidget {

  final Group group;

  GroupCell (this.group);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: BrandColors.borderColor,
            width: 1
          )
        )
      ),
      child: Material(
        child: InkWell(
          onTap: () {

          },
          child: Container(
            padding: EdgeInsets.all(20),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        this.group.name,
                        style: TextStyle(
                          fontSize: 18,
                          fontFamily: Fonts.ubuntu,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(
                              Icons.person,
                          ),
                          SizedBox(width: 5),
                          Text(
                            "${this.group.members.length} leden",
                            style: TextStyle(
                                fontSize: 14,
                                fontFamily: Fonts.ubuntu
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                ),
                Container(
                  child: Icon(Icons.chevron_right),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

}

class MyGroupsTableState extends OperationBasedTableState<MyGroupsTable> {

  @override
  void initState() {
    backgroundColor = BrandColors.lightGreyBackgroundColor.withOpacity(0.6);
    super.initState();
  }


  @override
  Widget listBuilder(BuildContext context, result) {
    List<Group> groups = result;
    return ListView.builder(
      itemCount: groups.length,
      itemBuilder: (BuildContext context, int position) {
        return GroupCell(
          groups[position]
        );
      },
    );
  }

  @override
  Widget noResultsBackgroundBuilder(BuildContext context) {
    return BackgroundBuilder.defaults.noResults(context, alignment: Alignment.topCenter);
  }

  @override
  Widget errorBackgroundBuilder(BuildContext context, error) {
    return BackgroundBuilder.defaults.error(context, alignment: Alignment.topCenter);
  }

  @override
  Widget loadingBackgroundBuilder(BuildContext context) {
    return BackgroundBuilder.defaults.loadingSimple(context);
  }
}

class GroupsSubPage extends NavigationDrawerContentChild {

  OperationManager _myGroupsOperationManager;

  GroupsSubPage (NavigationDrawerController controller, String key) : super(controller, key: key) {
    _myGroupsOperationManager = OperationManager(
      operationBuilder: () {
        return GroupsOperation();
      }
    );
  }

  @override
  Widget body(BuildContext context) {
    return MyGroupsTable(_myGroupsOperationManager);
  }

  @override
  String title(BuildContext context) {
    return FlutterI18n.translate(context, TranslationKeys.myGroups);
  }


}

