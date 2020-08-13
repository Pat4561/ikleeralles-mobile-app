import 'package:ikleeralles/network/models/abstract.dart';
import 'package:ikleeralles/network/keys.dart';

class Folder extends ObjectBase {

  String name;
  DateTime date;

  Folder (Map<String, dynamic> dictionary) : super(dictionary);

  @override
  void parse(Map<String, dynamic> dictionary) {
    super.parse(dictionary);
    name = dictionary[ObjectKeys.name];
    date = parseDate(dictionary[ObjectKeys.date]);
  }

  @override
  Map<String, dynamic> toMap() {
    var superMap = super.toMap();
    var map = {
      ObjectKeys.name: name,
      ObjectKeys.date: toDateStr(date)
    };
    map.addAll(superMap);
    return map;
  }

}