import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:ikleeralles/constants.dart';
import 'package:ikleeralles/ui/themed/button.dart';
import 'package:ikleeralles/ui/themed/textfield.dart';

class CreateFolderDialog extends StatefulWidget {

  final Function(String) onCreatePressed;

  CreateFolderDialog ({ @required this.onCreatePressed });

  @override
  State<StatefulWidget> createState() {
    return CreateFolderDialogState();
  }

  static void show(BuildContext context, { Function(String) onCreatePressed }) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return CreateFolderDialog(
          onCreatePressed: onCreatePressed,
        );
      }
    );
  }

}

class CreateFolderDialogState extends State<CreateFolderDialog> {

  final TextEditingController nameTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      elevation: 5,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10)
      ),
      child: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(20),
              child: Text(
                FlutterI18n.translate(context, TranslationKeys.folderCreateTitle),
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  fontFamily: Fonts.ubuntu,
                ),
              ),
              decoration: BoxDecoration(
                  border: Border(
                      bottom: BorderSide(
                          color: BrandColors.borderColor
                      )
                  )
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(
                  vertical: 5,
                  horizontal: 20
              ),
              child: ThemedTextField(
                textEditingController: nameTextController,
                hintText: FlutterI18n.translate(context, TranslationKeys.folderCreatePlaceholder),
                customBorderSide: BorderSide(
                    color: BrandColors.borderColor,
                    width: 1
                ),
                borderRadius: 15,
              ),
            ),
            Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                  border: Border(
                      top: BorderSide(
                          color: BrandColors.borderColor
                      )
                  )
              ),
              child: Row(
                children: <Widget>[
                  ThemedButton(
                    FlutterI18n.translate(context, TranslationKeys.create),
                    buttonColor: BrandColors.primaryButtonColor,
                    labelColor: Colors.white,
                    fontSize: 15,
                    contentPadding: EdgeInsets.symmetric(
                        vertical: 5,
                        horizontal: 20
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                    onPressed: () {
                      if (this.widget.onCreatePressed != null) {
                        this.widget.onCreatePressed(nameTextController.text);
                      }
                    },
                  ),
                  Spacer(),
                  FlatButton(
                    child: Text(FlutterI18n.translate(context, TranslationKeys.cancel), style: TextStyle(
                        fontFamily: Fonts.ubuntu,
                        fontSize: 15
                    )),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

}