import 'package:flutter/material.dart';
import 'package:ikleeralles/constants.dart';

class Hyperlink extends StatefulWidget {

  final Color baseColor;
  final Color highlightedColor;
  final Color selectedColor;
  final bool selected;
  final VoidCallback onPressed;
  final Function(bool isHighlighted, Color currentColor) builder;

  Hyperlink ({this.baseColor, Key key, this.builder, this.selectedColor, this.selected = false, @required this.onPressed, this.highlightedColor}) :
        super(key: key);

  @override
  State<StatefulWidget> createState() {
    return HyperlinkState();
  }

  Widget buildWidget(bool highlighted, Color currentColor) {
    if (this.builder != null) {
      return this.builder(highlighted, currentColor);
    }
    return null;
  }

}

//This is not a private state because it needs to be modified by other classes (votes), in case a reset is required
class HyperlinkState extends State<Hyperlink> {

  Color _currentColor;
  bool _highlighted;

  @override
  void initState() {
    super.initState();
    selected = widget.selected;
    highlighted = false;
  }

  set highlighted (bool value) {
    _highlighted = value;
    _currentColor = value ? widget.highlightedColor : (widget.selected ? widget.selectedColor : widget.baseColor);
  }

  bool get highlighted {
    return _highlighted;
  }

  set selected (bool value) {
    _currentColor = value ? widget.selectedColor : widget.baseColor;
  }

  Color get currentColor {
    return _currentColor;
  }


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: widget.buildWidget(highlighted, currentColor),
      onTapDown: (e) {
        setState(() {
          highlighted = true;
        });
      },
      onTapUp: (e) {
        setState(() {
          highlighted = false;
        });
      },
      onTap: () {
        widget.onPressed();
      },
      onTapCancel: () {
        setState(() {
          highlighted = false;
        });
      },
    );
  }
}

class IconHyperlink extends Hyperlink {

  final IconData iconData;

  IconHyperlink ({this.iconData, Key key, bool selected = false, Color baseColor, @required VoidCallback onPressed, Color highlightedColor})
      : super(baseColor: baseColor, onPressed: onPressed, highlightedColor: highlightedColor, selected: selected, key: key);

  @override
  Widget buildWidget(bool highlighted, Color currentColor) {
    return Icon(this.iconData, color: currentColor);
  }

}

class TextHyperlink extends Hyperlink {

  final String title;
  final double fontSize;

  TextHyperlink ({this.title, this.fontSize = 14,   Key key, bool selected = false, Color baseColor, @required VoidCallback onPressed, Color highlightedColor})
      : super(baseColor: baseColor, onPressed: onPressed, highlightedColor: highlightedColor, selected: selected, key: key);

  @override
  Widget buildWidget(bool highlighted, Color currentColor) {
    return Text(
      title,
      style: TextStyle(
        color: currentColor,
        fontSize: fontSize,
        fontFamily: Fonts.ubuntu,
        fontWeight: FontWeight.w600
      ),
    );
  }

}
