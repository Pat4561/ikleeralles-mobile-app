import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:ikleeralles/constants.dart';
import 'package:ikleeralles/logic/managers/platform.dart';
import 'package:ikleeralles/network/auth/service.dart';
import 'package:ikleeralles/network/models/exercise_list.dart';
import 'package:ikleeralles/pages/exercise_list.dart';
import 'package:ikleeralles/ui/snackbar.dart';
import 'package:ikleeralles/ui/themed/button.dart';
import 'package:scoped_model/scoped_model.dart';



class ExerciseListController {

  SetInputTypeProvider _termsProvider;
  SetInputTypeProvider get termsProvider => _termsProvider;

  SetInputTypeProvider _definitionsProvider;
  SetInputTypeProvider get definitionsProvider => _definitionsProvider;

  PlatformDataProvider _platformDataProvider;
  PlatformDataProvider get platformDataProvider => _platformDataProvider;

  TextEditingController _titleTextController;
  TextEditingController get titleTextController => _titleTextController;

  ValueNotifier<String> _termValueNotifier;
  ValueNotifier<String> get termValueNotifier => _termValueNotifier;

  ValueNotifier<String> _definitionValueNotifier;
  ValueNotifier<String> get definitionValueNotifier => _definitionValueNotifier;

  ExerciseSetsController _setsController;
  ExerciseSetsController get setsController => _setsController;

  ExerciseList _list;

  int get exerciseListId => _list != null ? _list.id : null;

  bool _readOnly = false;

  bool get readOnly => _readOnly;

  set readOnly (bool value) {
    _readOnly = value;
    _setsController.readOnly = value;
  }

  ExerciseSetsController _createSetsController({ ExerciseDetails details }) => ExerciseSetsController(
      details: details, termValueNotifier: _termValueNotifier, definitionValueNotifier: _definitionValueNotifier, readOnly: readOnly, platformDataProvider: _platformDataProvider
  );

  ExerciseListController.newList({@required PlatformDataProvider platformDataProvider }) {
    _platformDataProvider = platformDataProvider;
    _termsProvider = SetInputTypeProvider(_platformDataProvider);
    _definitionsProvider = SetInputTypeProvider(_platformDataProvider);
    _titleTextController = TextEditingController();
    _termValueNotifier = ValueNotifier<String>(_termsProvider.defaultValue());
    _definitionValueNotifier = ValueNotifier<String>(_definitionsProvider.defaultValue());
    _setsController = _createSetsController();
  }

  ExerciseListController.existingList(ExerciseList list, { readOnly = false, @required PlatformDataProvider platformDataProvider }) {
    _platformDataProvider = platformDataProvider;
    _termsProvider = SetInputTypeProvider(_platformDataProvider);
    _definitionsProvider = SetInputTypeProvider(_platformDataProvider);
    _readOnly = readOnly;
    _list = list;
    _titleTextController = TextEditingController(text: list.name);
    _termValueNotifier = ValueNotifier<String>(list.original ?? _termsProvider.defaultValue());
    _definitionValueNotifier = ValueNotifier<String>(list.translated ?? _definitionsProvider.defaultValue());
    _setsController = _createSetsController(details: ExerciseDetails(list.content));
  }


  ExerciseList currentList(BuildContext context) {
    var sets = _setsController.sets;
    List<Map<String, dynamic>> mapList = sets.map((set) => set.toMap()).toList();
    var newContent = json.encode(mapList);
    return ExerciseList.create(
        name: _titleTextController.text,
        original: _termValueNotifier.value,
        translated: _definitionValueNotifier.value,
        content: newContent,
        id: exerciseListId
    );
  }

  ExerciseList copyOfCurrentList(BuildContext context) {
    var sets = _setsController.sets;
    List<Map<String, dynamic>> mapList = sets.map((set) => set.toMap()).toList();
    var newContent = json.encode(mapList);
    return ExerciseList.create(
        name: FlutterI18n.translate(context, TranslationKeys.copyOfTitle, { "title": _titleTextController.text }),
        original: _termValueNotifier.value,
        translated: _definitionValueNotifier.value,
        content: newContent
    );
  }

