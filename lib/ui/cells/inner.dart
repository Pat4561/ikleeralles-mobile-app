import 'package:flutter/material.dart';
import 'package:ikleeralles/constants.dart';

class InnerCell extends StatelessWidget {

  final Widget leading;
  final Widget trailing;
  final String title;
  final String subTitle;

  InnerCell ({ @required this.leading, this.trailing, @required this.title, this.subTitle });

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: <Widget>[
          Container(
            child: this.leading,
            margin: EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 10
            ),
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(
                  vertical: 10
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Container(
                    child: Text(
                      this.title,
                      style: TextStyle(
                          fontSize: 16,
                          fontFamily: Fonts.montserrat,
                          fontWeight: FontWeight.w600
                      ),
                    ),
                  ),
                  Visibility(
                    child: Container(
                      margin: EdgeInsets.only(top: 4),
                      child: Text(
                        this.subTitle ?? "",
                        style: TextStyle(
                            fontSize: 12,
                            fontFamily: Fonts.montserrat,
                            fontWeight: FontWeight.w500
                        ),
                      ),
                    ),
                    visible: this.subTitle != null,
                  )
                ],
              ),
            ),
          ),
          Visibility(child: Container(
            margin: EdgeInsets.symmetric(horizontal: 20),
            child: this.trailing ?? Container(),
          ), visible: this.trailing != null)
        ],
      ),
    );
  }

}
