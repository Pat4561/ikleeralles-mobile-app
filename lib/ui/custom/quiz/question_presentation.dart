import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:ikleeralles/constants.dart';
import 'package:ikleeralles/logic/quiz/input.dart';
import 'package:ikleeralles/logic/quiz/speech.dart';
import 'package:ikleeralles/network/api/url.dart';
import 'package:ikleeralles/ui/hyperlink.dart';
import 'package:ikleeralles/ui/snackbar.dart';

class QuizQuestionPresentation extends StatefulWidget {

  final QuizQuestion question;
  final WidgetBuilder formBuilder;
  final String hint;


  QuizQuestionPresentation (this.question, { this.hint, this.formBuilder });

  @override
  State<StatefulWidget> createState() {
    return QuizQuestionPresentationState();
  }

}

class QuizQuestionPresentationState extends State<QuizQuestionPresentation> {

  SpeechPlayer _speechPlayer;

  @override
  void initState() {
    _speechPlayer = SpeechPlayer(
      language: widget.question.language
    );
    super.initState();
  }

  void _playSound(BuildContext context) {
    _speechPlayer.play(
      widget.question.title
    ).catchError((e) {
      showToast(FlutterI18n.translate(context, TranslationKeys.errorSubTitle));
    });
  }

  Widget _titlePresentation(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(child: Text(widget.question.title, style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            fontFamily: Fonts.ubuntu
        ))),
        Container(
          child: IconButton(
            icon: Icon(Icons.volume_up),
            onPressed: () => _playSound(context),
          ),
          margin: EdgeInsets.only(
              left: 15
          ),
        )
      ],
    );
  }

  Widget _hintPresentation(BuildContext context) {
    return Visibility(
      child: _HintPresentation(
        hint: widget.hint,
      ),
      visible: widget.hint != null,
    );
  }

  Widget _form(BuildContext context) {
    if (widget.formBuilder != null) {
      var formWidget = widget.formBuilder(context);
      if (formWidget != null) {
        return formWidget;
      }
    }
    return Container();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        _titlePresentation(context),
        _hintPresentation(context),
        _form(context)
      ],
    );
  }

}

class _HintPresentation extends StatefulWidget {

  final String hint;

  _HintPresentation ({ @required this.hint });

  @override
  State<StatefulWidget> createState() {
    return _HintPresentationState();
  }

}

class _HintPresentationState extends State<_HintPresentation> {

  bool _isHintVisible = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Hyperlink(
        baseColor: Colors.grey,
        highlightedColor: BrandColors.secondaryButtonColor,
        onPressed: () {
          setState(() {
            _isHintVisible = !_isHintVisible;
          });
        },
        builder: (bool isSelected, Color color) {
          return Row(
            children: <Widget>[
              Icon(Icons.remove_red_eye, color: color),
              Container(
                margin: EdgeInsets.only(
                    left: 10
                ),
                child: Text(
                  _isHintVisible ? widget.hint : FlutterI18n.translate(context, TranslationKeys.showHint),
                  style: TextStyle(
                      color: color,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      fontFamily: Fonts.ubuntu
                  ),
                ),
              )
            ],
          );
        },
      ),
    );
  }

}