import 'package:ikleeralles/logic/operations/abstract.dart';
import 'package:ikleeralles/network/auth/service.dart';
import 'package:ikleeralles/network/keys.dart';
import 'package:ikleeralles/network/models/exercise_list.dart';

class SearchQuery {

  String _search;
  String _level;
  String _year;

  void update({ String search, String level, String year }) {
    _search = search;
    _level = level;
    _year = year;
  }

  Map<String, dynamic> toMap() {
    return {
      ObjectKeys.name: _search ?? "",
      ObjectKeys.level: _level,
      ObjectKeys.year: _year
    };
  }
}

class SearchOperation extends Operation<List<ExerciseList>> {

  final SearchQuery query;

  SearchOperation (this.query);

  @override
  Future<List<ExerciseList>> perform() {
    return AuthService().securedApi.getSearchResults(
      this.query
    );
  }



}