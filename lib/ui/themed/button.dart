import 'package:flutter/material.dart';
import 'package:ikleeralles/constants.dart';

class ThemedButton extends StatelessWidget {

  final String labelText;
  final Color buttonColor;
  final Color labelColor;
  final double iconSize;
  final IconData icon;
  final double fontSize;
  final bool filled;
  final Function() onPressed;
  final EdgeInsets contentPadding;
  final BorderSide borderSide;
  final BorderRadius borderRadius;


  ThemedButton (this.labelText, { this.onPressed, this.contentPadding, this.buttonColor, this.fontSize, this.labelColor, this.borderSide, this.borderRadius, this.filled = true, this.iconSize = 20, this.icon });

  Widget textWidget() {
    return Text(
      labelText,
      style: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.w600,
          fontFamily: Fonts.ubuntu,
          color: labelColor ?? (filled ? Colors.white : buttonColor)
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      color: filled ? buttonColor : Colors.transparent,
      padding: contentPadding,
      shape: RoundedRectangleBorder(
          borderRadius: borderRadius ?? BorderRadius.all(Radius.circular(0)),
          side: borderSide ?? (filled ? BorderSide.none : BorderSide(color: buttonColor)),
      ),
      child: () {
        if (this.icon != null) {
          return Row(
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(
                  right: 5
                ),
                child: Icon(icon, size: iconSize, color: labelColor ?? (filled ? Colors.white : buttonColor)),
              ),
              textWidget()
            ],
          );
        } else {
          return textWidget();
        }

      }(),
      onPressed: onPressed,
    );
  }

}
