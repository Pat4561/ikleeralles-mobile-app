import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:ikleeralles/constants.dart';
import 'package:ikleeralles/logic/managers/operation.dart';
import 'package:ikleeralles/logic/managers/platform.dart';
import 'package:ikleeralles/logic/operations/search.dart';
import 'package:ikleeralles/network/models/exercise_list.dart';
import 'package:ikleeralles/pages/exercise_list.dart';
import 'package:ikleeralles/ui/navigation_drawer.dart';
import 'package:ikleeralles/ui/tables/search.dart';
import 'package:ikleeralles/ui/themed/appbar.dart';

class PublicSearchSubPage extends NavigationDrawerContentChild {

  final GlobalKey<SearchTableState> _searchTableKey = GlobalKey<SearchTableState>();

  final SearchQuery _searchQuery = SearchQuery();

  final PlatformDataProvider platformDataProvider;

  OperationManager _operationManager;


  PublicSearchSubPage (NavigationDrawerController controller, String key, { @required this.platformDataProvider }) : super(controller, key: key) {
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