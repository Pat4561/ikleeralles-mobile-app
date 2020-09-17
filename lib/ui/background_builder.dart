import 'package:flutter/material.dart';
import 'package:ikleeralles/constants.dart';

class BackgroundBuilder {

  static const Color defaultBackgroundColor = Color.fromRGBO(240, 240, 240, 1);

  static Widget build({ Color backgroundColor = BackgroundBuilder.defaultBackgroundColor, Widget widget, Alignment alignment = Alignment.center }) {
    return Container(
      color: backgroundColor,
      child: Stack(
        children: <Widget>[
          Align(
              alignment: alignment,
              child: Container(
                child: widget,
                constraints: BoxConstraints(
                    maxWidth: 300
                ),
              )
          )
        ],
      ),
    );
  }

  static Widget buildWithColumn({ Color backgroundColor = BackgroundBuilder.defaultBackgroundColor, Alignment alignment = Alignment.center, @required List<Widget> children }) {
    return build(
        backgroundColor: backgroundColor,
        alignment: alignment,
        widget: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: children,
        )
    );
  }

  static Widget buildWithTitles({ String title, String subTitle, Color backgroundColor = BackgroundBuilder.defaultBackgroundColor, Alignment alignment = Alignment.center }) {
    return buildWithColumn(
        backgroundColor: backgroundColor,
        alignment: alignment,
        children: [
          Container(
            child: Text(
              title,
              style: TextStyle(
                  fontSize: 18  ,
                  fontFamily: Fonts.montserrat
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 15),
            child: Text(
              title,
              style: TextStyle(
                  fontSize: 15,
                  fontFamily: Fonts.ubuntu
              ),
            ),
          ),
        ]
    );
  }

}