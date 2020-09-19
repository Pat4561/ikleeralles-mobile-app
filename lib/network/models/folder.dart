import 'package:ikleeralles/network/models/abstract.dart';
import 'package:ikleeralles/network/keys.dart';
import 'package:ikleeralles/network/models/exercise_list.dart';

class Folder extends ObjectBase {

  String name;
  DateTime date;
  List<ExerciseList> lists = [];

  Folder (Map<String, dynamic> dictionary) : super(dictionary);

  @override
  void parse(Map<String, dynamic> dictionary) {
    super.parse(dictionary);
    name = dictionary[ObjectKeys.name];
    date = parseDate(dictionary[ObjectKeys.date]);

    List items = dictionary[ObjectKeys.lists];
    if (items != null)
      lists = items.map((v) => ExerciseList(v)).toList();

  }

  @override
  Map<String, dynamic> toMap() {
    var superMap = super.toMap();
    var map = {
      ObjectKeys.name: name,
      ObjectKeys.date: toDateStr(date),
      ObjectKeys.lists: lists.map((v) => v.toMap()).toList()
    };
    map.addAll(superMap);
    return map;
  }

}
