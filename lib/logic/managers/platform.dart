import 'dart:async';
import 'package:scoped_model/scoped_model.dart';
import 'package:ikleeralles/network/auth/service.dart';

class SetInputTypeProvider {

  String defaultValue() {
    return "Nederlands";
  }

  List<String> all() {
    return ["Nederlands", "Duits", "Frans"];
  }

}

class PlatformDataConstants {

  static List<String> years = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "Anders"];
  static List<String> levels = ["basisschool","vwo","havo","vmbo-t","vmbo-gt","vmbo-k","vmbo-b","a","a2/b1","lwoo/vmbo-b","lwoo/vmbo-bk",
    "vmbo-b/lwoo","vmbo-gt/havo","vmbo-kgt/havo","vmbo-t/havo","havo/vwo","mbo","universiteit","vavo","cursus"];

}

class PlatformDataProvider extends Model {

  List<String> years = PlatformDataConstants.years;
  List<String> levels = PlatformDataConstants.levels;

  Completer _completer;

  Future load() {
    if (_completer != null && !_completer.isCompleted) {
      return _completer.future;
    }

    _completer = Completer();
    AuthService().securedApi.getLevels().then((values) {
      this.levels = values;
      _completer.complete();
    }).catchError((e) {
      _completer.completeError(e);
    }).whenComplete(() {
      notifyListeners();
    });

    return _completer.future;
  }

}