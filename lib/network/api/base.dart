import 'dart:convert';
import 'package:ikleeralles/exceptions.dart';
import 'package:ikleeralles/logic/operations/search.dart';
import 'package:ikleeralles/network/api/routes.dart';
import 'package:ikleeralles/network/api/helper.dart';
import 'package:ikleeralles/network/auth/userinfo.dart';
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
    var result = await requestHelper.singleObjectRequest<LoginResult>(
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
    if (result == null)
      throw InvalidCredentialsException();
    return result;
  }

  Future<List<Folder>> getFolders() async {
    return requestHelper.multiObjectsRequest<Folder>(
      route: Routes.myFolders,
      toObject: (Map map) => Folder(map)
    );
  }

  Future<List<ExerciseList>> getTrash() async {
    return requestHelper.multiObjectsRequest<ExerciseList>(
        route: Routes.deletedExerciseLists,
        toObject: (Map map) => ExerciseList(map)
    );
  }

  Future<List<ExerciseList>> getExerciseLists() async {
    return requestHelper.multiObjectsRequest<ExerciseList>(
        route: Routes.myExerciseLists,
        toObject: (Map map) => ExerciseList(map)
    );
  }

  Future<List<ExerciseList>> getSearchResults(SearchQuery query) async {
    return requestHelper.multiObjectsRequest<ExerciseList>(
        route: Routes.searchExerciseLists,
        method: RequestMethod.post,
        body: query.toMap(),
        toObject: (Map map) => ExerciseList(map)
    );
  }

  Future<Folder> getFolder(int folderId) async {
    return requestHelper.singleObjectRequest<Folder>(
        route: Routes.folder(folderId),
        toObject: (Map map) => Folder(map)
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

  Future<ExerciseList> restoreExerciseList(ExerciseList exerciseList) async {
    return requestHelper.singleObjectRequest<ExerciseList>(
        route: Routes.restoreExerciseList,
        toObject: (Map map) => ExerciseList(map),
        method: RequestMethod.post,
        body: {
          ObjectKeys.id: exerciseList.id
        }
    );
  }

  Future<Folder> deleteFolder(Folder folder) async {
    return requestHelper.singleObjectRequest<Folder>(
        route: Routes.deleteFolder(folder.id),
        toObject: (Map map) => Folder(map),
        method: RequestMethod.post
    );
  }

  Future<Folder> createFolder(String name) async {
    return requestHelper.singleObjectRequest<Folder>(
        route: Routes.createFolder,
        toObject: (Map map) => Folder(map),
        method: RequestMethod.post,
        body: {
          ObjectKeys.name: name
        }
    );
  }

  Future<ExerciseList> createExerciseList(ExerciseList exerciseList) async {
    var body = {
      ObjectKeys.name: exerciseList.name,
      ObjectKeys.original: exerciseList.original,
      ObjectKeys.translated: exerciseList.translated,
      ObjectKeys.content : json.decode(exerciseList.content)
    };
    return requestHelper.singleObjectRequest<ExerciseList>(
        route: Routes.createExerciseList,
        toObject: (Map map) => ExerciseList(map),
        method: RequestMethod.post,
        body: body
    );
  }


}

class SecuredApi extends Api {

  final AccessToken accessToken;

  SecuredApi (this.accessToken);

  @override
  RequestHelper createRequestHelper() {
    return SecuredRequestHelper(this.accessToken);
  }

}