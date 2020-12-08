import 'dart:async';

import 'package:ikleeralles/logic/operations/abstract.dart';
import 'package:ikleeralles/network/auth/service.dart';
import 'package:ikleeralles/network/models/exercise_list.dart';

class ExercisesDownloadOperation extends Operation<List<ExerciseList>> {

  final int folderId;
  final int groupId;

  ExercisesDownloadOperation ({ this.folderId, this.groupId });

  @override
  Future<List<ExerciseList>> perform() {
    Completer<List<ExerciseList>> completer = Completer<List<ExerciseList>>();
    if (folderId != null) {
      AuthService().securedApi.getFolder(folderId).then((value) {
        completer.complete(value.lists);
      }).catchError((e) {
        completer.completeError(e);
      });
    } else if (groupId != null) {
      AuthService().securedApi.getGroup(groupId).then((values) {
        completer.complete(values.lists);
      }).catchError((e) {
        completer.completeError(e);
      });
    } else {
      AuthService().securedApi.getExerciseLists().then((value) {
        completer.complete(value);
      }).catchError((e) {
        completer.completeError(e);
      });
    }


    return completer.future;
  }

}

