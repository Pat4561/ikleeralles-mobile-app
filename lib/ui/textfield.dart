import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:ikleeralles/constants.dart';

class Validators {

  final BuildContext buildContext;

  Validators (this.buildContext);

  String notEmptyValidator(String value) {
    if (value != null && value.isNotEmpty)
      return null;
    return FlutterI18n.translate(this.buildContext, TranslationKeys.emptyTextError);
  }

}

class ThemedTextField extends StatelessWidget {

  final String labelText;
  final String hintText;
  final bool obscureText;
  final TextEditingController textEditingController;
  final Function(String) validator;

  ThemedTextField ({ this.labelText, this.hintText, this.obscureText = false, this.textEditingController, this.validator });

  InputBorder inputBorder({ @required Color borderColor }) {
    return OutlineInputBorder(
      borderSide: BorderSide(
          color: borderColor,
          width: 2
      ),
      borderRadius: BorderRadius.all(Radius.circular(20)),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Text(
          labelText,
          style: TextStyle(
              fontFamily: Fonts.ubuntu,
              fontWeight: FontWeight.w600,
              color: Colors.white,
              fontSize: 15
          ),
        ),
        Container(
          child: TextFormField(
            obscureText: obscureText,
            controller: textEditingController,
            validator: validator,
            style: TextStyle(
                fontFamily: Fonts.ubuntu,
                fontWeight: FontWeight.w600,
                color: BrandColors.textColorLighter,
                fontSize: 14
            ),
            decoration: InputDecoration(
                hintText: hintText,
                filled: true,
                fillColor: Color.fromRGBO(255, 255, 255, 0.7),
                contentPadding: EdgeInsets.symmetric(
                    vertical: 15,
                    horizontal: 20
                ),
                border: inputBorder(borderColor: BrandColors.inputBorderColor),
                enabledBorder: inputBorder(borderColor: BrandColors.inputBorderColor),
                focusedBorder: inputBorder(borderColor: BrandColors.inputFocusedColor),
                errorBorder: inputBorder(borderColor: BrandColors.inputErrorColor)
            ),
          ),
          margin: EdgeInsets.symmetric(
              vertical: 12
          ),
        )
      ],
    );
  }

}