import 'package:flutter/material.dart';
import 'package:ikleeralles/constants.dart';
import 'package:ikleeralles/ui/bottomsheets/options.dart';


class ThemedSelect extends StatelessWidget  {

  final String labelText;
  final String placeholder;
  final double height;
  final double iconContainerWidth;
  final double radius;
  final Function onPressed;
  final Color color;
  final Color textColor;
  final BoxDecoration boxDecoration;


  ThemedSelect ({ @required this.placeholder, this.textColor, this.boxDecoration, this.labelText, this.color = Colors.white, this.height = 24, this.radius = 10, this.iconContainerWidth = 30, this.onPressed });

  static Widget selectBox({ String labelText, ValueNotifier<String> notifier, List<String> options }) {
    return ValueListenableBuilder(
        valueListenable: notifier,
        builder: (BuildContext context, String value, Widget widget) {
          return ThemedSelect(
              placeholder: notifier.value,
              labelText: labelText,
              onPressed: (BuildContext context) {
                OptionsBottomSheetPresenter<String>(
                    title: labelText,
                    items: options,
                    selectedItem: notifier.value,
                    onPressed: (item) {
                      Navigator.pop(context);
                      notifier.value = item;
                    }
                ).show(context);
              }
          );
        }
    );
  }


  TextStyle textStyle({ FontWeight fontWeight = FontWeight.w600, double fontSize = 14, Color color = Colors.white}) {
    return TextStyle(
        color: color,
        fontFamily: Fonts.ubuntu,
        fontSize: fontSize,
        fontWeight: fontWeight
    );
  }

  Widget button(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
          top: 10
      ),
      decoration: boxDecoration ?? BoxDecoration(
          borderRadius: BorderRadius.circular(
              radius
          ),
          color: color
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(radius),
          child: Container(
            height: height,
            child: Row(
              children: <Widget>[
                Expanded(
                    child: Container(
                      child: Text(this.placeholder, style: textStyle(
                          color: BrandColors.textColorLighter
                      )),
                      margin: EdgeInsets.only(
                          left: 12
                      ),
                    )
                ),
                Container(
                  width: iconContainerWidth,
                  height: height,
                  margin: EdgeInsets.only(
                      right: 5
                  ),
                  child: Icon(Icons.keyboard_arrow_down),
                )
              ],
            ),
          ),
          onTap: () {
            onPressed(context);
          },
        ),
      ),
    );
  }



  @override
  Widget build(BuildContext context) {
    if (this.labelText != null) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Text(this.labelText, style: textStyle(color: textColor ?? Colors.white)),
          button(context)
        ],
      );
    } else {
      return button(context);
    }
  }

}