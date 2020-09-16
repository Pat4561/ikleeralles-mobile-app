import 'package:flutter/material.dart';
import 'package:ikleeralles/constants.dart';

class ThemedButton extends StatelessWidget {

  final String labelText;
  final Color buttonColor;
  final Color labelColor;
  final double fontSize;
  final bool filled;
  final Function() onPressed;
  final EdgeInsets contentPadding;
  final BorderSide borderSide;
  final BorderRadius borderRadius;


  ThemedButton (this.labelText, { this.onPressed, this.contentPadding, this.buttonColor, this.fontSize, this.labelColor, this.borderSide, this.borderRadius, this.filled = true });

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      color: filled ? buttonColor : Colors.transparent,
      padding: contentPadding,
      shape: RoundedRectangleBorder(
          borderRadius: borderRadius ?? BorderRadius.all(Radius.circular(0)),
          side: borderSide ?? filled ? BorderSide.none : BorderSide(color: buttonColor),
      ),
      child: Text(
        labelText,
        style: TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.w600,
            fontFamily: Fonts.ubuntu,
            color: labelColor ?? filled ? Colors.white : buttonColor
        ),
      ),
      onPressed: onPressed,
    );
  }

}
