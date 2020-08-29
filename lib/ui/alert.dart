import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:ikleeralles/constants.dart';
import 'package:ikleeralles/ui/button.dart';

class SimpleAlert {

  static void show(BuildContext context, { String title, String message, Function onOkayPressed }) {
    showDialog(
      context: context,
      builder: (BuildContext builderContext) {
        return AlertDialog(
          title: Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              fontFamily: Fonts.ubuntu
            ),
          ),
          content: Text(
            message,
            style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.normal,
                fontFamily: Fonts.ubuntu
            ),
          ),
          actions: <Widget>[
            ThemedButton(
              FlutterI18n.translate(context, TranslationKeys.okay),
              onPressed: () {
                if (onOkayPressed != null)
                  onOkayPressed(builderContext);
              },
              buttonColor: BrandColors.primaryButtonColor,
            )
          ],
        );
      }
    );
  }

}