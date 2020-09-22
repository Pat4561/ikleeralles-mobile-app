import 'package:flutter/foundation.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:ikleeralles/logic/operations/abstract.dart';
import 'package:ikleeralles/logic/managers/extensions.dart';

class OperationManager<T extends Operation> extends Model {

  T _operation;

  T Function() operationBuilder;

  LoadingDelegate loadingDelegate = LoadingDelegate();

  OperationManager ({ @required this.operationBuilder }) {
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
    this._operation = this.operationBuilder();
  }


}
