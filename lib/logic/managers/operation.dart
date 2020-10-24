import 'package:flutter/foundation.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:ikleeralles/logic/operations/abstract.dart';
import 'package:ikleeralles/logic/managers/extensions.dart';

class OperationManager<T extends Operation> extends Model {

  T _operation;

  T Function() operationBuilder;

  Function onReset;

  LoadingDelegate loadingDelegate = LoadingDelegate();

  OperationManager ({ @required this.operationBuilder, this.onReset }) {
    reset();
  }

  OperationState get currentState {
    return _operation.currentState;
  }

  Future execute() {
    notifyListeners();
    Future future = _operation.execute();
    loadingDelegate.attachFuture(future);
    future.whenComplete(() {
      notifyListeners();
    });
    return future;
  }

  void reset() {
    if (this.onReset != null) {
      this.onReset();
    }
    this._operation = this.operationBuilder();
  }

  bool insertObject(value, { int index }) {
    if (currentState.result != null) {
      List resultList = currentState.result;
      resultList.insert(index, value);
      notifyListeners();
      return true;
    }
    return false;
  }

  int removeObject(value) {
    if (currentState.result != null) {
      List resultList = currentState.result;
      int indexOf = resultList.indexOf(value);
      resultList.removeAt(indexOf);
      notifyListeners();
      return indexOf;
    }
    return -1;
  }

  List<int> removeObjects(List values) {
    List<int> indices = [];
    if (currentState.result != null) {
      List resultList = currentState.result;
      for (var value in values) {
        int indexOf = resultList.indexOf(value);
        indices.add(indexOf);
        resultList.removeAt(indexOf);
      }

      notifyListeners();
    }
    return indices;
  }

  void restoreResult(value) {
    currentState.restoreResult(value);
    notifyListeners();
  }

}
