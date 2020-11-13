import 'package:flutter/material.dart';
import 'package:ikleeralles/logic/cached_value_notifier.dart';

abstract class DialogFragment {

  Widget builder(BuildContext context);

}

class DialogFragmentsManager {

  CachedValueNotifier<DialogFragment> _fragmentUpdateNotifier;

  CachedValueNotifier<DialogFragment> get fragmentUpdateNotifier => _fragmentUpdateNotifier;

  DialogFragmentsManager(DialogFragment initialFragment) {
    _fragmentUpdateNotifier = CachedValueNotifier<DialogFragment>(initialFragment);
  }

  bool get canGoBack => !_fragmentUpdateNotifier.isFirstValue(_fragmentUpdateNotifier.value);

  void goBack() {
    _fragmentUpdateNotifier.value = _fragmentUpdateNotifier.previous;
  }

  void presentNew(DialogFragment fragment) {
    _fragmentUpdateNotifier.value = fragment;
  }

}

abstract class DialogAppBarBuilder {

  Widget builder(BuildContext context, DialogFragmentsManager fragmentsManager);

}

class DefaultDialogAppBarBuilder extends DialogAppBarBuilder {

  final Color iconColor;
  final Color backgroundColor;

  DefaultDialogAppBarBuilder ({ this.iconColor, this.backgroundColor });

  @override
  Widget builder(BuildContext context, DialogFragmentsManager fragmentsManager) {
    return Visibility(
      visible: fragmentsManager.canGoBack,
      child: AppBar(
        leading: IconButton(icon: Icon(Icons.chevron_left, color: iconColor), onPressed: () => fragmentsManager.goBack()),
        elevation: 0,
        backgroundColor: backgroundColor,
      ),
    );
  }

}

class NavigationDialog extends StatelessWidget {

  final double elevation;
  final RoundedRectangleBorder shape;
  final DialogFragmentsManager fragmentsManager;
  final DialogAppBarBuilder appBarBuilder;

  NavigationDialog ({ this.elevation, this.shape, this.fragmentsManager, this.appBarBuilder });



  @override
  Widget build(BuildContext context) {
    return Dialog(
      elevation: elevation,
      shape: shape,
      child: ValueListenableBuilder(
        valueListenable: fragmentsManager.fragmentUpdateNotifier.innerNotifier,
        builder: (BuildContext context, DialogFragment fragment, Widget widget) {
          return Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                appBarBuilder.builder(context, fragmentsManager),
                fragment.builder(context)
              ],
            ),
          );
        },
      ),
    );
  }

}
