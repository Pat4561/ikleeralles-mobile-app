import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:ikleeralles/logic/managers/operation.dart';
import 'package:ikleeralles/logic/managers/platform.dart';
import 'package:ikleeralles/logic/operations/search.dart';
import 'package:ikleeralles/network/models/exercise_list.dart';
import 'package:ikleeralles/ui/tables/search.dart';
import 'package:ikleeralles/ui/themed/appbar.dart';


class SearchPage extends StatefulWidget {

  final PlatformDataProvider platformDataProvider;

  SearchPage ({ @required this.platformDataProvider });

  @override
  State<StatefulWidget> createState() {
    return _SearchPageState();
  }

}


class _SearchPageState extends State<SearchPage> {

  OperationManager _operationManager;

  GlobalKey<SearchTableState> searchTableKey = GlobalKey<SearchTableState>();

  SearchQuery _searchQuery = SearchQuery();

  @override
  void initState() {
    this.widget.platformDataProvider.load();
    _searchQuery.update(
      level: this.widget.platformDataProvider.levels.first,
      year: this.widget.platformDataProvider.years.first
    );
    _operationManager = OperationManager(
        operationBuilder: () {
          return SearchOperation(_searchQuery);
        }
    );
    super.initState();
  }

  void _onExerciseListPressed(ExerciseList exerciseList) {

  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ThemedSearchAppBar(
        platformDataProvider: this.widget.platformDataProvider,
        onPerformSearch: (String search, String year, String level) {
          _searchQuery.update(
            search: search,
            year: year,
            level: level
          );
          searchTableKey.currentState.showRefresh();
        }
      ),
      body: SearchTable(
        key: searchTableKey,
        onExerciseListPressed: _onExerciseListPressed,
        operationManager: _operationManager,
      ),
    );
  }

}