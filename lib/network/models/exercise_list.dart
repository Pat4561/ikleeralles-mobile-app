import 'dart:convert';
import 'package:ikleeralles/network/models/abstract.dart';
import 'package:ikleeralles/network/keys.dart';

enum ExerciseSetInputSide {
  term,
  definition
}

class ExerciseSet extends ParsableObject {

  List<String> original;
  List<String> translated;
  String translatedImage;
  List<String> color;

  ExerciseSet (Map<String, dynamic> dictionary) : super(dictionary);

  static ExerciseSet create() {
    return ExerciseSet({
      ObjectKeys.original: <String>[],
      ObjectKeys.translated: <String>[],
      ObjectKeys.translatedImage: null,
      ObjectKeys.color: <String>[]
    });
  }

  @override
  void parse(Map<String, dynamic> dictionary) {
    original = strList(dictionary[ObjectKeys.original]);
    translated = strList(dictionary[ObjectKeys.translated]);
    translatedImage = dictionary[ObjectKeys.translatedImage];
    //color = strList(dictionary[ObjectKeys.color]);
  }

  List<String> fieldsBySide (ExerciseSetInputSide side) {
    List<String> items = [];
    switch (side) {
      case ExerciseSetInputSide.term:
        items = this.original;
        break;
      case ExerciseSetInputSide.definition:
        items = this.translated;
        break;
    }
    return items;
  }

  void updateFieldsBySide(ExerciseSetInputSide side, List<String> items) {
    if (side == ExerciseSetInputSide.term) {
      this.original = items;
    } else if (side == ExerciseSetInputSide.definition) {
      this.translated = items;
    }
  }

  List<String> strList(List values) {
    return values.map((value) => value.toString()).toList();
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      ObjectKeys.original: original,
      ObjectKeys.translated: translated,
      ObjectKeys.translatedImage: translatedImage,
      ObjectKeys.color: color
    };
  }

}

class ExerciseDetails {

  List<ExerciseSet> sets;

  ExerciseDetails (String content) {
    List mapList = json.decode(content);
    sets = mapList.map((map) => ExerciseSet(map)).toList();
  }

}

class ExerciseList extends ObjectBase {

  bool copied;
  DateTime date;
  String name;
  String original;
  String content;
  String translated;
  int year;
  String level;

  ExerciseList (Map<String, dynamic> dictionary) : super(dictionary);

  ExerciseList.create({ this.name, this.original, this.translated, this.content, int id }) : super.create(id: id);

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
    var content = dictionary[ObjectKeys.content];
    if (content is String) {
      this.content = content;
    } else {
      this.content = json.encode(content);
    }
  }

  @override
  Map<String, dynamic> toMap() {
    var superMap = super.toMap();
    var map = {
      ObjectKeys.name: name,
      ObjectKeys.date: toDateStr(date),
      ObjectKeys.copied: copied,
      ObjectKeys.content: content,
      ObjectKeys.original: original,
      ObjectKeys.translated: translated,
      ObjectKeys.year: year,
      ObjectKeys.level: level
    };
    map.addAll(superMap);
    return map;
  }

}