import 'package:flutter/material.dart';
import 'package:ikleeralles/constants.dart';


abstract class Badge extends StatelessWidget {

  final double size;
  final Color backgroundColor;
  final bool usesBoxShadow;

  Badge ({ this.size, this.backgroundColor, this.usesBoxShadow = true });

  Widget buildContent(BuildContext context);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(size / 2),
        color: backgroundColor ?? BrandColors.secondaryButtonColor,
        boxShadow: usesBoxShadow ? [
          BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 0.7,
              blurRadius: 3
          ),
        ] : [],
      ),
      child: Center(
        child: buildContent(context),
      ),
    );
  }

}

abstract class ButtonBadge extends Badge {

  final Function onPressed;

  ButtonBadge ({ this.onPressed, double size, Color backgroundColor, bool usesBoxShadow = true }) : super(
    size: size,
    backgroundColor: backgroundColor,
    usesBoxShadow: usesBoxShadow,
  );

  Widget buttonContent(BuildContext context);

  @override
  Widget buildContent(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(size / 2),
      child: Container(
        child: Material(
          child: InkWell(
            onTap: onPressed,
            child: Container(
              width: size,
              height: size,
              child: Center(
                child: buttonContent(context),
              ),
            ),
          ),
          color: Colors.transparent,
        ),
      ),
    );
  }

}

class TextBadge extends ButtonBadge {

  final String text;
  final TextStyle textStyle;

  TextBadge ({ this.text, this.textStyle, Function onPressed, double size, Color backgroundColor, bool usesBoxShadow = true }) : super(
      onPressed: onPressed,
      size: size,
      backgroundColor: backgroundColor,
      usesBoxShadow: usesBoxShadow
  );

  @override
  Widget buttonContent(BuildContext context) {
    return Text(text, style: textStyle ?? TextStyle(
        color: Colors.white,
        fontFamily: Fonts.ubuntu,
        fontWeight: FontWeight.bold,
        fontSize: 17
    ));
  }

}


class IconBadge extends ButtonBadge {

  final Widget Function(BuildContext) iconBuilder;

  IconBadge ({ this.iconBuilder, Function onPressed, double size, Color backgroundColor, bool usesBoxShadow = true }) : super(
      onPressed: onPressed,
      size: size,
      backgroundColor: backgroundColor,
      usesBoxShadow: usesBoxShadow
  );

  @override
  Widget buttonContent(BuildContext context) {
    return iconBuilder(context);
  }

}

