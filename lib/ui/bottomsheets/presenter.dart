import 'package:flutter/material.dart';
import 'package:ikleeralles/constants.dart';

class BottomSheetHeader extends StatelessWidget {

  final EdgeInsets padding;
  final String title;
  final Widget child;
  final Color borderColor;
  final double borderSize;
  final BoxDecoration decoration;

  BottomSheetHeader ({ this.padding, this.title, this.child, this.borderColor, this.borderSize, this.decoration }) {
    assert(child != null || title != null, "There should be either a child or title supplied");
  }

  Widget _titleLabel(BuildContext context) {
    return Text(
      this.title,
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        fontFamily: Fonts.ubuntu,
      ),
      textAlign: TextAlign.start,
    );
  }

  Widget _body(BuildContext context) {
    if (title != null) {
      return _titleLabel(context);
    } else {
      return child;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding ?? EdgeInsets.symmetric(
          vertical: 20,
          horizontal: 20
      ),
      child: _body(context),
      decoration: decoration ?? BoxDecoration(
          border: Border(
              bottom: BorderSide(
                  width: borderSize ?? 1,
                  color: borderColor ?? Colors.white
              )
          )
      ),
    );
  }

}


abstract class BottomSheetPresenter {

  Widget header(BuildContext context);

  Widget body(BuildContext context);

  void show(BuildContext context) {
    showModalBottomSheet(
        builder: (BuildContext context) {
          return Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                header(context),
                Expanded(
                  child: body(context),
                )
              ],
            ),
          );
        },
        context: context
    );
  }

}