  void handleChanges(ExerciseList updatedExerciseList) {
    _titleTextController.text = updatedExerciseList.name;
    _termValueNotifier.value = updatedExerciseList.original ?? _termValueNotifier.value;
    _definitionValueNotifier.value = updatedExerciseList.translated ?? _definitionValueNotifier.value;
    _setsController.handleChanges(ExerciseDetails(updatedExerciseList.content));
  }

}

class TranslationController {

  Future<String> translate(String value, { @required String inputLanguage, @required String outputLanguage }) {
    return AuthService().securedApi.getTranslation(value, inputLanguage: inputLanguage, outputLanguage: outputLanguage);
  }

}

class ExerciseSetsController extends Model {

  final TranslationController translationController = TranslationController();

  final ValueNotifier<String> termValueNotifier;
  final ValueNotifier<String> definitionValueNotifier;

  final PlatformDataProvider platformDataProvider;

  static const int minSetLength = 5;
  static const int batchSize = 3;

  bool readOnly;

  bool _autoTranslationEnabled = true;

  bool get autoTranslationEnabled => _autoTranslationEnabled;

  set autoTranslationEnabled (bool value) {
    _autoTranslationEnabled = value;
    notifyListeners();
  }

  bool _isEdited = false;

  bool get isEdited => _isEdited;

  List<ExerciseSet> _sets;
  List<ExerciseSet> get sets => _sets;

  void handleChanges (ExerciseDetails details) {
    if (details.sets != null && details.sets.length > minSetLength) {
      _sets = details.sets;
      notifyListeners();
    }
    _isEdited = false;
  }

  ExerciseSetsController ({ ExerciseDetails details, @required this.termValueNotifier, @required this.definitionValueNotifier, @required this.platformDataProvider, this.readOnly = false }) {
    if (details != null) {
      _sets = details.sets;
    }
    _sets = _sets ?? [];
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
    _isEdited = true;
  }

  void removeField(ExerciseSet set, { @required int fieldIndex, @required ExerciseSetInputSide side }) {
    List<String> items = set.fieldsBySide(side);
    items.removeAt(fieldIndex);
    set.updateFieldsBySide(side, items);
    _isEdited = true;
    notifyListeners();
  }

  void addFieldEntry(ExerciseSet set, { @required ExerciseSetInputSide side }) {
    List<String> items = set.fieldsBySide(side);
    items.add("");
    set.updateFieldsBySide(side, items);
    _isEdited = true;
    notifyListeners();
  }

  void autoTranslate(ExerciseSet set) async {
    if (!_autoTranslationEnabled) {
      return;
    }

    var originalText = set.original.first;
    var translation = set.translated;
    var hasTranslation = (translation != null && translation.length > 0 && translation.first != null && translation.first.isNotEmpty);
    if (!hasTranslation) {
      set.translated = set.translated ?? [""];
      if (set.translated.length == 0) {
        set.translated = [""];
      }
      set.translated[0] = await translationController.translate(originalText, inputLanguage: termValueNotifier.value, outputLanguage: definitionValueNotifier.value);
      _isEdited = true;
      notifyListeners();
    }
  }

  void remove(ExerciseSet set) {
    _sets.remove(set);
    _isEdited = true;
    notifyListeners();
  }

  void removeAt(int index){
    _sets.removeAt(index);
    _isEdited = true;
    notifyListeners();
  }




}

class _SaveChangesDialog extends StatelessWidget {

  final Function(bool) onResult;

