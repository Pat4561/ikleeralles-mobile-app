import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:ikleeralles/constants.dart';

class LoadingOverlay extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.5)
      ),
      child: Center(
          child: Container(
            padding: EdgeInsets.all(30),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                CircularProgressIndicator(),
                SizedBox(height: 30),
                Text(FlutterI18n.translate(context, TranslationKeys.loadingInProgress), style: TextStyle(
                    fontFamily: Fonts.ubuntu,
                    fontWeight: FontWeight.bold,
                    fontSize: 15
                ))
              ],
            ),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.white.withOpacity(0.9)
            ),
          )
      ),
    );
  }

}