import 'package:flutter/material.dart';

class Option {

  int code;
  String name;
  String description;

  Option (this.name, this.code, { this.description });

  @override
  String toString() {
    return name;
  }

}


typedef GroupControllerBuilder<T> = Widget Function(BuildContext context, { T groupValue, List<T> availableOptions, Function(T) updateCallback });

class GroupController<T> {

  List<T> _options;

  ValueNotifier<T> _notifier;


  GroupController ({ @required List<T> options, T selectedOption }) {
    _options = options;
    _notifier = ValueNotifier<T>(selectedOption ?? _options.first);
  }

  void _updateValue(T value) {
    _notifier.value = value;
  }

  Widget build({ GroupControllerBuilder<T> builder }) {
    return ValueListenableBuilder(
      valueListenable: _notifier,
      builder: (BuildContext context, T result, Widget widget) {
        return builder(
            context,
            groupValue: _notifier.value,
            availableOptions: _options,
            updateCallback: (option) => _updateValue(option)
        );
      },
    );
  }

}