  _SaveChangesDialog ({ this.onResult });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        FlutterI18n.translate(context, TranslationKeys.unSavedChanges),
        style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            fontFamily: Fonts.ubuntu
        ),
      ),
      content: Text(
        FlutterI18n.translate(context, TranslationKeys.unSavedChangesDescription),
        style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.normal,
            fontFamily: Fonts.ubuntu
        ),
      ),
      actions: <Widget>[
        ThemedButton(
          FlutterI18n.translate(context, TranslationKeys.save),
          onPressed: () {
            onResult(true);
          },
          buttonColor: BrandColors.primaryButtonColor,
        ),
        ThemedButton(
          FlutterI18n.translate(context, TranslationKeys.ignoreChanges),
          onPressed: () {
            onResult(false);
          },
          buttonColor: Colors.red,
        )
      ],
    );
  }

}

class ExerciseEditorActionsHandler {

  final LoadingMessageHandler loadingMessageHandler = LoadingMessageHandler();

  final ExerciseListController controller;

  ExerciseEditorActionsHandler (this.controller);

  void saveList(BuildContext context) {
    loadingMessageHandler.show(context);
    var exerciseList = controller.currentList(context);
    Future<ExerciseList> updateOrCreateFuture;
    if (exerciseList.id != null) {
      updateOrCreateFuture = AuthService().securedApi.updateExerciseList(exerciseList);
    } else {
      updateOrCreateFuture = AuthService().securedApi.createExerciseList(exerciseList);
    }

    updateOrCreateFuture.then((v) {

      loadingMessageHandler.clear(
        callback: () {
          showToast(
              FlutterI18n.translate(context, TranslationKeys.successListSaved),
              backgroundColor: BrandColors.secondaryButtonColor
          );
        }
      );

    }).catchError((e) {

      loadingMessageHandler.clear(
          callback: () {
            showToast(
              FlutterI18n.translate(context, TranslationKeys.failedListSaved),
            );
          }
      );

    });
  }

  void copyList(BuildContext context) {
    var exerciseList = controller.copyOfCurrentList(context);
    Future<ExerciseList> copyListFuture = AuthService().securedApi.createExerciseList(exerciseList);
    loadingMessageHandler.show(context);
    copyListFuture.then((exerciseList) {
      Navigator.push(context, MaterialPageRoute(
          builder: (BuildContext context) {
            return ExerciseEditorPage(
              exerciseList: exerciseList,
            );
          }
      ));
    }).catchError((e) {
      loadingMessageHandler.clear(
          callback: () {
            showToast(
              FlutterI18n.translate(context, TranslationKeys.failedListCopy),
            );
          }
      );
    });
  }

  Future<bool> _userWantsToSaveChange(BuildContext context) {
    Completer<bool> completer = Completer();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return _SaveChangesDialog(
          onResult: (shouldSave) {
            Navigator.pop(context);
            completer.complete(shouldSave);
          }
        );
      }
    );

    return completer.future;
  }

  Future performRefresh(BuildContext context) async {
    Completer<ExerciseList> completer = Completer<ExerciseList>();
    if (controller.exerciseListId == null) {
      AuthService().securedApi.createExerciseList(controller.currentList(context)).then((exercise) {
        completer.complete(exercise);
      }).catchError((e) {
        completer.completeError(e);
      });
    } else {
      if (controller.setsController.isEdited) {
        bool shouldSaveChanges = await _userWantsToSaveChange(context);
        if (shouldSaveChanges) {
          AuthService().securedApi.updateExerciseList(controller.currentList(context)).then((exercise) {
            completer.complete(exercise);
          }).catchError((e) {
            completer.completeError(e);
          });
        } else {
          AuthService().securedApi.getExerciseList(listId: controller.exerciseListId).then((exercise) {
            completer.complete(exercise);
          }).catchError((e) {
            completer.completeError(e);
          });
        }
      } else {
        AuthService().securedApi.getExerciseList(listId: controller.exerciseListId).then((exercise) {
          completer.complete(exercise);
        }).catchError((e) {
          completer.completeError(e);
        });
      }
    }

    completer.future.then((exerciseList) {
      controller.handleChanges(exerciseList);
    }).catchError((e) {
      showToast(
        FlutterI18n.translate(context, TranslationKeys.errorLoadingList),
      );
    });

    return completer.future;
  }

}