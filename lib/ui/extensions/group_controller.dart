import 'package:flutter/material.dart';

class CustomOption<T> {

  final T key;
  final String name;
  final String description;

  CustomOption(this.name, this.key, { this.description });

  @override
  String toString() {
    return this.name;
  }

}

class Option extends CustomOption<int> {

  Option (String name, int code, { String description }) : super(name, code, description: description);

}


typedef GroupControllerBuilder<T> = Widget Function(BuildContext context, { T groupValue, List<T> availableOptions, Function(T) updateCallback });

class GroupController<T> {

  List<T> _options;

  ValueNotifier<T> _notifier;

  T get value => _notifier.value;

  GroupController ({ @required List<T> options, T selectedOption }) {
    _options = options;
    _notifier = ValueNotifier<T>(selectedOption ?? _options.first);
  }

  void onChange(Function event) {
    _notifier.addListener(event);
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
