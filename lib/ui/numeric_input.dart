import 'package:flutter/material.dart';

typedef SideBarIconBuilder = Widget Function(BuildContext context);

class NumericInputSideBarConfig {

  final SideBarIconBuilder leftIconBuilder;
  final SideBarIconBuilder rightIconBuilder;

  NumericInputSideBarConfig ({ this.leftIconBuilder, this.rightIconBuilder });

}

class NumericInput extends StatelessWidget {

  final double height;
  final double width;
  final double sideBarWidth;
  final BoxDecoration decoration;
  final BoxDecoration midSectionDecoration;
  final NumericInputSideBarConfig sideBarConfig;
  final Function(BuildContext context) onLeftButtonPressed;
  final Function(BuildContext context) onRightButtonPressed;
  final int value;
  final TextStyle textStyle;

  NumericInput ({ @required this.value, @required this.onLeftButtonPressed, @required this.onRightButtonPressed,
    this.height = 30, this.width = 110, this.sideBarWidth = 30, this.decoration, this.midSectionDecoration, this.sideBarConfig, this.textStyle });

  Widget sideBar(BuildContext context, { @required SideBarIconBuilder sideBarIconBuilder, @required Function onPressed }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        child: Container(
            width: sideBarWidth,
            child: Center(
              child: sideBarIconBuilder(context),
            )
        ),
        onTap: () => onPressed(context),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: this.height,
      width: this.width,
      decoration: decoration,
      child: Row(
        children: <Widget>[
          sideBar(context,
              sideBarIconBuilder: (BuildContext context) {
                if (this.sideBarConfig != null && this.sideBarConfig.leftIconBuilder != null) {
                  return this.sideBarConfig.leftIconBuilder(context);
                }
                return Icon(Icons.remove, size: 17);
              },
              onPressed: this.onLeftButtonPressed
          ),
          Expanded(
            child: Container(
              decoration: midSectionDecoration,
              child: Center(
                child: Text(
                  this.value.toString(),
                  style: this.textStyle,
                ),
              ),
            ),
          ),
          sideBar(
              context,
              sideBarIconBuilder: (BuildContext context) {
                if (this.sideBarConfig != null && this.sideBarConfig.rightIconBuilder != null) {
                  return this.sideBarConfig.rightIconBuilder(context);
                }
                return Icon(Icons.add, size: 17);
              },
              onPressed: this.onRightButtonPressed
          )
        ],
      ),
    );
  }

}
