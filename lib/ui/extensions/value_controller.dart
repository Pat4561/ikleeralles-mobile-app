import 'package:flutter/material.dart';


typedef ValueControllerBuilder<T> = Widget Function(BuildContext context, { T selectedValue, Function(T) updateCallback });

class ValueController<T> {

  ValueNotifier<T> _notifier;

  T get value => _notifier.value;

  ValueController(T value) {
    _notifier = ValueNotifier<T>(value);
  }

  void notify({ T value }) {
    if (value != _notifier.value) {
      _notifier.value = value;
    } else {
      _notifier.notifyListeners();
    }
  }

  void onChange(Function event) {
    _notifier.addListener(event);
  }

  void _updateValue(T value) {
    _notifier.value = value;
  }

  Widget build({ ValueControllerBuilder<T> builder }) {
    return ValueListenableBuilder(
      valueListenable: _notifier,
      builder: (BuildContext context, T result, Widget widget) {
        return builder(
            context,
            selectedValue: _notifier.value,
            updateCallback: (option) => _updateValue(option)
        );
      },
    );
  }

}
