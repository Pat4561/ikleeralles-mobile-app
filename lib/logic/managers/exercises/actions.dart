import 'dart:convert';
import 'package:ikleeralles/network/auth/service.dart';
import 'package:ikleeralles/network/models/exercise_list.dart';
import 'package:ikleeralles/network/models/folder.dart';
import 'package:ikleeralles/ui/dialogs/premium_lock.dart';
import 'package:scoped_model/scoped_model.dart';

class ExercisesActionsManager extends Model {


  Future createFolder(String name) {
    return AuthService().securedApi.createFolder(name);
  }

  Future deleteFolder(Folder folder) {
    return AuthService().securedApi.deleteFolder(folder);
  }


  Future move(List<ExerciseList> exercises, { Folder folder }) {
    //TODO: Implement!!
  }

  Future<ExerciseList> merge(List<ExerciseList> exercises, { String name }) async {

    List<ExerciseSet> sets = [];
    exercises.forEach((exercise) {
      var details = ExerciseDetails(exercise.content);
      sets.addAll(details.sets);
    });

    List<Map<String, dynamic>> mapList = sets.map((set) => set.toMap()).toList();
    var newContent = json.encode(mapList);
    var newList = ExerciseList.create(
      name: name,
      content: newContent,
      original: exercises.first.original,
      translated: exercises.last.translated
    );
    var createdList = await AuthService().securedApi.createExerciseList(newList);
    if (createdList == null)
      throw Exception("Unable to create");
    return createdList;
  }

  Future deleteExercises(List<ExerciseList> exercises) {
    //TODO: Implement!!
  }

  Future restoreExerciseList(ExerciseList exerciseList) {
    return AuthService().securedApi.restoreExerciseList(exerciseList);
  }

}