import 'package:ikleeralles/logic/operations/abstract.dart';
import 'package:ikleeralles/network/auth/service.dart';
import 'package:ikleeralles/network/models/exercise_list.dart';

class ExercisesDownloadOperation extends Operation<List<ExerciseList>> {

  final int folderId;

  ExercisesDownloadOperation ({ this.folderId });

  @override
  Future<List<ExerciseList>> perform() {
    return AuthService().securedApi.getExerciseLists(folderId: folderId);
  }

}