import 'package:ikleeralles/network/models/abstract.dart';
import 'package:ikleeralles/network/keys.dart';

class LoginResult extends ParsableObject {

  String accessToken;

  LoginResult (Map<String, dynamic> resultDictionary) : super(resultDictionary);

  @override
  void parse(Map<String, dynamic> dictionary) {
    accessToken = dictionary[AuthKeys.accessToken];
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      AuthKeys.accessToken: accessToken
    };
  }

}
