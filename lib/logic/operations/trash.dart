import 'package:ikleeralles/logic/operations/abstract.dart';
import 'package:ikleeralles/network/auth/service.dart';
import 'package:ikleeralles/network/models/exercise_list.dart';

class TrashDownloadOperation extends Operation<List<ExerciseList>> {

  @override
  Future<List<ExerciseList>> perform() {
    return AuthService().securedApi.getTrash();
  }

}