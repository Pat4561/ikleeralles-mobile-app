import 'dart:async';

enum OperationRunningState {
  idle,
  running,
  completed
}

class OperationState<T> {

  T _result;

  T get result {
    return _result;
  }

  final dynamic error;
  final OperationRunningState operationRunningState;

  OperationState ({ T result, this.error, this.operationRunningState }) {
    _result = result;
  }

  void restoreResult(T result) {
    this._result = result;
  }
}

abstract class Operation<T> {

  OperationRunningState _operationRunningState = OperationRunningState.idle;
  T _result;
  dynamic _error;


  Completer<T> _innerCompleter;

  T Function (T value) orderItems;

  Operation ({ this.orderItems });

  Future execute() {
    if (_innerCompleter != null) {
      return _innerCompleter.future;
    }

    _innerCompleter = Completer<T>();
    _operationRunningState = OperationRunningState.running;
    perform().then((value) {
      _result = order(value);
      _innerCompleter.complete(value);
    }).catchError((e) {
      _error = e;
      _innerCompleter.completeError(e);
    }).whenComplete(() {
      _operationRunningState = OperationRunningState.completed;
    });
    return _innerCompleter.future;
  }

  Future<T> perform();

  OperationState<T> get currentState {
    return OperationState<T>(
        operationRunningState: _operationRunningState,
        error: _error,
        result: _result
    );
  }

  T order(T value) {
    if (this.orderItems != null)
      return this.orderItems(value);
    return value;
  }
}
