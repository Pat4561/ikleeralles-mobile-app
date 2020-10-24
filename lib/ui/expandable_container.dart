import 'package:flutter/material.dart';

class ExpandableContainer extends StatefulWidget {

  final double unExpandedHeight;
  final double expandedHeight;
  final Widget Function(BuildContext context, { bool isExpanded }) builder;
  final bool isExpanded;


  ExpandableContainer ({ @required this.unExpandedHeight, @required this.expandedHeight, @required this.builder, this.isExpanded = false, GlobalKey key  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return ExpandableContainerState();
  }

}

class ExpandableContainerState extends State<ExpandableContainer> {

  ValueNotifier<bool> _expansionNotifier;

  @override
  void initState() {
    super.initState();
    _expansionNotifier = ValueNotifier<bool>(widget.isExpanded);
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: this._expansionNotifier,
      builder: (BuildContext context, bool isExpanded, Widget widget) {
        return Container(
          height: isExpanded ? this.widget.expandedHeight : this.widget.unExpandedHeight,
          child: this.widget.builder(context, isExpanded: isExpanded),
        );
      },
    );
  }

  void unExpand() {
    _expansionNotifier.value = false;
  }

  void expand() {
    _expansionNotifier.value = true;
  }

}