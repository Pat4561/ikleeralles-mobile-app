import 'package:ikleeralles/network/models/abstract.dart';
import 'package:ikleeralles/network/keys.dart';

class UserResult extends ParsableObject {

  String username;
  bool hasPremium;

  UserResult (Map<String, dynamic> resultDictionary) : super(resultDictionary);

  @override
  void parse(Map<String, dynamic> dictionary) {
    username = dictionary[AuthKeys.username];
    hasPremium = dictionary[AuthKeys.hasPremium];
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      AuthKeys.username: username,
      AuthKeys.hasPremium: hasPremium
    };
  }
}
