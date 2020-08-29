import 'package:flutter_test/flutter_test.dart';
import 'package:ikleeralles/network/api/base.dart';
import 'package:ikleeralles/network/auth/userinfo.dart';

void main() {

  test("Login with incorrect data", () async {
    var result = await Api().authorize(
      username: "deurmanhimself",
      password: "Swaps_007"
    );
    expect(result, null);
  });

  test("Login with correct data", () async {
    var result = await Api().authorize(
        username: "deurmanhimself",
        password: "Swaps_07"
    );
    print(result.accessToken);
  });

  test("Login with correct data and parse user info", () async {

    var result = await Api().authorize(
        username: "deurmanhimself",
        password: "Swaps_07"
    );

    var userResult = await SecuredApi(AccessToken(result.accessToken)).getUser();
    print(userResult.toMap());
  });

}