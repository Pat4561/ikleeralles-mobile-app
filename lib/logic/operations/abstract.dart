import 'dart:async';

enum OperationRunningState {
  idle,
  running,
  completed
}

class OperationState<T> {

  final T result;
  final dynamic error;
  final OperationRunningState operationRunningState;

  OperationState ({ this.result, this.error, this.operationRunningState });
}

abstract class Operation<T> {

  OperationRunningState _operationRunningState = OperationRunningState.idle;
  T _result;
  dynamic _error;

  Completer<T> _innerCompleter;

  Future execute() {
    if (_innerCompleter != null) {
      return _innerCompleter.future;
    }

    _innerCompleter = Completer<T>();
    _operationRunningState = OperationRunningState.running;
    perform().then((value) {
      _result = value;
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

}
