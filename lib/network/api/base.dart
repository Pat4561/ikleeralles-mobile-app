import 'package:ikleeralles/network/api/routes.dart';
import 'package:ikleeralles/network/api/helper.dart';
import 'package:ikleeralles/network/keys.dart';
import 'package:ikleeralles/network/models/login_result.dart';
import 'package:ikleeralles/network/models/user_result.dart';
import 'package:ikleeralles/network/models/folder.dart';
import 'package:ikleeralles/network/models/exercise_list.dart';
import 'package:ikleeralles/network/parsing_operation.dart';

class Api {

  RequestHelper requestHelper;

  RequestHelper createRequestHelper() {
    return RequestHelper();
  }

  Api () {
    this.requestHelper = createRequestHelper();
  }

  Future<LoginResult> authorize({ String username, String password }) async {
    return requestHelper.singleObjectRequest<LoginResult>(
      route: Routes.auth,
      body: {
        AuthKeys.username: username,
        AuthKeys.password: password
      },
      method: RequestMethod.post,
      toObject: (Map map) {
        var loginResult = LoginResult(map);
        if (loginResult.accessToken != null)
          return loginResult;
        return null;
      }
    );
  }

  Future<List<Folder>> getFolders() async {
    return requestHelper.multiObjectsRequest<Folder>(
      route: Routes.myFolders,
      toObject: (Map map) => Folder(map)
    );
  }

  Future<List<ExerciseList>> getExercisesLists() async {
    return requestHelper.multiObjectsRequest<ExerciseList>(
        route: Routes.myExercisesLists,
        toObject: (Map map) => ExerciseList(map)
    );
  }

  Future<UserResult> getUser() async {
    return requestHelper.singleObjectRequest<UserResult>(
      route: Routes.userInfo,
      toObject: (Map map) => UserResult(map)
    );
  }

  Future<List<String>> getLevels() async {
    var response = await requestHelper.executeRequest(
      route: Routes.levels
    );
    return ParsingOperation<String>(response).asPrimitiveList();
  }


}

class SecuredApi extends Api {

  final LoginResult loginResult;

  SecuredApi (this.loginResult);

  @override
  RequestHelper createRequestHelper() {
    return SecuredRequestHelper(this.loginResult);
  }

}