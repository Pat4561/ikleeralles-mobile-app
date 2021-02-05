import 'package:flutter/material.dart';
import 'package:ikleeralles/constants.dart';

class Logo extends StatelessWidget {

  final double fontSize;

  Logo ({ this.fontSize });

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text(
        Constants.appNameWithUrl,
        textAlign: TextAlign.center,
        style: TextStyle(
            color: Colors.black,
            fontSize: this.fontSize ?? 50,
            fontFamily: Fonts.justAnotherHand
        ),
      ),
    );
  }

}