import 'package:ikleeralles/network/models/abstract.dart';
import 'package:ikleeralles/network/keys.dart';

class ExerciseList extends ObjectBase {

  bool copied;
  DateTime date;
  String name;
  String original;
  String translated;
  int year;
  String level;

  ExerciseList (Map<String, dynamic> dictionary) : super(dictionary);

  @override
  void parse(Map<String, dynamic> dictionary) {
    super.parse(dictionary);
    copied = dictionary[ObjectKeys.copied];
    date = parseDate(dictionary[ObjectKeys.date]);
    name = dictionary[ObjectKeys.name];
    original = dictionary[ObjectKeys.original];
    translated = dictionary[ObjectKeys.translated];
    year = dictionary[ObjectKeys.year];
    level = dictionary[ObjectKeys.level];
  }

  @override
  Map<String, dynamic> toMap() {
    var superMap = super.toMap();
    var map = {
      ObjectKeys.name: name,
      ObjectKeys.date: toDateStr(date),
      ObjectKeys.copied: copied,
      ObjectKeys.original: original,
      ObjectKeys.translated: translated,
      ObjectKeys.year: year,
      ObjectKeys.level: level
    };
    map.addAll(superMap);
    return map;
  }

}