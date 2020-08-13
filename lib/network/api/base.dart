import 'package:ikleeralles/network/api/routes.dart';
import 'package:ikleeralles/network/api/helper.dart';
import 'package:ikleeralles/network/keys.dart';
import 'package:ikleeralles/network/models/login_result.dart';
import 'package:ikleeralles/network/models/user_result.dart';
import 'package:ikleeralles/network/models/folder.dart';
import 'package:ikleeralles/network/models/exercise_list.dart';

class Api {

  Future<LoginResult> authorize({ String username, String password }) async {
    return RequestHelper.singleObjectRequest<LoginResult>(
      route: Routes.auth,
      body: {
        AuthKeys.username: username,
        AuthKeys.password: password
      },
      method: RequestMethod.post,
      toObject: (Map map) => LoginResult(map)
    );
  }

  Future<List<Folder>> getFolders() async {
    return RequestHelper.multiObjectsRequest<Folder>(
      route: Routes.myFolders,
      toObject: (Map map) => Folder(map)
    );
  }

  Future<List<ExerciseList>> getExercisesLists() async {
    return RequestHelper.multiObjectsRequest<ExerciseList>(
        route: Routes.myExercisesLists,
        toObject: (Map map) => ExerciseList(map)
    );
  }

  Future<UserResult> getUser() async {
    return RequestHelper.singleObjectRequest<UserResult>(
      route: Routes.userInfo,
      toObject: (Map map) => UserResult(map)
    );
  }


}