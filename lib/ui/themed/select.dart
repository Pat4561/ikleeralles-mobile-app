import 'package:flutter/material.dart';
import 'package:ikleeralles/constants.dart';


class ThemedSelect extends StatelessWidget  {

  final String labelText;
  final String placeholder;
  final double height;
  final double iconContainerWidth;
  final Function onPressed;


  ThemedSelect ({ @required this.placeholder, this.labelText, this.height = 24, this.iconContainerWidth = 30, this.onPressed });

  TextStyle textStyle({ FontWeight fontWeight = FontWeight.bold, double fontSize = 14, Color color = Colors.white}) {
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
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(
              10
          ),
          color: Colors.white
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(10),
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
          Text(this.labelText, style: textStyle()),
          button(context)
        ],
      );
    } else {
      return button(context);
    }
  }

}