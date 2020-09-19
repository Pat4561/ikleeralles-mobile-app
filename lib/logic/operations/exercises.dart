import 'dart:async';

import 'package:ikleeralles/logic/operations/abstract.dart';
import 'package:ikleeralles/network/auth/service.dart';
import 'package:ikleeralles/network/models/exercise_list.dart';

class ExercisesDownloadOperation extends Operation<List<ExerciseList>> {

  final int folderId;

  ExercisesDownloadOperation ({ this.folderId });

  @override
  Future<List<ExerciseList>> perform() {
    Completer<List<ExerciseList>> completer = Completer<List<ExerciseList>>();
    if (folderId == null) {
      AuthService().securedApi.getExerciseLists().then((value) {
        completer.complete(value);
      }).catchError((e) {
        completer.completeError(e);
      });
    } else {
      AuthService().securedApi.getFolder(folderId).then((value) {
        completer.complete(value.lists);
      }).catchError((e) {
        completer.completeError(e);
      });
    }

    return completer.future;
  }

}