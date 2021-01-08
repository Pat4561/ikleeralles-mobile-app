import 'package:ikleeralles/network/models/abstract.dart';
import 'package:ikleeralles/network/keys.dart';

class UserResult extends ParsableObject {

  String username;
  bool hasPremium;

  int folderCount;
  int trashCount;

  int year;
  String level;

  UserResult (Map<String, dynamic> resultDictionary) : super(resultDictionary);

  @override
  void parse(Map<String, dynamic> dictionary) {
    username = dictionary[AuthKeys.username];
    hasPremium = dictionary[AuthKeys.hasPremium];
    folderCount = dictionary[UserInfoKeys.folderCount];
    trashCount = dictionary[UserInfoKeys.trashCount];
    year = dictionary[UserInfoKeys.year];
    level = dictionary[UserInfoKeys.level];
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      AuthKeys.username: username,
      AuthKeys.hasPremium: hasPremium,
      UserInfoKeys.folderCount: folderCount,
      UserInfoKeys.trashCount: trashCount,
      UserInfoKeys.year: year,
      UserInfoKeys.level: level
    };
  }
}
