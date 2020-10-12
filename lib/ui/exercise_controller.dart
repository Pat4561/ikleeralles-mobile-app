import 'package:flutter/material.dart';
import 'package:ikleeralles/logic/managers/platform.dart';
import 'package:ikleeralles/network/models/exercise_list.dart';
import 'package:scoped_model/scoped_model.dart';



class ExerciseListController {

  final SetInputTypeProvider termsProvider = SetInputTypeProvider();
  final SetInputTypeProvider definitionsProvider = SetInputTypeProvider();

  TextEditingController _titleTextController;
  TextEditingController get titleTextController => _titleTextController;

  ValueNotifier<String> _termValueNotifier;
  ValueNotifier<String> get termValueNotifier => _termValueNotifier;

  ValueNotifier<String> _definitionValueNotifier;
  ValueNotifier<String> get definitionValueNotifier => _definitionValueNotifier;

  ExerciseSetsController _setsController;
  ExerciseSetsController get setsController => _setsController;

  ExerciseListController.newList() {
    _titleTextController = TextEditingController();
    _termValueNotifier = ValueNotifier<String>(termsProvider.defaultValue());
    _definitionValueNotifier = ValueNotifier<String>(definitionsProvider.defaultValue());
    _setsController = ExerciseSetsController(termValueNotifier: _termValueNotifier, definitionValueNotifier: _definitionValueNotifier);
  }

  ExerciseListController.existingList(ExerciseList list) {
    _titleTextController = TextEditingController(text: list.name);
    _termValueNotifier = ValueNotifier<String>(list.original ?? termsProvider.defaultValue());
    _definitionValueNotifier = ValueNotifier<String>(list.translated ?? definitionsProvider.defaultValue());
    _setsController = ExerciseSetsController(sets: ExerciseDetails(list.content).sets, termValueNotifier: _termValueNotifier, definitionValueNotifier: _definitionValueNotifier);
  }

}


class ExerciseSetsController extends Model {

  final ValueNotifier<String> termValueNotifier;
  final ValueNotifier<String> definitionValueNotifier;

  static const int minSetLength = 5;
  static const int batchSize = 3;

  List<ExerciseSet> _sets;
  List<ExerciseSet> get sets => _sets;

  ExerciseSetsController ({ List<ExerciseSet> sets, @required this.termValueNotifier, @required this.definitionValueNotifier }) {
    _sets = sets ?? [];
    if (_sets.length < minSetLength) {
      _populateNew(till: minSetLength);
    }

    termValueNotifier.addListener(_fieldTypeChange);
    definitionValueNotifier.addListener(_fieldTypeChange);
  }

  void _fieldTypeChange() {
    notifyListeners();
  }

  void _populateNew({ @required int till }) {
    int start = _sets.length;
    int itemsToCreate = till - start;
    if (itemsToCreate > 0) {
      for (int i = 0; i < itemsToCreate; i++) {
        _sets.add(ExerciseSet.create());
      }
    }
  }

  void addMore() {
    _populateNew(till: _sets.length + batchSize);
    notifyListeners();
  }

  void changeField(ExerciseSet set, String text, { @required int fieldIndex, @required ExerciseSetInputSide side } ) {
    List<String> items = set.fieldsBySide(side);
    items[fieldIndex] = text;
  }

  void removeField(ExerciseSet set, { @required int fieldIndex, @required ExerciseSetInputSide side }) {
    List<String> items = set.fieldsBySide(side);
    items.removeAt(fieldIndex);
    set.updateFieldsBySide(side, items);
    notifyListeners();
  }

  void addFieldEntry(ExerciseSet set, { @required ExerciseSetInputSide side }) {
    List<String> items = set.fieldsBySide(side);
    items.add("");
    set.updateFieldsBySide(side, items);
    notifyListeners();
  }

  void remove(ExerciseSet set) {
    _sets.remove(set);
    notifyListeners();
  }

  void removeAt(int index){
    _sets.removeAt(index);
    notifyListeners();
  }




}