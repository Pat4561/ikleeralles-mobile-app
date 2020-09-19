import 'package:flutter_test/flutter_test.dart';
import 'package:ikleeralles/network/api/base.dart';
import 'package:ikleeralles/network/auth/userinfo.dart';

void main() {

  test("Get lists", () async {
    var loginResult = await Api().authorize(
        username: "deurmanhimself",
        password: "Swaps_07"
    );
    var lists = await SecuredApi(AccessToken(loginResult.accessToken)).getExerciseLists();
    var folders = await SecuredApi(AccessToken(loginResult.accessToken)).getFolders();
    
  });

}