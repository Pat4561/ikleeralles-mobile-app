import 'package:flutter_test/flutter_test.dart';
import 'package:ikleeralles/network/api/base.dart';

void main() {

  test("Get levels", () async {
    var result = await Api().getLevels();
    print(result);
  });

}