import 'package:flutter_test/flutter_test.dart';
import 'package:ikleeralles/network/api/base.dart';

void main() {

  test("Get lists", () async {
    var loginResult = await Api().authorize(
        username: "deurmanhimself",
        password: "Swaps_07"
    );
    var lists = await SecuredApi(loginResult).getExercisesLists();
    var folders = await SecuredApi(loginResult).getFolders();
    
  });

}