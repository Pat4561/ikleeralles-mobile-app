import 'package:ikleeralles/network/keys.dart';
import 'package:ikleeralles/network/models/abstract.dart';

class GroupMember extends ObjectBase {

  String username;
  String role;
  int year;
  String level;



  GroupMember (Map<String, dynamic> dictionary) : super(dictionary);

  @override
  void parse(Map<String, dynamic> dictionary) {
    super.parse(dictionary);
  }

  @override
  Map<String, dynamic> toMap() {
    var map = {
      ObjectKeys.username: username,
      ObjectKeys.role: role,
      ObjectKeys.year: year,
      ObjectKeys.level: level
    };
    var superMap = super.toMap();
    map.addAll(superMap);
    return map;
  }

}

class Group extends ObjectBase {


  DateTime date;
  String name;
  List<GroupMember> members;

  Group (Map<String, dynamic> dictionary) : super(dictionary);

  @override
  void parse(Map<String, dynamic> dictionary) {
    super.parse(dictionary);
    date = parseDate(dictionary[ObjectKeys.date]);
    name = dictionary[ObjectKeys.name];

    List items = dictionary[ObjectKeys.members];
    if (items != null)
      members = items.map((v) => GroupMember(v)).toList();
  }

  @override
  Map<String, dynamic> toMap() {
    var superMap = super.toMap();
    var map = {
      ObjectKeys.date: toDateStr(date),
      ObjectKeys.name: name,
      ObjectKeys.members: members.map((v) => v.toMap()).toList()
    };
    map.addAll(superMap);
    return map;
  }

}
