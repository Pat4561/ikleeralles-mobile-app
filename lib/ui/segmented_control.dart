import 'package:flutter/material.dart';

typedef SegmentedControlElementBuilder<T> = Widget Function(BuildContext context, T value, bool isSelected);

class SegmentedControlElement extends StatelessWidget {

  final String text;
  final bool isSelected;
  final TextStyle textStyle;
  final Color activeTextColor;
  final Color activeColor;
  final Function onPressed;

  SegmentedControlElement (this.text, { this.isSelected = false, this.textStyle, this.activeTextColor, this.activeColor, this.onPressed });

  TextStyle _textStyle() {

    TextStyle textStyle = TextStyle(
      color: isSelected ? activeTextColor : Colors.black,
    );

    if (this.textStyle != null) {
      textStyle = textStyle.merge(this.textStyle);
    }
    return textStyle;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Material(
        child: InkWell(
          child: Container(
            child: Text(this.text, style: _textStyle()),
            padding: EdgeInsets.symmetric(
                vertical: 8,
                horizontal: 12
            ),
          ),
          onTap: onPressed,
        ),
        color: Colors.transparent,
      ),
      color: isSelected ? activeColor : Colors.transparent,
    );
  }

}

class SegmentedControl<T> extends StatelessWidget {

  final List<T> options;
  final T selectedValue;
  final SegmentedControlElementBuilder<T> elementBuilder;

  SegmentedControl({ @required this.options, @required this.selectedValue, @required this.elementBuilder });

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: this.options.map((v) => elementBuilder(context, v, this.selectedValue == v)).toList(),
      ),
    );
  }

}