import 'package:flutter/foundation.dart';
import 'package:scoped_model/scoped_model.dart';

class LoadingDelegate extends Model {

  final ValueNotifier valueNotifier = ValueNotifier(false);

  LoadingDelegate () {
    valueNotifier.addListener(() {
      notifyListeners();
    });
  }

  set isLoading (bool value) {
    valueNotifier.value = value;
  }

  bool get isLoading {
    return valueNotifier.value;
  }

  void attachFuture(Future future) {
    isLoading = true;
    future.whenComplete(() => isLoading = false);
  }
}

class SelectionManager<T> extends Model {

  List<T> objects = new List<T>();

  void toggle(T object) {
    if (objects.contains(object)) {
      objects.remove(object);
    } else {
      objects.add(object);
    }
    notifyListeners();
  }

  void selectAll(List<T> objects) {
    this.objects = [];
    this.objects.addAll(objects);
    notifyListeners();
  }

  void unSelectAll() {
    this.objects = [];
    notifyListeners();
  }

}