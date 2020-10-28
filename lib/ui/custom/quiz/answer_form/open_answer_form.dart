import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:ikleeralles/constants.dart';
import 'package:ikleeralles/ui/custom/quiz/answer_form/abstract.dart';
import 'package:ikleeralles/ui/themed/textfield.dart';

class OpenAnswerForm extends AnswerForm {

  final Function onEnterPressed;

  OpenAnswerForm ({ GlobalKey key, this.onEnterPressed }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return OpenAnswerFormState();
  }

}


class OpenAnswerFormState extends AnswerFormState<String, OpenAnswerForm> {

  final TextEditingController controller = TextEditingController();

  @override
  String getAnswer() {
    return controller.text;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        top: 30
      ),
      child: ThemedTextField(
        textEditingController: controller,
        hintText: FlutterI18n.translate(context, TranslationKeys.answer),
        focusedColor: BrandColors.secondaryButtonColor,
        onEditingComplete: () {
          if (widget.onEnterPressed != null) {
            widget.onEnterPressed();
          }
        },
      ),
    );
  }

}