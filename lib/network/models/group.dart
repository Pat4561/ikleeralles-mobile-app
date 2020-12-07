import 'package:ikleeralles/network/models/abstract.dart';

class Group extends ObjectBase {


  Group (Map<String, dynamic> dictionary) : super(dictionary);

  @override
  void parse(Map<String, dynamic> dictionary) {
    super.parse(dictionary);
  }

  @override
  Map<String, dynamic> toMap() {
    var superMap = super.toMap();
    var map = {};
    map.addAll(superMap);
    return map;
  }

}
