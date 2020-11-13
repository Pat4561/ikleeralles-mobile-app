import 'package:flutter/foundation.dart';

class CachedValueNotifier<T> {

  ValueNotifier<T> _innerNotifier;

  ValueNotifier<T> get innerNotifier => _innerNotifier;

  List<T> _stack = [];

  T _initialValue;

  CachedValueNotifier(T value) {
    _initialValue = value;
    _innerNotifier = ValueNotifier<T>(_initialValue);
    _stack.add(value);
  }

  void removeFromStack(T value) {
    _stack.remove(value);
  }

  T get value => _innerNotifier.value;

  set value (T value) {
    _innerNotifier.value = value;
    _stack.add(value);
  }

  T get previous {
    int currentIndex = _stack.indexOf(_innerNotifier.value);
    if (currentIndex > 0) {
      return _stack[currentIndex - 1];
    }
    return null;
  }

  T get next {
    int currentIndex = _stack.indexOf(_innerNotifier.value);
    int nextIndex = currentIndex + 1;
    if (nextIndex < _stack.length) {
      return _stack[nextIndex];
    }
    return null;
  }

  bool isInitialValue(T value) => _initialValue == value;

  bool isFirstValue(T value) => _stack.first == value;

}