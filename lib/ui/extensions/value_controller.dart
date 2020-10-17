import 'package:flutter/material.dart';


typedef ValueControllerBuilder<T> = Widget Function(BuildContext context, { T selectedValue, Function(T) updateCallback });

class ValueController<T> {

  ValueNotifier<T> _notifier;

  ValueController(T value) {
    _notifier = ValueNotifier<T>(value);
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
